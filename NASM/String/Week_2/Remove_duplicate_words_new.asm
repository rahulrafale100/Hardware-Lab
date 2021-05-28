
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

print_array:
pusha
print_loop:
cmp eax,dword[n]
je end_print1
mov ecx,dword[ebx+4*eax]
mov word[num],cx
call print_num
inc eax
jmp print_loop
end_print1:
popa
ret

section .data
msg1 : db 'Enter the string',0ah
len_msg1 : equ $- msg1
msg2 : db 'String in Lexicographical order :-- ',0ah
len_msg2 : equ $- msg2
newline : db 10
;down: db 10
n: dd 0

section .bss
count : resb 1
num   : resw 1
temp  : resb 1
num1  : resd 1
string : resb 100
string1: resb 100
ind_ptr1 : resd 1
ind_ptr2: resd 1
num2 : resd 1
array : resd 100
k     : resd 1
p     : resd 1
start : resd 1
end : resd 1
num3  : resw 1
adr1 : resd 1

section .text
global _start:
_start:
        pusha
        mov eax , 4
        mov ebx , 1
        mov ecx , msg1
        mov edx , len_msg1
        int 80h
        popa
	mov ebx , string	
	call read_string
        mov ebx , string
	mov edx,array
	mov dword[edx],ebx
	add edx,4
loopk:
	mov al,byte[ebx]
	cmp al,' '
	je L11
	cmp al,0
	je L22
go:	
    inc ebx
	jmp loopk



L11:
	mov byte[ebx],0
	inc ebx
	mov dword[edx],ebx
	add edx,4
	inc dword[n]
	dec ebx
	jmp go
L22:
	inc dword[n]
	mov ebx,array
  mov edx,string1

 loopk1:
     mov eax,dword[n]
     
    cmp dword[n],0
    je end_all
    jmp check
comehere:
    dec dword[n]
    add  ebx ,4
    jmp loopk1

check:
    mov dword[adr1],ebx
    mov ecx,ebx
    mov ebx,array
   ; call print_array
loop1:
  
    cmp ebx,ecx
    je push_it
    jne compare_it
Lable1:

    add ebx,4

    jmp loop1

;--------------------------
compare_it:
    mov dword[end],ecx
    mov dword[start],ebx
;  mov eax,dword[end]
;      mov ebx,dword[eax]
;      call print_string
    mov eax,dword[start]
    mov ebx,dword[eax]
 ;  call print_string
    mov eax,dword[end]
    mov ecx,dword[eax]
compare:
  	cmp byte[ebx],0
	je L1
	cmp byte[ecx],0
	je L2
	mov eax,0
	mov al,byte[ebx]
	cmp al,byte[ecx]
	jne L1
	inc ebx
	inc ecx
	jmp compare
L1:

	mov eax,0
	mov al,byte[ebx]
	cmp al,byte[ecx]
	je equal
    jne L2


equal:

    mov ebx,dword[adr1]
	jmp comehere
L2:

    mov ebx,dword[start]
    mov ecx,dword[end]
    jmp Lable1


    
push_it:
mov eax,ecx
mov ecx,dword[eax]

loop2:
    mov al,byte[ecx]
    cmp al,0
    je end_copy
 
    mov byte[edx],al
   
    inc edx
    inc ecx
    
    jmp loop2
end_copy:

    mov byte[edx],' '
    inc edx
    mov ebx,dword[adr1]
    jmp comehere

end_all:
    mov ebx, string1
    call print_string
    mov eax,1
    mov ebx,0
    int 80h