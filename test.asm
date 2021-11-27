; Program by Caden Sullivan

section .data

	message1 db "Input the first value: "
	mlen1 equ $-message1

	message2 db "Input the second value: "
	mlen2 equ $-message2

section .bss

	num1 resb 5
	num2 resb 5	
	sum resd 1
	output resb 6

section .text
	global _start
_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, message1	; output message1 to the screen
	mov edx, mlen1
	int 0x80

	mov eax, 3
	mov ebx, 2
	mov ecx, num1		; take user input for num1
	mov edx, 6
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, message2	; output message2 to the screen
	mov edx, mlen2
	int 0x80

	mov eax, 3
	mov ebx, 2
	mov ecx, num2		; take user input for num2
	mov edx, 6
	int 0x80

	xor ecx, ecx
	mov [sum], ecx		
	jmp sumloop
	
	jmp exit

sumloop:

	xor eax, eax
	xor ebx, ebx

	mov edx, 4
	sub edx, ecx
	mov al, [num1 + edx]
	sub eax, "0"
	mov bl, [num2 + edx]	; add the nth digits of num1 and num2
	sub ebx, "0"
	add eax, ebx
	
	mov ebx, 10
	push ecx
	call powloop
	pop ecx

	mov ebx, [sum]
	add eax, ebx		; adding eax to [sum] doesnt work ig so...
	mov [sum], eax	

	inc ecx
	cmp ecx, 5		; loop from 0 to 4
	jl sumloop
	mov ecx, 5
	jmp parseint

powloop:
	
	dec ecx
	cmp ecx, 0
	jge pow
	ret
pow:
	mul ebx
	jmp powloop

parseint:
	
	mov edx, 6
	sub edx, ecx
	mov eax, 1
	mov ebx, 10		; get the value to % each digit by
	push ecx
	mov ecx, edx
	call powloop
	pop ecx

	mov ebx, eax
	mov eax, [sum]		; divide sum by the number specified
	xor edx, edx
	div ebx

	sub [sum], edx
	push edx
	xor edx, edx		; subtract the remainder and divide the % value by ten
	mov eax, ebx
	mov ebx, 10
	div ebx

	mov ebx, eax
	pop edx
	mov eax, edx		; divide the remainder by the % value
	xor edx, edx
	div ebx

	add eax, "0"		; put the remainder into output
	mov [output + ecx], al 

	dec ecx
	cmp ecx, 0		; loop if greater than or equal to 0
	jge parseint
	jmp exit

exit:
	
	mov eax, 4
	mov ebx, 1
	mov ecx, output		; output the "output"
	mov edx, 6
	int 0x80

	mov eax, 1
	xor ebx, ebx		; exit program
	int 0x80
