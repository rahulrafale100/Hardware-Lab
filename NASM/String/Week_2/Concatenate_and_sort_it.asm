go_down:
    	pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , down
	mov edx , 1
	int 80h
	popa

ret

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
msg3 : db 'Enter the word to be placed ',0ah
len_msg3: equ $-msg3
msg4 : db 'Final modified string is ',0ah
len_msg4: equ $-msg4
newline : db ' '
down: db 10
n: dd 0



section .bss
count : resb 1
num   : resw 1
temp  : resb 1
num1  : resd 1
string1 : resb 100
string2 : resb 100
string : resb 100
ind_ptr1 : resd 1
ind_ptr2: resd 1
num2 : resd 1
array : resd 100
k     : resd 1
p     : resd 1
num3  : resw 1

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
	
	mov ebx , string2	
	call read_string
	mov edx,string
	mov ebx,string1
	mov ecx,string2
loooopk:
    mov al,byte[ebx]
    cmp al,0
    je Lable1
    mov byte[edx],al
    inc ebx
    inc edx
    jmp loooopk
Lable1:
mov byte[edx],' '
inc edx
loooop1:
    mov al,byte[ecx]
    cmp al,0
    je Lable2
    mov byte[edx],al
    inc edx
    inc ecx
    jmp loooop1
Lable2:
    mov byte[edx],0
  
   
 




; ------------------------------------
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
  ;call print_array
;-----------------------------------------------------------------------------------------------
        mov eax , 0
	    mov eax,dword[n]
	    mov dword[k],eax
	    dec dword[k]
	    mov eax,0
	    mov dword[ind_ptr1],0
for_loop1:

        mov eax,dword[ind_ptr1]
        cmp eax,dword[n]
        je end_exit
        inc dword[ind_ptr1]
        mov dword[ind_ptr2],0
        for_loop2:
            mov ecx,dword[ind_ptr2]
            cmp ecx,dword[k]
            je end_for_loop2
            mov ebx,array
            mov eax,dword[ebx+4*ecx]
            mov dword[num1],eax
            inc dword[ind_ptr2]
            mov eax,dword[ind_ptr2]
            mov edx,dword[ebx+4*eax]
            mov dword[num2],edx
            mov eax,dword[num1]
            mov ebx,dword[num2]
	    jmp compare
          ;; cmp ax,bx
            ja L1
continue:
            jmp for_loop2
compare:
  	cmp byte[eax],0
	je L1
	cmp byte[ebx],0
	je L2
	mov ecx,0
	mov edx,0
	mov cl,byte[eax]
	mov dl ,byte[ebx]
	cmp cl,dl
	jne L1
	inc eax
	inc ebx
	jmp compare

L1:
	mov ecx,0
	mov edx,0
	mov cl,byte[eax]
	mov dl ,byte[ebx]
	cmp cl,dl	
	je continue
	jb continue
	ja greater

L2:	
	jmp greater

greater:
	jmp rearrange
;-----------------------------------------------------------	
rearrange:
    mov ebx,array
    dec dword[ind_ptr2]
    mov ecx,dword[ind_ptr2]
    inc dword[ind_ptr2]
    mov eax,dword[num2]
    mov dword[ebx+4*ecx],eax
    mov ecx,dword[ind_ptr2]
    mov eax,dword[num1]
    mov dword[ebx+4*ecx],eax
    jmp for_loop2
    
end_for_loop2:
    jmp for_loop1
end_exit:
  	mov ecx,array
looping:
	cmp dword[n],0
	je end_all
	mov ebx,dword[ecx]
	call print_string
	mov word[num],bx
	;call print_num
	add ecx,4
	dec dword[n]
	jmp looping
end_all:
 call go_down
	mov eax,1
	mov ebx,0
	int 80h
	

  