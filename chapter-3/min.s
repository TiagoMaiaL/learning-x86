.section .data

count: .long 4
data_items: .long 10, 207, 234, 9, 103

.section .text

.globl _start
_start:
 movl $0, %edi
 movl data_items(,%edi,4), %eax
 movl %eax, %ebx

min_loop:
 cmpl count, %edi
 je exit_min_loop
 
 incl %edi
 movl data_items(,%edi,4), %eax
 cmpl %eax, %ebx
 jl min_loop
 
 movl %eax, %ebx
 jmp min_loop

exit_min_loop:
 movl $1, %eax
 int $0x80
