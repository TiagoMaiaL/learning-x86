
.section .data

data_items_1:
 .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0
data_items_2:
 .long 99,67,34,22,45,75,54,248,44,33,22,11,66,0
data_items_3:
 .long 3,67,34,22,45,75,54,177,44,33,22,11,66,0

.section .text

.globl _start
_start:
 pushl $data_items_1
 call max
 addl $4, %esp

 pushl $data_items_2
 call max
 addl $4, %esp

 pushl $data_items_3
 call max
 addl $4, %esp

 movl $1, %eax
 int $0x80

# stack contains pointer to the numbers being compared
# %edi holds the current index
# %eax holds current element being examined
# %ebx holds highest value
.type max, @function
max:
 pushl %ebp
 movl %esp, %ebp

 movl $0, %edi
 movl 8(%ebp), %edx
 movl (%edx,%edi,4), %eax
 movl %eax, %ebx

max_loop:
 cmpl $0, %eax
 je max_ret
 incl %edi

 movl (%edx,%edi,4), %eax

 cmpl %ebx, %eax
 jle max_loop
 
 movl %eax, %ebx
 jmp max_loop

max_ret:
 movl %ebp, %esp
 popl %ebp
 ret
