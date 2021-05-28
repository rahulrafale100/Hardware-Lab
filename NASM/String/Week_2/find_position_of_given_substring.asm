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
msg1 : db 'Enter string1',0ah
len_msg1: equ $- msg1
msg2 : db 'Enter string2',0ah
len_msg2: equ $-msg2
msg3 : db '-1',0ah
len_msg3: equ $-msg3
msg4 : db 'Final modified string is ',0ah
len_msg4: equ $-msg4
newline : db 10
space : db ' '
s1_cnt: dw 0
s3_cnt: dw 0
matched_cnt : dw 0
space_cnt: dw 0
len_string_s: dw 0
ans: dw 500
length: dw 0
count : dw 0
i: dw 0


section .bss
temp   : resb 1
string: resb 100
string1 : resb 100
string2 : resb 50
string3 : resb 50
string_s : resb 50
string_p : resb 50
string4 : resb 100
num    : resw 1
n      : resd 1
first : resb 1
last : resb 1
adr1   : resd 1
adr2   : resd 1

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

	    mov eax , 4
        mov ebx , 1
        mov ecx , msg1
        mov edx , len_msg1
        int 80h
	
	mov ebx , string1	
	call read_string
    mov ebx ,string 
    mov ecx,string1
loop1:
    mov al,byte[ecx]
    cmp al,0
    je lable
    inc ecx
    inc word[length]
    jmp loop1
lable:
    mov ecx,string1
     mov dword[adr1],ebx
loopk:
    mov ebx, dword[adr1]
    mov al,byte[ebx]
    cmp al,0
    je end
    cmp al,byte[ecx]
    je L1
    inc ebx
     mov dword[adr1],ebx
     inc word[i]
    jmp loopk
L1:
    mov dx,word[i]
      cmp byte[ecx],0
    je L3
    mov al,byte[ebx]
    cmp al,0
    je L2
    cmp al,byte[ecx]
    jne L2
    inc ecx
    inc ebx
    jmp L1
L2:
    mov ecx,string1
    inc dword[adr1]
    inc word[i]
    jmp loopk
L3:
    mov word[ans],dx
    mov word[num],dx
    call print_num
    mov eax,1
    mov ebx,0
    int 80h
end:
    
      mov eax , 4
        mov ebx , 1
        mov ecx , msg3
        mov edx , len_msg3
        int 80h
     mov eax,1
    mov ebx,0
    int 80h
    
