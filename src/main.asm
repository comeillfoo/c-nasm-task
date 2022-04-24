section .rodata
error_text: db 'error: could not parse input text', 0xA, 0 ; здесь строка с текстом ошибки, если не получилось считать или распарсить число
section .text

global _start

; главная функция
_start:
  ; define buffer for number
  mov rsi, 256
  sub rsp, 256   ; выделяем буфер под введенное число
  mov rdi, rsp
  call read_word ; читаем слово из stdin стандартный поток ввода
  test rax, rax  ; проверяем rax == 0?
  jz .error      ; если NULL, то ошибка, значит выводим сообщение об ошибке
  mov rdi, rax   ; в rdi (первый параметр) записываем распарсенное число
  mov rsi, rdx
  call parse_int ; вызываем функцию parse_int, которая разбирает введенную строку на число
  add rsp, 256   ; очищаем буфер
  mov rdi, rax
  test rdx, rdx
  jz .error      ; проверяем, смогли ли прочитать число из строки
  push rdi
  call print_bin ; печатаем бинарное представление числа
  pop rdi
  call convert   ; меняем число согласно заданию
  mov rdi, rax
  call print_bin ; печатаем измененное число
  mov rdi, 0     ; в rdi кладем код возврата из программы и прыгаем на функцию exit
  jmp exit
.error:          ; начало кода, который выполняется в случае ошибки
  mov rdi, error_text ; кладем адрес начала строки с текстом ошибки
  call print_string ; печатаем на экран
  mov rdi, -1    ; передаем -1, как код возврата
  jmp exit       ; прыгаем на функцию exit


; rdi - number we need to convert in binary ( int )
print_bin:       ; метка функции печати в stdout бинарного представления числа в rdi
  mov rsi, rdi
  sub rsp, 34    ; выделяем буфер под печатаемую строку
  mov rdi, rsp
  mov rcx, 1
.loop:
  push rsi
  rol esi, cl    ; циклически сдвигаем на cl разрядов
  and esi, 0x1   ; сдвинутое число побитово сравниваем с 0x1 получаем либо 0, либо 1
  add esi, '0'   ; складываем с ascii кода символа '0', получаем либо символ '0', либо '1'
  mov [rdi + rcx - 1], si ; записываем в соответствующий элемент строки полученный символ
  pop rsi
  inc rcx        ; увеличиваем счетчик
  cmp rcx, 33    ; сравниваем, не обошли ли мы все 32 разряда числа
  jnz .loop
  mov [rdi + rcx - 1], byte 0xA ; как закончили - дописываем символ переноса строки
  inc rcx
  mov [rdi + rcx - 1], byte 0x0 ; и символ 0, что обозначает конец строки
  push rdi
  push rsi
  call print_string ; печатаем получившуюсю строку на экран
  pop rsi
  pop rdi
  add rsp, 34 ; освобождаем буфер
  ret

; edi - is convertable number
convert:
    ; извлекаем первый байт числа в r8
    mov r8,  rdi
    and r8, 0xff

    ; извлекаем второй байт числа в r9
    shr rdi, 8
    mov r9,  rdi
    and r9, 0xff
    
    ; извлекаем третий байт числа в r10
    shr rdi, 8
    mov r10, rdi
    and r10, 0xff
    
    ; извлекаем последний байт числа в r11
    shr rdi, 8
    mov r11, rdi
    and r11, 0xff
    
    ; производим первое сравнение
    cmp r8, r9
    jle .n1     ; если младший разряд больше старшего, то меняем
    xchg r8, r9 ; инструкция, обменивающая значения в регистрах
.n1: ; производим первое сравнение
    cmp r10, r11
    jle .n2
    xchg r10, r11
.n2: ; производим первое сравнение
    cmp r8, r10
    jle .n3
    xchg r8, r10
.n3: ; производим первое сравнение
    cmp r9, r11
    jle .n4
    xchg r9, r11
.n4: ; производим первое сравнение
    cmp r9, r10
    jle .n5
    xchg r9, r10
.n5: ; производим первое сравнение
    xor rax, rax
    
    ; собираем новое число в регистр rax, аналогично в программе на Си
    or rax, r11
    shl rax, 8
    or rax, r10
    shl rax, 8
    or rax, r9
    shl rax, 8
    or rax, r8
    ret

; функция чтения из стандартного потока ввода
; использует системный вызов read
; для подробностей можно глянуть man 2 read
read_char:
    push 0x0       ; выделяем память на стеке под прочитанный символ
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

; функция чтения слова из стандартного потока ввода
; пропускает лидирующие пробелы
; читает до пробельных символов
; использует функцию read_char, чтобы прочитать
; в rax ссылка на прочитанную строку
; в rdx число прочитанных символов
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

; функция выхода из программы
; использует системный ввызов exit ( man 2 exit )
; в rdi должен быть код возврата
exit:
  mov rax, 60 ; 'exit' syscall number
  syscall


; функция парсинга беззнакового числа из rdi
; проходимся по символам числа и вычитаем код символа '0' который умножаем на нужную степень 10
; и накапливаем в аккумуляторе rax ( схема Горнера )
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


; функция разбора знакового числа
; если первый символ '-', то парсим число дальнейшее как беззнаковое а в конце производим отрицание
; иначе просто возвращаем результат parse_uint
parse_int:
    xor rax, rax
    add al, [rdi]
    cmp al, 0x2d ; check if dash as minus
    jz .negative
    call parse_uint
    ret
.negative: ; ветка функции, если число отрицательное
    inc rdi
    call parse_uint
    neg rax
    inc rdx
    ret

; функция подсчета числа символов в строке
; циклом проходится по символам до символа с кодом 0
; нужна для функции печати на экран, т.к. системный вызов write ( man 2 write ) нужно передавать число печатаемых символов 
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


; функция печати строки по адресу в rdi на экран
; использует системный вызов write ( man 2 write )
print_string:
    xor rax, rax
    mov rsi, rdi ; string address
    push rdi
    call string_length ; вызов функции string_length, чтобы в rax получить длину строки
    pop rdi
    mov rdx, rax ; string length
    mov rdi, 1   ; stdout descriptor
    mov rax, 1   ; 'write' syscall number
    syscall
    ret
