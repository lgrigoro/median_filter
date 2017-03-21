;;;;;;;;;;;;;;;;;;;;;;;;;
; ebp+8  - input_array  ;
; ebp+12 - output_array ;
;;;;;;;;;;;;;;;;;;;;;;;;;
; ebp-4	 - offset	;
; ebp-8  - width	;
; ebp-12 - height	;
; ebp-16 - padding	;
; ebp-20 - width+padding;
;	   in pixels    ;
; ebp-24 - height_loop  ;
; ebp-28 - width_loop  	;
; ebp-32 - sort_loop	;
;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION .data

sort times 27 DB 0

SECTION .text
global median
extern printf

median:
	push    ebp
        mov     ebp, esp
	sub	esp, 36

	mov 	edi, DWORD[ebp+8]			; edi = inputArray
	mov 	esi, DWORD[ebp+12]			; esi = outputArray
        mov 	eax, dword [edi+10]                     ; offset read
        mov 	dword [ebp-4], eax                    	; offset save
        mov 	eax, dword [edi+18]                     ; width read
        mov 	dword [ebp-8], eax                      ; width save
	mov 	eax, dword [edi+22]                     ; height read
        mov 	dword [ebp-12], eax                     ; height save
        mov 	eax, dword [ebp-8]                      ; padding = 4 - ((width * 3) % 4);
        lea     ebx, [eax + eax*2]                      ; width * 3 
	and	ebx, 3					
	mov 	eax, 4					
	sub	eax, ebx				
	mov 	dword [ebp-16], eax
	cmp	dword [ebp-16], 4			
	jnz	skip_padding
	mov	dword [ebp-16], 0			; there is no padding

skip_padding:
	mov 	eax, [ebp-8]				; image width in bytes (+ padding)
	lea	ebx, [eax + 2*eax]
	mov	eax, [ebp-16]
	add	eax, ebx
	mov 	dword [ebp-20], eax
	mov 	ecx, [ebp-4]

copy_header:
	mov 	al, [edi]
	mov	[esi], al
	inc 	esi
	inc 	edi
	loop 	copy_header
	mov	ecx, [ebp-20]

first_line:
	mov 	al, [edi]
	mov	[esi], al
	inc 	esi
	inc 	edi
	loop 	first_line				; dec ecx
	mov 	eax, [ebp-12]				; height_loopcounter
	sub	eax, 2
	mov	[ebp-24], eax

main_loop:
	mov	eax, [ebp-8]				; width_loopcounter
	sub	eax, 2
	mov	[ebp-28], eax
	mov 	al, [edi]
	mov	[esi], al
	inc 	esi
	inc 	edi
	mov 	al, [edi]
	mov	[esi], al
	inc 	esi
	inc 	edi
	mov 	al, [edi]
	mov	[esi], al
	inc 	esi
	inc 	edi

line_loop:
	mov 	eax, edi
	sub 	eax, dword [ebp-20]
	sub 	eax, 3
	mov 	ecx, 3
	mov 	ebx, sort

sort_line:
	mov 	dl, [eax]
	mov 	[ebx], dl
	mov 	dl, [eax+1]
	mov 	[ebx+1], dl
	mov	dl, [eax+2]
	mov 	[ebx+2], dl
	mov 	dl, [eax+3]
	mov	[ebx+3], dl
	mov	dl, [eax+4]
	mov 	[ebx+4], dl
	mov 	dl, [eax+5]
	mov 	[ebx+5], dl
	mov 	dl, [eax+6]
	mov 	[ebx+6], dl
	mov 	dl, [eax+7]
	mov 	[ebx+7], dl
	mov 	dl, [eax+8]
	mov 	[ebx+8], dl
	add	eax, 9
	add	ebx, 9
	loop 	sort_line	
	mov 	dword [ebp-32], 8

sort_main:
	mov 	eax, 0
	mov	ecx, sort

sort_cont:
	push 	eax
	mov	eax, 0
	mov 	edx, 0
	mov	ebx, 0
	mov	al, byte [ecx]
	add	edx, eax
	mov	al, byte [ecx+1]
	add	edx, eax
	mov	al, byte [ecx+2]
	add 	edx, eax
	mov	al, byte [ecx+3]
	add	ebx, eax
	mov	al, byte [ecx+4]
	add	ebx, eax
	mov	al, byte [ecx+5]
	add	ebx, eax
	cmp 	edx, ebx
	jbe	skip_xchg
	mov	dl, byte [ecx]
	xchg	dl, byte [ecx+3]
	mov	byte [ecx], dl
	mov	dl, byte [ecx+1]
	xchg	dl, byte [ecx+4]
	mov	byte [ecx+1], dl
	mov	dl, byte [ecx+2]
	xchg	dl, byte [ecx+5]
	mov	byte [ecx+2], dl

skip_xchg:
	pop 	eax
	add	ecx, 3
	inc 	eax
	cmp 	eax, dword [ebp-32]
	jne 	sort_cont
	dec 	dword [ebp-32]
	cmp	dword [ebp-32], 0
	jnz 	sort_main
	mov 	al, [sort+12]
	mov	[esi], al
	inc 	esi	
	mov 	al, [sort+13]
	mov	[esi], al
	inc 	esi
	mov 	al, [sort+14]
	mov	[esi], al
	inc 	esi
	add 	edi, 3
	dec 	dword [ebp-28]
	cmp 	dword [ebp-28], 0
	jne 	line_loop
	mov 	al, [edi]
	mov	[esi], al
	inc 	esi
	inc 	edi
	mov 	al, [edi]
	mov	[esi], al
	inc 	esi
	inc 	edi
	mov 	al, [edi]
	mov	[esi], al
	inc 	esi
	inc 	edi
	cmp	dword [ebp-16], 0
	je	skip_fill_padding
	mov	ecx, dword [ebp-16]

fill_padding:
	mov 	al, [edi]
	mov	[esi], al
	inc 	esi
	inc 	edi
	loop fill_padding

skip_fill_padding:
	dec 	dword [ebp-24]
	cmp 	dword [ebp-24], 0
	jne	main_loop
	mov	ecx, [ebp-20]

last_line:
	mov 	al, [edi]
	mov	[esi], al
	inc 	esi
	inc 	edi
	loop 	last_line	

exit:
	mov 	esp, ebp
	pop 	ebp
	ret
