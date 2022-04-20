#!/usr/bin/bash
objdump --disassemble=main -M intel-mnemonic byter-c
objdump --disassemble=print_bin -M intel-mnemonic byter-c