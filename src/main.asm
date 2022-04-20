section .rodata
error_text: db 'error: could not parse input text', 0xA, 0
section .text

global _start


_start:
  ; define buffer for number
  mov rsi, 256
  sub rsp, 256
  mov rdi, rsp
  call read_word
  test rax, rax
  jz .error
  mov rdi, rax
  mov rsi, rdx
  call parse_int
  add rsp, 256
  mov rdi, rax
  test rdx, rdx
  jz .error
  push rdi
  call print_bin
  pop rdi
  call convert
  mov rdi, rax
  call print_bin
  mov rdi, 0
  jmp exit
.error:
  mov rdi, error_text
  call print_string
  mov rdi, -1
  jmp exit


; rdi - number we need to convert in binary ( int )
print_bin:
  mov rsi, rdi
  sub rsp, 34
  mov rdi, rsp
  mov rcx, 1
.loop:
  push rsi
  rol esi, cl
  and esi, 0x1
  add esi, '0'
  mov [rdi + rcx - 1], si
  pop rsi
  inc rcx
  cmp rcx, 33
  jnz .loop
  mov [rdi + rcx - 1], byte 0xA
  inc rcx
  mov [rdi + rcx - 1], byte 0x0
  push rdi
  push rsi
  call print_string
  pop rsi
  pop rdi
  add rsp, 34
  ret

; edi - is convertable number
convert:
    mov r8,  rdi
    and r8, 0xff

    shr rdi, 8
    mov r9,  rdi
    and r9, 0xff
    
    shr rdi, 8
    mov r10, rdi
    and r10, 0xff
    
    shr rdi, 8
    mov r11, rdi
    and r11, 0xff
    
    cmp r8, r9
    jle .n1
    xchg r8, r9
.n1:
    cmp r10, r11
    jle .n2
    xchg r10, r11
.n2:
    cmp r8, r10
    jle .n3
    xchg r8, r10
.n3:
    cmp r9, r11
    jle .n4
    xchg r9, r11
.n4:
    cmp r9, r10
    jle .n5
    xchg r9, r10
.n5:
    xor rax, rax
    
    or rax, r11
    shl rax, 8
    or rax, r10
    shl rax, 8
    or rax, r9
    shl rax, 8
    or rax, r8
    ret

read_char:
    push 0x0
    mov rdx, 1     ; char count
    mov rdi, 0     ; stdin descriptor
    mov rax, 0     ; read syscall number
    mov rsi, rsp   ; destination address
    syscall
    pop rsi        ; the char value
    or rax, rax    ; check if zero bytes read
    jz .err_return
    cmp rax, -1   ; check for errors
    jz .err_return
    mov rax, rsi
    ret
.err_return:
    xor rax, rax
    ret


read_word:
    xor rdx, rdx
    xor rax, rax
.body:
    dec rsi
    jz .maybe_success
    jl .failure
.reading:
    ; read symbol start
    push rdi
    push rsi
    push rdx
    call read_char    ; now we have char code in rax or 0 if error occurs
    pop rdx
    pop rsi
    pop rdi
    ; read symbol end
    jz .end_of_stream ; if the eof occurs
    ; is whitespace start
    cmp rax, 0x20     ; check if space
    jz .maybe_success
    cmp rax, 0x9      ; check if tab
    jz .maybe_success
    cmp rax, 0xA      ; check if newline
    jz .maybe_success
    ; is whitespace end
    ; copy to memory start
    push rsi
    push rax       ; store in stack
    mov rcx, 1
    mov rsi, rsp
    cld
    rep movsb
    pop rax
    pop rsi
    ; copy to memory end
    inc rdx
    jmp .body
.maybe_success:
    cmp rdx, 0
    jz .reading
.end_of_stream:
    ; 0 copy to memory start
    push rsi
    push 0       ; store in stack
    mov rcx, 1
    mov rsi, rsp
    cld
    rep movsb
    dec rdi
    pop rax
    pop rsi
    ; 0 copy to memory end
    sub rdi, rdx
    mov rax, rdi
    ret
.failure:
    xor rax, rax
    ret


exit:
  mov rax, 60 ; 'exit' syscall number
  syscall


parse_uint:
    mov rsi, 10
    xor rax, rax
    xor rdx, rdx
.body:
    xor rcx, rcx
    add cl, [rdi]
    jz .end       ; if null terminator encountered
    sub cl, 0x30 ; substract zero ASCII code
    cmp cl, 9
    jg .error_ret
    cmp cl, 0
    jl .error_ret
    push rdx
    mul rsi
    pop rdx
    add rax, rcx
    inc rdx
    inc rdi
    jmp .body
.error_ret:
    cmp rdx, 0
    jnz .end
    xor rdx, rdx
.end:
    ret


parse_int:
    xor rax, rax
    add al, [rdi]
    cmp al, 0x2d ; check if dash as minus
    jz .negative
    call parse_uint
    ret
.negative:
    inc rdi
    call parse_uint
    neg rax
    inc rdx
    ret


string_length:
    push rbx
    xor rax, rax
.loop_enter:
    xor rbx, rbx
    add bl, [rdi + rax]
    jz .loop_exit
    inc rax
    jmp .loop_enter
.loop_exit:
    pop rbx
    ret


print_string:
    xor rax, rax
    mov rsi, rdi ; string address
    push rdi
    call string_length
    pop rdi
    mov rdx, rax ; string length
    mov rdi, 1   ; stdout descriptor
    mov rax, 1   ; 'write' syscall number
    syscall
    ret
