
.section .data

file_name: 
 .string "hello-files.txt"

.section .bss

.lcomm file_text, 500

.section .text
.globl _start
_start:
 # Open file
 movl $5, %eax
 movl $file_name, %ebx
 movl $0, %ecx
 movl $0666, %edx
 int $0x80
 pushl %eax

 # Read contents
 movl %eax, %ebx
 movl $3, %eax
 movl $file_text, %ecx
 movl $500, %edx
 int $0x80
 pushl %eax

 # Close file
 movl $6, %eax
 movl 4(%esp), %ebx
 int $0x80
 
 # Exit
 popl %ebx
 movl $1, %eax
 int $0x80
