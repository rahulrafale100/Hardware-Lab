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

popa
ret
print_matrix:
	pusha
	mov word[num1], 0
print_1:
	mov word[num2] , 0

	print_2:	
		mov cx , word[ebx + 2 * eax]
		mov word[num], cx
		call print_num
	inc eax 
	inc word[num2]
	mov cx , word[num2]
	cmp cx , word[m]
	jb print_2
	
	call new_line
	inc word[num1]
	mov cx , word[num1]
	cmp cx , word[n]
	jb print_1
	jmp end_print_1

end_print_1:
	popa
ret 

section .data
msg1 : db 'Enter the String',0ah
len_msg1: equ $- msg1
msg2 : db 'Required form of string is : ',0ah
len_msg2: equ $-msg2
newline : db 10
space : db ' '
s1_cnt: dw 0
s3_cnt: dw 0
matched_cnt : dw 0
len_string: dw 0
row: dw 0
starting_point: dd 0


section .bss
temp   : resb 1
string: resb 100
string1 :resb 100
dp: resw 200
num    : resw 1
count  : resb 1
index  : resw 1
n  : resw 1
m  : resw 1
num1 : resw 1
num2 : resw 1
x: resw 1
y: resw 1
z: resw 1

section .text
global _start:
_start:	

	    mov eax , 4
        mov ebx , 1
        mov ecx , msg1
        mov edx , len_msg1
        int 80h
	
	mov ebx , string
	mov byte[ebx],0
	inc ebx	
	call read_string
	mov ebx,string
	inc ebx
loopk:
    mov al,byte[ebx]
    cmp al,0
    je L1
    inc ebx
    jmp loopk
L1:
    mov dword[starting_point],ebx
    mov byte[ebx],' '
    dec ebx
loop1:
    mov al, byte[ebx]
    cmp al,' '
    je print_it
    cmp al,0
    je end_all
go:
   dec ebx
   jmp loop1
    
print_it:
    mov edx,ebx
    mov ecx,string1
    inc edx
loop2:
     mov al ,byte[edx]
     cmp al,' '
     je L2
     mov byte[ecx],al
     inc ecx
     inc edx
     jmp loop2
L2:
    mov byte[ecx],' '
    inc ecx
    mov byte[ecx],0
    pusha
    mov ebx,string1
    call print_string
    popa
    jmp go
 
end_all:
    mov edx,ebx
    mov ecx,string1
    inc edx
loop3:
    mov al,byte[edx]
    cmp al ,' '
    je exit
    mov byte[ecx],al
    inc ecx
    inc edx
    jmp loop3
exit:
    mov byte[ecx],' '
    inc ecx
    mov byte[ecx],0
    pusha
    mov ebx,string1
    call print_string
    popa
call new_line
    mov eax,1
    mov ebx,0
    int 80h
    



  