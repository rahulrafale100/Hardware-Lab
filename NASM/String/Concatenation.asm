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
msg1 : db 'Enter the first string',0ah
len_msg1: equ $- msg1
msg2 : db 'Enter the second string',0ah
len_msg2: equ $-msg2
msg3 : db 'Final string is : '
len_msg3: equ $-msg3
newline : db 10
space : db ' '
a_cnt: dw 0
e_cnt: dw 0
i_cnt: dw 0
o_cnt: dw 0
u_cnt: dw 0

section .bss
temp   : resb 1
string1 : resb 50
string2 : resb 50
string3 : resb 100
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
	
	mov ebx , string1	
	call read_string
		mov eax , 4
        mov ebx , 1
        mov ecx , msg2
        mov edx , len_msg2
        int 80h
	mov ebx,string2
	call read_string
    mov ebx,string1
    mov ecx,string3
for_loop1:
    mov al,byte[ebx]
    cmp al,0
    je L1
    mov byte[ecx],al
    inc ecx
    inc ebx
    jmp for_loop1
L1:
    mov ebx,string2
for_loop2:
    mov al,byte[ebx]
    cmp al,0
    je L2
    mov byte[ecx],al
    inc ecx
    inc ebx
    jmp for_loop2
L2:
    mov byte[ecx],0
    	mov eax , 4
        mov ebx , 1
        mov ecx , msg3
        mov edx , len_msg3
        int 80h
        mov ebx,string3
        call print_string
	
exit:
	mov eax, 1
	mov ebx,0
	int 80h
