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
msg1 : db 'Enter the sentence',0ah
len_msg1: equ $- msg1
msg2 : db 'Yes,there is palindrom :-',0ah
len_msg2: equ $-msg2
msg3 : db 'There is no palindrom',0ah
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
;count: dw 0
ans : dw 0



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
count  : resb 1
n      : resd 1
adr1   : resd 1
adr2    : resd 1

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
    mov edx,string1
for_loop1:
    mov dword[adr1],ebx
    mov al,byte[ebx]
    cmp al,0
    je ending
     
    mov byte[edx],al
    inc edx
    mov ecx,dword[adr1]
    inc ecx
    for_loop2:
        mov al,byte[ecx]
        cmp al,0
        je Lable1
        mov byte[edx],al
        inc edx
     
        jmp check_palindrome
       
    again:
        inc ecx
        jmp for_loop2
    Lable1:
        inc ebx
        mov edx,string1
            jmp for_loop1
check_palindrome:
    mov byte[edx],0

    pusha
  ;  -----------------------------------
       	mov ebx,string1
	mov ecx,string2
	mov byte[count],0
	
    extract_char:
	cmp byte[ebx],0
	je end_extract
	inc byte[count]
	mov al,byte[ebx]
	push ax
	inc ebx
	jmp extract_char
end_extract:
	cmp byte[count],0
	je L1
	dec byte[count]
	pop ax
	mov byte[ecx],al
	inc ecx
	jmp end_extract

L1:
	mov byte[ecx],0
    mov ebx,0
    mov ecx,0
	mov ebx,string1

	mov ecx,string2

	
compare:
    cmp byte[ecx],0
	je L2
	mov eax,0
	mov edx,0
	mov al,byte[ebx]
	mov dl ,byte[ecx]
	cmp al,dl
	jne L3
	inc ebx
	inc ecx
	jmp compare
L2:
	mov eax , 4
    mov ebx , 1
    mov ecx , msg2
    mov edx , len_msg2
    int 80h
    mov ebx,string1
    call print_string
    mov eax,1
	mov ebx,0
	int 80h

L3:
    popa
    jmp again
ending:
	mov eax , 4
    mov ebx , 1
    mov ecx , msg3
    mov edx , len_msg3
    int 80h
    mov eax,1
    mov ebx,0
    int 80h
    
    
    