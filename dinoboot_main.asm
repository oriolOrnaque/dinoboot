	mov	ax, 0x07C0 
	mov	ds, ax		; set DS to the point where code is loaded
	mov	ah, 0x01
	mov	cx, 0x2000
	int 	0x10		; clear cursor blinking
	mov	ax, 0x0305
	mov	bx, 0x031F
	int	0x16		; increase delay before keybort repeat

game_loop:
	call clear_screen

	call draw_ground
	call draw_dino
	call draw_object

	call check_dino_object_collision

	call poors_man_timer

	mov ah, 0x01
	int 0x16
	jnz update_dino
return_update_dino:
	call update_object
	jmp game_loop

game_over:
	jmp game_over



draw_ground:
	mov dx, 0x1010
	call move_cursor
	mov cx, 0x0
	.inner_loop:
		mov al, '_'
		mov ah, 0x0e
		int 0x10
		inc cx
		cmp cx, 40
		jne .inner_loop
	ret

draw_object:
	mov dx, [object_pos]
	call move_cursor
	mov al, '#'
	mov ah, 0x0e
	int 0x10
	ret

draw_dino:
	mov dx, [dino_pos]
	call move_cursor
	mov al, '&'
	mov ah, 0x0e
	int 0x10
	ret






update_object:
	mov dx, word [object_pos]
	dec dl
	cmp dl, 0x10
	je reset_object
return_reset_object:
	mov word [object_pos], dx
	ret

reset_object:
	mov word [object_pos], 0x1030
	jmp return_reset_object

update_dino:
	mov ah, 0x00
	int 0x16
	cmp al, 'w'
	je dino_up
	cmp al, 's'
	je dino_down
	jmp return_update_dino

dino_up:
	mov dx, [dino_pos]
	dec dh
	mov [dino_pos], dx
	jmp return_update_dino

dino_down:
	mov dx, [dino_pos]
	inc dh
	mov [dino_pos], dx
	jmp return_update_dino

check_dino_object_collision:
	mov bx, [object_pos]
	mov cx, [dino_pos]
	cmp bx, cx
	jz .collision
	jnz .no_collision

	.collision:
		jmp game_over

	.no_collision:
		ret


poors_man_timer:
	mov ax, 0x0000
	.f_loop:
		mov bx, 0x0000
		.s_loop:
			inc bx
			cmp bx, 0x00ff
			jnz .s_loop
		inc ax
		cmp ax, 0xffff
		jnz .f_loop
	ret


clear_screen:
	mov	ax, 0x0700	; clear entire window (ah 0x07, al 0x00)
	mov	bh, 0x0C	; light red on black
	xor	cx, cx		; top left = (0,0)
	mov	dx, 0x1950	; bottom right = (25, 80)
	int	0x10
	xor	dx, dx		; set dx to 0x0000
	call	move_cursor	; move cursor
	ret

move_cursor:
	mov	ah, 0x02	; move to (dl, dh)
	xor	bh, bh		; page 0	
	int 	0x10
	ret




object_pos: dw 0x1030
dino_pos: dw 0x1010

times 510-($-$$) db 0
db 0x55
db 0xaa