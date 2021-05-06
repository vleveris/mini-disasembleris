.model large
	
BSeg SEGMENT

	ORG 100h
	ASSUME ds:BSeg, cs:BSeg, ss:BSeg

start:
	;mov ax, @data
	;mov ds, ax
	;cmp al, 23h
	;mov ah, bl
	;mov ah, 0Ah
	;mov dx, 0168h
	;int 21h
	;jmp word ptr [bx]
	;mov al, byte ptr ds:[0145h]
	;call ds:[2345h]
	;mov bx, offset buffer_data
	;mov cl, buffer_used
	;mov ch, 0
;cycle:
	;cmp byte ptr ss:[bx], 97
	;jb not_lowercase
	;cmp word ptr [es:bx], 42FAh
	;cmp byte ptr [bx], 122
	;ja not_lowercase
;not_lowercase:
	;inc bx
	;loop cycle
	
	;message1 db "k$"
	;buffer_data db ?
	;buffer_used db ?
	
	jz hello2
	add al, 40h
hello2:
	add ax, 2160h
	add ax, 60h
	add cl, byte ptr es:[bp + si]
	add cx, word ptr ds:[bx + 0341h]
	add si, 1452h
	sub al, 40h
	sub ax, offset data2
	sub cl, byte ptr es:[bp + si]
	sub cx, word ptr ds:[bx + 0341h]
	sub si, 1452h
	sbb cl, byte ptr es:[bp + si]
	sbb cx, word ptr ds:[bx + 0341h]
	cmp al, 40h
	cmp ax, offset data3
	cmp cl, byte ptr es:[bp + si]
	cmp cx, word ptr ds:[bx + 0341h]
	cmp si, 1452h
	inc dx
	inc byte ptr ss:[bp]
	dec dx
	dec byte ptr ss:[bp]
	push ds
	push bp
	push word ptr ds:[5201h]
	pop ds
	pop bp
	pop word ptr ds:[5201h]
	mul dx
	div dx
	jmp cs:[0100h]
	jmp es:[0100h]
	jmp word ptr cs:[bx]
	jmp word ptr es:[bx]
	db 0E9h, 00h, 01h
	db 0EAh, 00h, 01h, 20h, 30h
	db 0FFh, 26h, 00h, 01h
	db 0FFh, 2Eh, 00h, 01h 
	call cs:[0100h]
	call es:[0100h]
	call word ptr cs:[bx]
	call word ptr es:[bx]
	db 0E8h, 00h, 01h
	db 09Ah, 00h, 01h, 20h, 30h
	db 0FFh, 16h, 00h, 01h
	db 36h, 0FFh, 1Eh, 00h, 01h 
	; 26 - 00 100 110
	; 27 - 00 100 111
	jmp hello
	add ah, ah
hello:
	loop hello
	int 21h
	int 31h
	jo next
	jno next
	jb next
	jae next
	je next
	jne next
	jbe next
	ja next
	js next
	jns next
	jp next
	jnp next
	jl next
	jge next
	jle next
	jg next
	jcxz next
next:
	mov cl, byte ptr ds:[0123h]
	mov ss, word ptr ds:[0123h]
	mov al, byte ptr [bx + si + 2525h]
	mov word ptr es:[bx + si + 2525h], ax
	mov al, ds:[2525h]
	mov es:[2525h], ax
	mov bl, 56h
	mov byte ptr [si], 57h
	
	ret
	retf
	ret 12h
	retf 13h
	
	data1 db ?
	data2 db ?
	data3 db ?
	data4 db ?
	dataw1 dw ?
	dataw2 dw ?
	dataw3 dw ?
	dataw4 dw ?
	
BSeg ENDS
	
end start