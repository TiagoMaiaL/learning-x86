
.section .data

.section .bss
.lcomm input, 10

.section .text
.globl _start
_start:
 # Does read syscall wait for a return key?
 # Read from keyboard
 movl $3, %eax
 movl $0, %ebx
 movl $input, %ecx
 movl $10, %edx
 int $0x80

 # Print it out
 movl $4, %eax
 movl $1, %ebx
 movl $input, %ecx
 movl $10, %edx 
 int $0x80

 movl $1, %eax
 int $0x80

