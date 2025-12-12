
.section .data

 .equ SYS_OPEN, 5
 .equ SYS_WRITE, 4
 .equ SYS_READ, 3
 .equ SYS_CLOSE, 6
 .equ SYS_EXIT, 1

 .equ RDONLY, 0
 .equ CREAT_WRONLY_TRUNC, 03101

 .equ LINUX_SYSCALL, 0x80
 .equ FILE_END, 0

 .equ STDIN, 0
 .equ STDOUT, 1
 .equ STDERR, 2

 .equ SIZE_RESERVE, 8
 .equ FD_IN, -4
 .equ FD_OUT, -8
 .equ ARGC, 0
 .equ ARGV_0, 4
 .equ ARGV_1, 8
 .equ ARGV_2, 12

.section .bss

 .equ BUFFER_SIZE, 500
 .lcomm BUFFER, BUFFER_SIZE

.section .text

.globl _start
_start:
 movl %esp, %ebp
 subl $SIZE_RESERVE, %esp

open_files:
open_fd_in:
 movl $SYS_OPEN, %eax
 movl ARGV_1(%ebp), %ebx
 movl $RDONLY, %ecx
 movl $0666, %edx
 int $LINUX_SYSCALL

store_fd_in:
 movl %eax, FD_IN(%ebp)

open_fd_out:
 movl $SYS_OPEN, %eax
 movl ARGV_2(%ebp), %ebx
 movl $CREAT_WRONLY_TRUNC, %ecx
 movl $0666, %edx
 int $LINUX_SYSCALL

store_fd_out:
 movl %eax, FD_OUT(%ebp)
 
read_write_loop:
 movl $SYS_READ, %eax
 movl FD_IN(%ebp), %ebx
 movl $BUFFER, %ecx
 movl $BUFFER_SIZE, %edx
 int $LINUX_SYSCALL

 cmpl $FILE_END, %eax
 jle end_read_write_loop

 pushl $BUFFER
 pushl %eax # read buffer size
 call convert_to_upper
 popl %eax
 addl $4, %esp

 movl %eax, %edx
 movl $SYS_WRITE, %eax
 movl FD_OUT(%ebp), %ebx
 movl $BUFFER, %ecx
 int $LINUX_SYSCALL

 jmp read_write_loop
 
end_read_write_loop:
 movl $SYS_CLOSE, %eax
 movl FD_IN(%ebp), %ebx
 int $LINUX_SYSCALL

 movl $SYS_CLOSE, %eax
 movl FD_OUT(%ebp), %ebx
 int $LINUX_SYSCALL

 movl $SYS_EXIT, %eax
 movl $0, %ebx
 int $LINUX_SYSCALL

 .equ LOW_A, 'a' 
 .equ LOW_Z, 'z' 
 .equ UPPER_CONVERSION, 'A' - 'a' 

 .equ BUFFER_LEN_PARAM, 8
 .equ BUFFER_PARAM, 12
.type convert_to_upper, @function
convert_to_upper:
 pushl %ebp
 movl %esp, %ebp

 movl BUFFER_PARAM(%ebp), %eax
 movl BUFFER_LEN_PARAM(%ebp), %ebx
 movl $0, %edi

 cmpl $0, %ebx
 je end_convert_loop

convert_loop:
 movb (%eax,%edi,1), %cl

 cmpb $LOW_A, %cl
 jl next_byte
 cmpb $LOW_Z, %cl
 jg next_byte

 addb $UPPER_CONVERSION, %cl
 movb %cl, (%eax,%edi,1)

next_byte:
 incl %edi
 cmpl %ebx, %edi
 jne convert_loop

end_convert_loop:
 movl %ebp, %esp
 popl %ebp
 ret
