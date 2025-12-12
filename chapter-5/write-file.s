
.section .data

file_name:
 .string "wrote.txt"

file_content:
 .string "Sample file content."

.section .text
.globl _start
_start:
 # Create file
 movl $5, %eax
 movl $file_name, %ebx
 movl $0101, %ecx
 movl $0666, %edx
 int $0x80
 pushl %eax

 # Write to the file
 movl %eax, %ebx
 movl $4, %eax
 movl $file_content, %ecx
 movl $20, %edx
 int $0x80
 
 # close it
 movl $6, %eax
 popl %ebx
 int $0x80

 movl $1, %eax
 int $0x80

