read_num:

pusha

mov word[num], 0
loop_read:

mov eax, 3d
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h

cmp byte[temp], 10
je end_read
mov ax, word[num]
mov bx, 10
mul bx
mov bl, byte[temp]
sub bl, 30h
mov bh, 0
add ax, bx
mov word[num], ax
jmp loop_read
end_read:

popa
ret

print_num:
mov byte[count],0
pusha
extract_no:
inc byte[count]
mov dx,  0
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

read_array1:

pusha
read_loop1:
cmp eax,dword[n1]
je end_read1
mov word[num] , 0
call read_num

mov cx,word[num]
mov word[ebx+2*eax],cx
inc eax
jmp read_loop1
end_read1:
popa
ret

read_array2:

pusha
read_loop2:
cmp eax,dword[n2]
je end_read2
mov word[num] , 0
call read_num

mov cx,word[num]
mov word[ebx+2*eax],cx
inc eax
jmp read_loop2
end_read2:
popa
ret



section .data
msg1: db 'Enter the size of the array',0ah
len_msg1 : equ $- msg1 

msg2 : db 'Enter the elements',0ah
len_msg2: equ $-msg2

msg3 : db ' Enter the size of the second array',0ah
len_msg3 : equ $- msg3

msg4 : db 'Common elements are:',0ah
len_msg4 : equ $-msg4

newline : db 10

section .bss
temp  : resb 1
count : resb 1
n1    : resd 1
n2    : resd 1
num   : resd 1
num1  : resd 1
num2  : resd 1
num3  : resd 1
array1 : resw 50 
k     : resd 1
save  : resw 1
l     : resd 1
num4  : resd 1
array2: resw 50

section .text
global _start:
_start:
	mov eax , 4
 	mov ebx , 1
	mov ecx , msg1
	mov edx , len_msg1
	int 80h
 
	mov word[num] , 0
	call read_num 
	mov ax , word[num]
	mov word[n1] ,ax
	
	mov eax , 4
	mov ebx , 1
 	mov ecx , msg2
	mov edx , len_msg2
	int 80h
	
	mov eax , 0
	mov ebx , array1
	call read_array1
	
	mov eax , 4
        mov ebx , 1
        mov ecx , msg1
        mov edx , len_msg1
        int 80h
	
	mov word[num] , 0
        call read_num
        mov ax , word[num]
        mov word[n2] ,ax

	mov eax , 4
        mov ebx , 1
        mov ecx , msg2
        mov edx , len_msg2
        int 80h

	mov eax , 0
	mov ebx , array2
	call read_array2
		mov eax , 4
 	mov ebx , 1
	mov ecx , msg4
	mov edx , len_msg4
	int 80h
	
	
	mov eax , 0
	
	
	for_loop1:
		mov edx,0
		cmp eax , dword[n1]
		je exit
 		mov ebx , array1
		mov bx , word[ebx + 2 * eax]
		inc eax
	for_loop2:
		cmp edx,dword[n2]
		je for_loop1
		mov ecx,array2
		mov cx , word[ecx + 2 * edx]
		inc edx
		cmp bx , cx
		je L1
		jmp for_loop2
		
	L1: 
	mov word[num] , bx
	call print_num
	jmp for_loop2
	
exit:
	mov eax , 1
	mov ebx , 0
	int 80h