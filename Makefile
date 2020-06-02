OBJS = $(patsubst %.s, %.o,$(wildcard *.s))
EXES = $(patsubst %.o,%,$(OBJS))
ASFLAGS = --gdwarf-2 -g -o
LDFLAGS = -static -o
.PHONY: all clean

all: $(EXES)

%.o: %.s
	as $(ASFLAGS) $@ -c $<

$(EXES):%:%.o
	ld $(LDFLAGS) $@ $<

clean:
	rm -f $(EXES) $(OBJS)
