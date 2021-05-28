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
left: dw 1
right : dw 0



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
	mov byte[ebx],0
	inc ebx
	call read_string
	mov ebx,string
	inc ebx
loopk:
    mov al,byte[ebx]
    cmp al,0
    je L1
    cmp al,'('
    je L2
    cmp al,')'
    je L3
go:
    inc ebx
    jmp loopk
    
L2: 

    inc word[left]
    
    jmp check
L3:
    dec word[left]
    jmp check
    
check:
    cmp word[left],1
    jb modify
    jmp go
modify:
;mov al,byte[space]
    mov byte[ebx],10
    mov word[left],1
    jmp go
L1:
    dec ebx
loop1:
    mov al,byte[ebx]
    cmp al,0
    je end_it
    cmp al,'('
    je L22
    cmp al,')'
    je L33
go_again:
    dec ebx
    jmp loop1

L22:
    inc word[right]
    jmp go_again
L33:
    dec word[right]
    jmp go_again

end_it:
    mov edx,string1
    inc ebx
loop2:
    mov al,byte[ebx]
    cmp al,0
    je end_all
    cmp al,10
    je ahead
    mov byte[edx],al
    inc edx
ahead:
    inc ebx
    jmp loop2
    
end_all:
    loop3:
        cmp word[right],0
        je allout
        mov byte[edx],')'
        inc edx
        dec word[right]
        jmp loop3
allout:
    mov byte[edx],0

  ;  mov byte[edx],0
    mov ebx ,string1
    call print_string
    mov eax,1
    mov ebx,0
    int 80h
  