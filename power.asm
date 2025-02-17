section .bss
    base resq 1
    exponent resq 1
    result resq 1
    buffer resb 20

section .data
    prompt_base db "Enter base: ", 0
    prompt_exponent db "Enter exponent: ", 0
    output_msg db "Result: ", 0
    newline db 10

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_base
    mov rdx, 12
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 10
    syscall

    call str_to_int
    mov [base], rax

    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_exponent
    mov rdx, 16
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 10
    syscall

    call str_to_int
    mov [exponent], rax

    mov rax, 1
    mov [result], rax
    mov rcx, [exponent]
    test rcx, rcx
    jz done
    mov rbx, [base]
power_loop:
    mov rax, [result]
    imul rax, rbx
    mov [result], rax
    dec rcx
    jnz power_loop

done:
    mov rax, 1
    mov rdi, 1
    mov rsi, output_msg
    mov rdx, 8
    syscall

    mov rax, [result]
    call int_to_str

        mov rsi, rbx
        mov rdx, 20
    print_loop:
        cmp byte [rsi], 0
        je print_done
        mov rax, 1
        mov rdi, 1
        mov rdx, 1
        syscall
        inc rsi
        jmp print_loop
    print_done:

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

str_to_int:
    xor rax, rax
    xor rcx, rcx
parse_loop:
    movzx rdx, byte [rsi + rcx]
    test rdx, rdx
    jz end_parse
    cmp rdx, 10
    je end_parse
    sub rdx, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rcx
    jmp parse_loop
end_parse:
    ret

int_to_str:
    mov rbx, buffer
    add rbx, 19
    mov byte [rbx], 0
    dec rbx
    mov rcx, 10
convert_loop:
    xor rdx, rdx
    div rcx
    add dl, '0'
    mov [rbx], dl
    dec rbx
    test rax, rax
    jnz convert_loop
    inc rbx
    ret
