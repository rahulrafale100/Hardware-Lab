new_line:
	pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , newline
	mov edx , 1
	int 80h
	popa

ret
read_string:
	pusha
reading:
	push ebx 
	mov eax , 3
	mov ebx , 0
	mov ecx , temp
	mov edx , 1
	int 80h
	pop ebx 

	cmp byte[temp] , 10
	je end_reading
	mov cl , byte[temp]
	mov byte[ebx] , cl
	inc ebx
	jmp reading
 
end_reading:
	mov byte[ebx] , 0
	popa
	ret

print_string:
	pusha	
printing:
	cmp byte[ebx] , 0
	je end_printing
	mov cl , byte[ebx]
	mov byte[temp] , cl
	
	push ebx 
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
	pop ebx

	inc ebx 
	jmp printing

end_printing:
;	call new_line
	popa
	ret
print_num:
mov byte[count],0
pusha
extract_no:
inc byte[count]
mov dx, 0
mov ax, word[num]
mov bx, 10
div bx
push dx
cmp ax , 0
je print_no
mov word[num], ax
jmp extract_no
print_no:
cmp byte[count], 0
je end_print
dec byte[count]
pop dx
mov byte[temp], dl
add byte[temp], 30h
mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h
jmp print_no
end_print:
mov eax,4
mov ebx,1
mov ecx,newline
mov edx,1
int 80h
popa
ret

section .data
msg1 : db 'Enter the sentence',0ah
len_msg1: equ $- msg1
msg2 : db 'Enter the word to be replaced',0ah
len_msg2: equ $-msg2
msg3 : db 'Final modified string is ',0ah
len_msg3: equ $-msg3
newline : db 10
space : db ' '
s1_cnt: dw 0
s3_cnt: dw 0
matched_cnt : dw 0
space_cnt: dw 0
len_count: dw 0
counter: dw 0



section .bss
temp   : resb 1
string: resb 100
string1 : resb 50
string2 : resb 50
string3 : resb 50
string_s : resb 50
string_p : resb 50
string4 : resb 100
num    : resw 1
count  : resw 1
n      : resd 1
adr1   : resd 1
adr2  : resd 1
adr3  : resd 1
section .text
global _start:
_start:	

	mov eax , 4
        mov ebx , 1
        mov ecx , msg1
        mov edx , len_msg1
        int 80h
	
	mov ebx , string	
	call read_string
	mov ebx,string
    mov edx,string_p
    mov al,byte[ebx]
    mov byte[edx],al
    inc edx
    inc word[len_count]
loopk:
inc word[len_count]
    inc ebx
    mov al,byte[ebx]
    cmp al,0
    je end
    jmp L1
L1:
    mov cx,word[len_count]
    mov word[count],cx
    dec word[count]
   ; dec word[count]
    mov ecx,string
    loopj:
        cmp word[count],0
        je end_j
        cmp al,byte[ecx]
        je L2
        inc ecx
        dec word[count]
        jmp loopj
end_j:
    mov byte[edx],al
    inc edx
    jmp loopk
L2:
    jmp loopk

end:
;mov byte[edx],0
mov ebx,string_p
call print_string
	mov eax,1
	mov ebx,0
	int 80h