read_num:
        pusha
        mov word[num], 0
        loop_read:
                mov eax, 3
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
read_array:
        pusha
        read_loop:
        cmp eax ,dword[n]
        je end_read_arr
        call read_num

        mov cx , word[num]
        mov word[ebx + 2 * eax] , cx

        inc eax
        jmp read_loop
        end_read_arr:
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
msg1: db 'Enter the size of array',10
len_msg1 : equ $-msg1
msg2 : db 'Enter the elements',10
len_msg2 : equ $-msg2
sum: dw 0
msg3 : db 'Sum of elements are: '
len_msg3 :equ $-msg3
msg4 : db 'Average is : '
len_msg4: equ $-msg4
newline : db 10

section .bss
count : resb 1
num   : resw 1
temp  : resb 1
num1  : resw 1
num2  : resd 1
n     : resd 10
array : resw 50
k     : resw 1
num3  : resw 1

section .text
global _start:
_start:
	mov eax,4
	mov ebx,1
	mov ecx,msg1
	mov edx,len_msg1
	int 80h

	 mov word[num] , 0
         call read_num
         mov ax , word[num]
	 mov word[n] , ax
	 mov word[num3],ax
	
	mov eax , 4
        mov ebx , 1
        mov ecx , msg2
        mov edx , len_msg2
        int 80h

	 mov ebx , array
        mov eax , 0
        call read_array
	
	mov eax ,0
	mov dword[num2],0
	for:
		mov eax,dword[num2]
		cmp eax,dword[n]
		je exit
		mov ebx,array
		mov cx,word[ebx+2*eax]
		inc eax
		add word[sum],cx
		mov dword[num2],eax
		jmp for
exit:
	mov eax , 4
        mov ebx , 1
        mov ecx , msg3
        mov edx , len_msg3
        int 80h
	
	mov ax,word[sum]
	mov word[num],ax
	call print_num

	mov eax , 4
        mov ebx , 1
        mov ecx , msg4
        mov edx , len_msg4
        int 80h
        
	mov dx,0
	mov ax,word[sum]
	mov bx,word[num3]
	div word[num3]
	mov word[num],ax
	call print_num

	mov eax , 1
	mov ebx , 0
	int 80h