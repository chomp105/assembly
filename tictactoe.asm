section .data	
	board db "........."
	player db 1
	newline db 0xA
	clear db 27,"[H",27,"[2J"
section .bss
	x resb 1
	y resb 1
section .text
	global _start
_start:
	push ecx
	mov eax, 4
	mov ebx, 1
	mov ecx, clear
	mov edx, 7
	int 0x80
	xor ecx, ecx
	movzx eax, byte [player]
	xor eax, 1
	mov [player], al
	mov esi, board
print:
	push ecx
	mov eax, 4
	mov ecx, esi
	mov edx, 3
	int 0x80
	mov eax, 4
	mov ecx, newline
	mov edx, 1
	int 0x80
	pop ecx
	inc ecx
	add esi, 3
	cmp ecx, 3
	jl print
	mov eax, 4
	mov ecx, newline
	int 0x80
	mov eax, 3
	mov ebx, 2
	mov ecx, x
	int 0x80
	mov eax, 3
	mov ecx, y
	mov edx, 2
	int 0x80	
	mov al, [y]
	sub al, 48
	mov dl, 3
	mul dl
	add al, [x]
	sub al, 48
	mov bl, [player]
	add bl, 49
	mov [board + eax], bl
	xor ecx, ecx
	mov esi, board
checkh:
	mov al, esi[0]
	add al, esi[1]
	add al, esi[2]
	call checkwin
	add esi, 3
	inc ecx
	cmp ecx, 3
	jl checkh
	xor ecx, ecx
checkv:
	mov al, board[ecx + 0]
	add al, board[ecx + 3]
	add al, board[ecx + 6]
	call checkwin
	inc ecx
	cmp ecx, 3
	jl checkv
	mov al, board[0]
	add al, board[4]
	add al, board[8]
	call checkwin
	mov al, board[2]
	add al, board[4]
	add al, board[6]
	call checkwin
	pop ecx
	inc ecx
	cmp ecx, 9
	jl _start
exit:
	mov eax, 1
	xor ebx, ebx
	int 0x80
checkwin:
	cmp al, 147
	je exit
	cmp al, 150
	je exit
	ret 
