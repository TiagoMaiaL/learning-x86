
.section .data

msg: 
 .string "Hello world!\n"

.section .text
.globl _start
_start:
 movl $4, %eax
 movl $1, %ebx
 movl $msg, %ecx
 movl $13, %edx
 int $0x80

 movl $1, %eax
 int $0x80

