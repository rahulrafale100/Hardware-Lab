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
msg3 : db 'Reversed string is : '
len_msg3: equ $-msg3
newline : db 10
space : db ' '


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
;-------------------------------	
mov ebx,string1
;call print_string
mov ecx,string3
loopkp:
    mov al,byte[ebx]
    cmp al,0
    je exitp
    cmp al,'a'
    jnb L1p
    cmp al,'A'
    jnb L2p
    cmp al,'1'
    jnb L3p
  
	inc ebx
	jmp loopkp
L1p:
    cmp al,'z'
    jna L11p
	inc ebx
	jmp loopk
L11p:
    mov byte[ecx],al
	inc ebx
	inc ecx
	jmp loopkp
L2p:
        cmp al,'Z'
    jna L22p
	inc ebx
	jmp loopkp
L22p:
    mov byte[ecx],al
	inc ebx
	inc ecx
	jmp loopkp
L3p:
            cmp al,'9'
    jna L33p
	inc ebx
	jmp loopkp
L33p:
    mov byte[ecx],al
  
	inc ebx
	inc ecx
	jmp loopkp
    	
	
	
exitp:
    mov byte[ecx],0
    mov ebx,string3
  ; call print_string
	
	
	
	
	
	
	
	
	
	
	
	
	
;--------------------------------------------	
   	mov ebx,string3
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
	je L1t
	dec byte[count]
	pop ax
	mov byte[ecx],al
	inc ecx
	jmp end_extract

L1t:
	mov byte[ecx],0

mov ebx,string1
;call print_string
mov ecx,string2
loopk:
    mov al,byte[ebx]
    cmp al,0
    je exit
    cmp al,'a'
    jnb L1
    cmp al,'A'
    jnb L2
    cmp al,'1'
    jnb L3
    mov byte[temp],al
    pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
	popa
	inc ebx
	jmp loopk
L1:
    cmp al,'z'
    jna L11
    mov byte[temp],al
    pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
	popa
	inc ebx
	jmp loopk
L11:
    mov al,byte[ecx]
       mov byte[temp],al
    pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
	popa
	inc ebx
	inc ecx
	jmp loopk
L2:
        cmp al,'Z'
    jna L22
    mov byte[temp],al
    pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
	popa
	inc ebx
	jmp loopk
L22:
    mov al,byte[ecx]
       mov byte[temp],al
    pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
	popa
	inc ebx
	inc ecx
	jmp loopk
L3:
            cmp al,'9'
    jna L33
    mov byte[temp],al
    pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
	popa
	inc ebx
	jmp loopk
L33:
    mov al,byte[ecx]
       mov byte[temp],al
    pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
	popa
	inc ebx
	inc ecx
	jmp loopk
    
    
    
exit:
	mov eax, 1
	mov ebx,0
	int 80h
