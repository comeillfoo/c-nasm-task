CC=gcc
CC_LD=gcc
CFLAGS=--std=c18 -pedantic-errors -Wall -Werror -g -O3

ASM=nasm
ASM_LD=ld
ASMFLAGS=-f elf64 -i $(INCDIR)/ -g

SRCDIR=src
BUILDDIR=build

EXECNAME=byter

all: $(EXECNAME)-c $(EXECNAME)-asm

$(EXECNAME)-c: $(BUILDDIR)/$(EXECNAME)-c.o
	$(CC_LD) -o $@ $^

$(BUILDDIR)/%-c.o: $(SRCDIR)/main.c build
	$(CC) -c $(CFLAGS) $< -o $@


$(EXECNAME)-asm: $(BUILDDIR)/$(EXECNAME)-asm.o
	$(ASM_LD) -o $@ $^

$(BUILDDIR)/%-asm.o: $(SRCDIR)/main.asm build
	$(ASM) $(ASMFLAGS) -o $@ $<

build:
	mkdir $(BUILDDIR)

.PHONY: clean

clean:
	rm -f $(EXECNAME)-c
	rm -f $(EXECNAME)-asm
	rm -rf $(BUILDDIR)