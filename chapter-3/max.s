# finds and returns the highest number from a list.

.section .data

# data_items contains the numbers to be compared.
# %edi holds the current index
# %eax holds current element being examined
# %ebx holds highest value

count: 
 .long 12

data_items:
 .long 3,67,34,222,45,75,54,34,44,33,22,11,66

.section .text

.globl _start
_start:
 movl $0, %edi
 movl data_items(,%edi,4), %eax
 movl %eax, %ebx

start_loop:
 cmpl count, %edi
 je loop_exit
 incl %edi
 movl data_items(,%edi,4), %eax
 cmpl %ebx, %eax
 jle start_loop
 
 movl %eax, %ebx
 jmp start_loop

loop_exit:
 movl $1, %eax
 int $0x80
