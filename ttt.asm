;Program written by Caden Sullivan

;------------------------------------
;		Macros		    ;
;-----------------------------------;	
				    ;
%macro write 2			    ;
	mov eax, 4		    ;
	mov ebx, 1		    ;	
	mov ecx, %1                 ;
	mov edx, %2                 ;
	int 0x80                    ;
%endmacro                           ;
                                    ;
%macro considerate_write 2          ;
	push eax                    ;
	push ebx                    ;
	push ecx                    ;
	push edx                    ;
	write %1, %2                ;
	pop edx                     ;
	pop ecx                     ;
	pop ebx                     ;
	pop eax                     ;
%endmacro                           ;
                                    ;
%macro read 2                       ;
	mov eax, 3                  ;
	mov ebx, 2                  ;
	mov ecx, %1                 ;
	mov edx, %2                 ;
	int 0x80                    ;
%endmacro			    ;
				    ;
%macro deref 2			    ;
	mov eax, 3		    ;
	mul %1			    ;
	add eax, %2		    ;
%endmacro                           ;
				    ;
;-----------------------------------;

section .data

	board db "000000000"

	newline db 0xA, 0xD

section .bss

	x resb 1
	y resb 1
	player resb 1

section .text
	global _start
_start:

	mov ecx, 9
	jmp gameloop

gameloop:
	
	push ecx
	mov ecx, 0
	mov edx, board
	call printboard		; print out the board and take user input
	read x, 2
	read y, 2
	pop ecx

	mov al, cl
	push ecx
	mov cl, 2
	div cl			; get player value
	mov cl, ah
	xor cl, 1
	add cl, 49 ;("0" + 1)
	mov [player], cl

	xor eax, eax
	mov bl, [x]
	sub bl, "0"
	mov dl, [y]	
	sub dl, "0"		; placing piece in specified spot
	deref dl, ebx
	mov [board + eax], byte cl

	loop gameloop
	jmp exit

printboard:

	considerate_write edx, 3
	considerate_write newline, 2
	add edx, 3

	inc ecx
	cmp ecx, 3
	jl printboard
	write newline, 2
	ret

checkwin:

	

	ret

exit:
	
	mov eax, 1
	xor ebx, ebx
	int 0x80
