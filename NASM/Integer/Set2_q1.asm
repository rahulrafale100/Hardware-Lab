 section .data
msg1: db "Enter size of the Array",0Ah
size1: equ $-msg1
msg2: db "Enter array elements",0Ah
size2: equ $-msg2
k: db 30h
odd: dd 0
even: dd 0
newline: db 10
msg_e: db "Number of even elements are: "
size_e: equ $-msg_e
msg_o: db "Number of odd elements are: "
size_o: equ $-msg_o


section .bss
array: resd 50
elem:resd 1
x: resd 1
digit:resb 1
n: resd 1
count: resd 1
number: resd 1
nod: resb 1
temp: resb 1
nod1: resb 1
temp1: resb 1
 

section .text
global _start:
_start:

mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,size1
int 80h

mov byte[digit],30h
mov dword[n],0
read_size:

	sub byte[digit],30h

	mov eax,dword[n]
	mov ebx,10
	mul ebx
        
	movzx ecx ,byte[digit]
   	add eax,ecx

	mov dword[n],eax

	mov eax,3
	mov ebx,0
	mov ecx,digit
	mov edx,1
	int 80h
	
	cmp byte[digit],10
	jne read_size
	  
mov edx,dword[n]
mov dword[count],edx

mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,size2
int 80h

mov eax,array

read_array:

	push eax
        mov dword[elem],0
        mov byte[digit],30h

	read_element:	
		sub byte[digit],30h
		mov eax,dword[elem]
		mov ebx,10
		mul ebx
		movzx ecx ,byte[digit]
   		add eax,ecx
		mov dword[elem],eax

		mov eax,3
		mov ebx,0
		mov ecx,digit
		mov edx,1
		int 80h
	
		cmp byte[digit],10

	jne read_element

        mov ecx,dword[elem]
	pop eax	
	mov dword[eax],ecx
        add eax,4
	dec dword[count]
	cmp dword[count],0

ja read_array
mov ebx,array

for:

	mov eax,dword[ebx]
	mov edx,0
	mov ecx,2
	div ecx
	cmp edx,0
	jne odd_part
	
	inc dword[even]
	jmp escape
	
        odd_part:
	   inc dword[odd]

	escape:
	
	add ebx ,4
	dec dword[n]
	cmp dword[n],0

jne for

mov eax,4
mov ebx,1
mov ecx,msg_e
mov edx,size_e
int 80h

mov byte[nod],0
print_num:
cmp dword[even],0
je print
mov eax,dword[even]
mov edx,0
mov ebx,10
div ebx
push edx
inc byte[nod]
mov dword[even],eax
jmp print_num

print:
cmp byte[nod],0
je end_print
pop edx
dec byte[nod]
mov byte[temp],dl
add byte[temp],30h
pusha
mov eax,4
mov ebx,1
mov ecx,temp
mov edx,1
int 80h
popa
jmp print

end_print:
mov eax,4
mov ebx,1
mov ecx,newline
mov edx,1
int 80h



mov eax,4
mov ebx,1
mov ecx,msg_o
mov edx,size_o
int 80h



mov byte[nod1],0
print_num1:
cmp dword[odd],0
je print1
mov eax,dword[odd]
mov edx,0
mov ebx,10
div ebx
push edx
inc byte[nod1]
mov dword[odd],eax
jmp print_num1

print1:
cmp byte[nod1],0
je end_print1
pop edx
dec byte[nod1]
mov byte[temp1],dl
add byte[temp1],30h
pusha
mov eax,4
mov ebx,1
mov ecx,temp1
mov edx,1
int 80h
popa
jmp print1

end_print1:
mov eax,4
mov ebx,1
mov ecx,newline
mov edx,1
int 80h


mov eax,1
mov ebx,0
int 80h      
	