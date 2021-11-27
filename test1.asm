; Program by Caden Sullivan

;-----------------------------------------------;
;		input/output macros		;
;-----------------------------------------------;
	%macro write 2				;
		mov eax, 4			;
		mov ebx, 1			;
		mov ecx, %1			;
		mov edx, %2			;
		int 0x80			;
	%endmacro				;
						;
	%macro read 2				;
		mov eax, 3			;
		mov ebx, 2			;
		mov ecx, %1			;
		mov edx, %2			;
		int 0x80			;
	%endmacro				;
;------------------------------------------------

section .data

	message1 db "Enter the first value: "
	mlen1 equ $-message1
	
	message2 db "Enter the second value: "
	mlen2 equ $-message2

section .bss

	num1 resb 5
	num2 resb 5
	res resb 5

section .text
	global _start
_start:

	write message1, mlen1
	read num1, 6
	write message2, mlen2
	read num2, 6

	xor edx, edx
	clc
	mov ecx, 5
	mov edi, 4
	jmp addloop

addloop:
	
	mov al, [num1 + edi]
	sub al, "0"
	mov bl, [num2 + edi]
	sub bl, "0"
	add al, bl
	add al, dl
	cmp al, 9
	jg add_if
	jle add_else
	jmp add_next
add_if:
	mov dl, al
	sub dl, 10
	mov al, dl
	mov dl, 1
	jmp add_next
add_else:
	xor edx, edx
add_next:
	add al, "0"
	mov [res + edi], al
	dec edi
	loop addloop
	jmp exit

exit:

	write res, 5
	
	mov eax, 1
	xor ebx, ebx
	int 0x80
