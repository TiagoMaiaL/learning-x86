
.section .data

.section .text
.globl _start
_start:
 pushl $7
 call fibonacci

 movl $1, %eax
 int $0x80

# %ebx - holds return value
.type fibonacci, @function
fibonacci:
 pushl %ebp
 movl %esp, %ebp

 subl $4, %esp
 movl $0, -4(%ebp)
 movl 8(%ebp), %ebx

 cmpl $1, %ebx
 jle fibonacci_return

 decl %ebx
 pushl %ebx
 call fibonacci

 movl %ebx, -4(%ebp)

 movl 8(%ebp), %ebx
 subl $2, %ebx
 pushl %ebx
 call fibonacci

 movl -4(%ebp), %eax

 addl %eax, %ebx

fibonacci_return:
 movl %ebp, %esp
 popl %ebp
 ret
