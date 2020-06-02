.include "defs.h"
.section .bss
pid: .quad 0
n:   .byte 0			/*Переменная для вывода в консоль цифр */
nforks: .byte 0

.section .text
.global _start

_start:

	movq $5, nforks


fork:
        movq $SYS_FORK, %rax
        syscall
        movl %eax, pid
        cmpb $0,pid
	je parent	/* Процесс родительский, если форк не вернул 0 */

child: 
        movq $nforks, %r10
        movq (%r10), %r11
        addq $0x30, nforks
        movq $nforks, %rbx
        movq (%rbx), %rcx
        movq %rcx, n
        movq %r11, nforks
        movq $SYS_WRITE, %rax
        movq $STDOUT, %rdi
        movq $n, %rsi
        movq $1, %rdx
        syscall			/* Вывод в консоль */
        decq nforks
        cmpq $0,nforks
        je end			/*Если нфорк ==0  то завершаем процесс */
	jmp fork		/* иначе повторяем еще */

parent:
        movq $SYS_WAIT4, %rax
        movq $pid, %rdi
        movq $0, %rsi
        movq $0, %rdx
        movq $0, %r10
        syscall		/* Родительский процесс ждет окончания дочернего */


end:
	movq $SYS_EXIT, %rax
	movq $0, %rdi
	syscall		/* Заканчиваем процесс с кодом 0 */
