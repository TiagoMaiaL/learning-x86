
.section .data

.section .text
.globl _start
_start:
 pushl $5
 call factorial

 movl $1, %eax
 int $0x80

# %ebx - holds accumulated return value
.type factorial, @function
factorial:
 pushl %ebp
 movl %esp, %ebp
 subl $4, %esp

 movl $1, -4(%ebp)
 movl 8(%ebp), %ebx

factorial_loop:
 cmpl $1, %ebx
 jle factorial_return

 movl -4(%ebp), %eax
 imull %ebx, %eax
 movl %eax, -4(%ebp)

 decl %ebx
 jmp factorial_loop

factorial_return:
 movl -4(%ebp), %ebx

 movl %ebp, %esp
 popl %ebp
 ret
