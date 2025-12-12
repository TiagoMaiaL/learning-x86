
.section .data

.section .text
.globl _start
_start:
 pushl $5
 call factorial

 movl $1, %eax
 int $0x80

# %ebx - holds return value
.type factorial, @function
factorial:
 pushl %ebp
 movl %esp, %ebp

 movl 8(%ebp), %ebx
 cmpl $1, %ebx
 jle factorial_return

 decl %ebx
 pushl %ebx
 call factorial

 imull 8(%ebp), %ebx

factorial_return:
 movl %ebp, %esp
 popl %ebp
 ret
