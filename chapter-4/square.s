.section .data

.section .text
.globl _start
_start:
 pushl $5
 call square

 movl $1, %eax
 int $0x80

# %eax - temp storage
# %ebx - final result
.type square, @function
square:
 pushl %ebp
 movl %esp, %ebp
 movl 8(%ebp), %eax
 movl %eax, %ebx
 imull %eax, %ebx

 movl %ebp, %esp
 popl %ebp
 ret
