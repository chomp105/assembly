%macro io 4
    mov eax, %1
    mov ebx, %2
    mov ecx, %3
    mov edx, %4
    int 0x80
%endmacro
%macro write 2
    io 4, 1, %1, %2
%endmacro
%macro read 2
    io 3, 2, %1, %2
%endmacro
%macro cwrite 2
    push eax
    push ebx
    push ecx
    push edx
    write %1, %2
    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro

section .data

    board db "000000000"
    newline db 0xA, 0xD
    
section .bss

    x resb 1
    y resb 1
    player resb 1
    foo resb 1
    
section .text
    global _start
_start:
    
    mov ecx, 9
    jmp gameloop
    
gameloop:
    push ecx
    mov ecx, 0
    mov edi, board
    call printboard
    read x, 2
    read y, 2
    pop ecx
    mov eax, ecx
    mov ebx, 2
    div bl
    xor ah, 1
    add ah, 49
    mov [player], ah
    mov al, [y]
    sub eax, "0"
    mov ebx, 3
    mul bl
    add al, [x]
    sub eax, "0"
    mov bl, [player]
    mov [board + eax], bl
    push ecx
    xor ecx, ecx
    call checkwin
    xor ecx, ecx
    call checkdiag
    pop ecx
    dec ecx
    jnz gameloop
    jmp exit
    
printboard:
    cwrite edi, 3
    cwrite newline, 2
    add edi, 3
    inc ecx
    cmp ecx, 3
    jl printboard
    write newline, 2
    ret
    
checkwin:
	mov eax, 3
	mul cl
	mov dl, [board + eax]
	inc eax
	cmp dl, [board + eax]
	jne checkloopvert
	inc eax
	cmp dl, [board + eax]
	jne checkloopvert
	cmp dl, "0"
	je checkloopvert
	jmp exit
checkloopvert:
	mov eax, ecx
	mov dl, [board + eax]
	add eax, 3
	cmp dl, [board + eax]
	jne checkloopend
	add eax, 3
	cmp dl, [board + eax]
	jne checkloopend
	cmp dl, "0"
	je checkloopend
	jmp exit
checkloopend:
	inc ecx
	cmp ecx, 3
	jl checkwin
	ret
	
checkdiag:
	mov eax, 0
	mov dl, [board + eax]
	add eax, 4
	cmp dl, [board + eax]
	jne checkotherdiag
	add eax, 4
	cmp dl, [board + eax]
	jne checkotherdiag
	cmp dl, "0"
	je checkotherdiag
	jmp exit
checkotherdiag:
	mov eax, 2
	mov dl, [board + eax]
	add eax, 2
	cmp dl, [board + eax]
	jne diagloopend
	add eax, 2
	cmp dl, [board + eax]
	jne diagloopend
	cmp dl, "0"
	je diagloopend
	jmp exit
diagloopend:
	ret
	
exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
