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
msg2 : db 'Length of longest repeating Subsequence is: '
len_msg2: equ $-msg2
newline : db 10
space : db ' '
s1_cnt: dw 0
s3_cnt: dw 0
matched_cnt : dw 0
len_string: dw 0
row: dw 0
column: dw 0


section .bss
temp   : resb 1
string: resb 100
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
	call read_string

	mov ebx,string
loopk:
	mov al,byte[ebx]
	cmp al,0
	je end
	inc word[len_string]
	inc ebx
	jmp loopk
end:
	mov dx,word[len_string]
	mov word[n],dx
	mov word[m],dx
	inc word[m]
	inc word[n]
	
	mov word[num1],1
for_loop1:
	mov word[num2],1
for_loop2:
    
	mov ebx,string
	dec word[num1]
	mov eax,0
	mov ax,word[num1]
	dec word[num2]
	add ebx,eax
	mov al,byte[ebx]
	mov edx,0
	mov dx,word[num2]
	mov ebx,string
	add ebx,edx
	inc word[num1]
	inc word[num2]
	cmp al ,byte[ebx]
	je L2
go:	
    
    pusha
	dec word[num1]
	mov eax,0
	mov ecx,0
	mov ax,word[num1]
	mov cx,word[n]
	mul cx
	mov dx,word[num2]
	add eax,edx
	mov ebx,dp
	mov cx, word[ebx+2*eax]
	mov word[x],cx
;	mov word[num],cx
;	call print_num
	inc word[num1]
	;------------------------------
	dec word[num2]
	mov eax,0
	mov ecx,0
	mov ax,word[num1]
	mov cx,word[n]
	mul cx
	mov dx,word[num2]
	add eax,edx
	mov ebx,dp
	mov cx, word[ebx+2*eax]
;	mov word[num],cx
;	call print_num
	mov word[y],cx
	inc word[num2]
;	-----------------------------
    
	mov dx,word[x]
	cmp dx,word[y]
	ja goto1
	cmp dx,word[y]
	jna goto2
goto1:
	mov word[z],dx
	jmp place_it
goto2:
	mov dx,word[y]
	mov word[z],dx
	jmp place_it
forward:
	inc word[num2]
	mov ax,word[num2]
	cmp ax,word[n]
	jb for_loop2
	inc word[num1]
	mov cx,word[num1]
	cmp cx, word[n]
	jb for_loop1
	jmp end_all
L2:
	mov ax,word[num1]
	cmp ax,word[num2]
	jne L3
	jmp go
L3:
	pusha
	mov eax,0
	mov ecx,0
	dec word[num1]
	dec word[num2]
	mov ax,word[num1]
	mov cx,word[n]
	mul cx
	mov dx,word[num2]
	add eax,edx
	mov ebx,dp
	mov cx, word[ebx+2*eax]
	add cx,1
	mov word[z],cx
; 	mov word[num],cx
; 	call print_num
	inc word[num1]
	inc word[num2]
	mov eax,0
	mov ecx,0
	mov ax,word[num1]
	mov cx,word[n]
	mul cx
	mov dx,word[num2]
	add eax,edx
	mov ebx,dp
; 	mov word[num],bx
; 	call print_num
	mov cx,word[z]
; 	mov word[num],ax
; 	call print_num
; 	mov word[num],cx
; 	call print_num
	mov word[ebx+2*eax],cx
	popa
	jmp forward
	
place_it:
    mov eax,0
	mov ecx,0
	mov ax,word[num1]
	mov cx,word[n]
	mul cx
	mov dx,word[num2]
	add eax,edx
	mov ebx,dp
	mov cx,word[z]
	mov word[ebx+2*eax],cx
	jmp forward
end_all:
	mov eax,0
	mov ecx,0
	mov ax,word[len_string]
	mov cx,word[n]
	mov word[m],cx
	mul cx
	mov dx,word[len_string]
	add eax,edx
	mov ebx,dp
	mov cx, word[ebx+2*eax]
	mov word[num],cx
	mov eax,0
	;call print_matrix
		    mov eax , 4
        mov ebx , 1
        mov ecx , msg2
        mov edx , len_msg2
        int 80h
	call print_num

	
	mov eax,1
	mov ebx,0
    int 80h
	

	
	


  