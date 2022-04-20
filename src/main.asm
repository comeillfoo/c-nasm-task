section .text

global _start

exit:
  mov rax, 60 ; 'exit' syscall number
  syscall


_start:
  mov rdi, 0
  jmp exit
