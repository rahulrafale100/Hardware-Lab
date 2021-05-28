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
	call new_line
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
msg1 : db 'Enter the string',0ah
len_msg1: equ $- msg1
msg2 : db 'Largest Word is: '
len_msg2 : equ $- msg2
msg3 : db 'Smallest Word is: '
len_msg3 : equ $- msg3
len_lword : dw 0
len_sword: dw 20
len_counter: dw 0
newline : db 10
space : db ' '


section .bss
temp   : resb 1
string : resb 50
string1: resb 50
Large_word : resb 10
Small_word : resb 10
temp_word : resb 10
num    : resw 1
count  : resb 1
n      : resd 1
counter: resd 1
adr1   : resd 1

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
	mov edx,temp_word
loop1:
	inc word[len_counter]
	mov al,byte[ebx]
	cmp al,0
	je L1
	cmp al,' '
	je L1
	mov byte[edx],al
	inc edx
next:	
	mov al,byte[ebx]
	cmp al,0
	je end_counting
	inc ebx	
	jmp loop1

end_counting:
	mov eax , 4
        mov ebx , 1
        mov ecx , msg2
        mov edx , len_msg2
        int 80h
	mov ebx,Large_word
	call print_string
;	call new_line
	mov eax , 4
        mov ebx , 1
        mov ecx , msg3
        mov edx , len_msg3
        int 80h
	mov ebx,Small_word
	call print_string
	call new_line
	
exit:
	mov eax, 1
	mov ebx,0
	int 80h

L1:
	mov eax,0
	dec word[len_counter]
	mov ax,word[len_counter]
    cmp ax,word[len_sword]
	jb L3
come:
    mov ax,word[len_counter]
	cmp ax,word[len_lword]
	ja L2
	mov edx,temp_word
	mov word[len_counter],0
	jmp next
L2:
	push ebx
	mov ebx,Large_word
	mov ecx,temp_word
	mov word[len_lword],ax
	mov word[count],ax
Loop2:
	cmp word[count],0
	je end_copy_lword
	mov al,byte[ecx]
	mov byte[ebx],al
	dec word[count]
	inc ebx
	inc ecx
	jmp Loop2

end_copy_lword:
	mov byte[ebx],0
	pop ebx
	mov word[len_counter],0
	mov edx,temp_word
	jmp next
L3:
	push ebx
	mov ebx,Small_word
	mov ecx,temp_word
	mov word[len_sword],ax
	mov word[count],ax
Loop3:
	cmp word[count],0
	je end_copy_sword
	mov al,byte[ecx]
	mov byte[ebx],al
	dec word[count]
	inc ebx
	inc ecx
	jmp Loop3

end_copy_sword:
	mov byte[ebx],0
	pop ebx
;	mov edx,temp_word
	jmp come

	

