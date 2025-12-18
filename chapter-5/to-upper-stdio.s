# In this modified version of the program we:
# - Check if argc is 1, and if it is:
#   - Use STDIN and STDOUT as file descriptors
# - If it is 2:
#   - Open the input file and use it to read
#   - Write to STDOUT
# - If it is 3:
#   - Open both files and use them as the 
#     original program

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

 .equ ARGC, 0
 .equ ARGV_0, 4
 .equ ARGV_1, 8
 .equ ARGV_2, 12

.section .bss

 .equ BUFFER_SIZE, 500
 .lcomm BUFFER, BUFFER_SIZE
 .lcomm INPUT_FILE, 4
 .lcomm OUTPUT_FILE, 4

.section .text

.globl _start
_start:
 movl %esp, %ebp

 movl $STDIN, INPUT_FILE
 movl $STDOUT, OUTPUT_FILE

open_files_if_needed:
 cmpl $2, ARGC(%ebp)
 jl read_write_loop

 movl $SYS_OPEN, %eax
 movl ARGV_1(%ebp), %ebx
 movl $RDONLY, %ecx
 movl $0666, %edx
 int $LINUX_SYSCALL

 movl %eax, INPUT_FILE

 cmpl $3, ARGC(%ebp)
 jl read_write_loop

 movl $SYS_OPEN, %eax
 movl ARGV_2(%ebp), %ebx
 movl $CREAT_WRONLY_TRUNC, %ecx
 movl $0666, %edx
 int $LINUX_SYSCALL

 movl %eax, OUTPUT_FILE

read_write_loop:
 movl $SYS_READ, %eax
 movl INPUT_FILE, %ebx
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
 movl OUTPUT_FILE, %ebx
 movl $BUFFER, %ecx
 int $LINUX_SYSCALL

 jmp read_write_loop
 
end_read_write_loop:
 cmpl $2, ARGC(%ebp)
 jl exit

 movl $SYS_CLOSE, %eax
 movl INPUT_FILE, %ebx
 int $LINUX_SYSCALL

 cmpl $3, ARGC(%ebp)
 jl exit

 movl $SYS_CLOSE, %eax
 movl OUTPUT_FILE, %ebx
 int $LINUX_SYSCALL

exit:
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

