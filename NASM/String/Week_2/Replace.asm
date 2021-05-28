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
msg2 : db 'Enter the word to be replaced',0ah
len_msg2: equ $-msg2
msg3 : db 'Enter the word to be placed ',0ah
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
count  : resb 1
n      : resd 1

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
	mov eax , 4
        mov ebx , 1
        mov ecx , msg2
        mov edx , len_msg2
        int 80h
	mov ebx,string_s
	call read_string

	mov eax , 4
        mov ebx , 1
        mov ecx , msg3
        mov edx , len_msg3
        int 80h
	mov ebx,string_p
	call read_string
	mov ebx,string_s
loopk:
	mov al,byte[ebx]
	cmp al,0
	je end
	inc word[len_string_s]
	inc ebx
	jmp loopk
end:
    mov ebx,string
    mov ecx,string_s
    mov edx,string4

loop1:
    mov al,byte[ebx]
    cmp al,0
    je L1
    cmp al ,' '
    je check
    cmp al,byte[ecx]
    je matched
    inc ebx
    jmp loop1
matched:
    inc ecx
    inc ebx
    inc word[matched_cnt]
    jmp loop1 

check:
	mov eax,0
	mov ax,word[matched_cnt]
	cmp ax,word[len_string_s]
	je L1
	inc ebx
	inc word[space_cnt]
	jmp loop1
L1:
	mov ebx,string
	mov edx,string4
loop2:	
	mov eax,0
	mov ax,word[counter]
	cmp ax,word[space_cnt]
	je L2
	mov al,byte[ebx]
	cmp al,' '
	je go
	mov byte[edx],al
	inc ebx
	inc edx
	jmp loop2
go:
	mov byte[edx],al
	inc word[counter]
	inc ebx
	inc edx
	jmp loop2
L2:
	mov ecx,string_p
; 	mov byte[edx],0
; 	pusha
; 	mov ebx,string4
; 	call print_string
; 	 popa
loop3:
	mov al,byte[ecx]
	cmp al,0
	je L3
	mov byte[edx],al
	inc ecx
	inc edx
	jmp loop3
L3:
	mov byte[edx],' '
	inc edx
	mov word[counter],0
forward:
	mov ax,word[counter]
	inc ebx
	cmp ax,word[matched_cnt]
	je L4
	inc word[counter]
	jmp forward
L4:
	mov al,byte[ebx]
	mov byte[edx],al
	cmp al,0
	je end_all
	inc edx
	inc ebx
	jmp L4
end_all:
	mov eax , 4
        mov ebx , 1
        mov ecx , msg4
        mov edx , len_msg4
        int 80h
	mov ebx,string4
	call print_string
	mov eax,1
	mov ebx,0
	int 80h

	


  