
.section .data

.section .text
.globl _start
_start:
 # computes 2^3 + 5^2
 pushl $2    # second param
 pushl $5    # first param
 call power

 addl $8, %esp
 pushl %eax

 pushl $3
 pushl $2
 call power
 addl $8, %esp

 popl %ebx
 addl %eax, %ebx

 movl $1, %eax
 int $0x80

# vars: %ebx - holds base number
#       %ecx - holds power
#       -4(%ebp) - current result (local var)
#       %eax - temp storage
.type power, @function
power:
 pushl %ebp   	   # save the current stack pointer
 movl %esp, %ebp   # base pointer = current spack pointer
 subl $4, %esp      # reserve one word for one local var

 # stack at the start of power:
 # - Params
 # - Ret addrs
 # - Old ebp
 # - Local vars
 movl 8(%ebp), %ebx
 movl 12(%ebp), %ecx
 movl %ebx, -4(%ebp) 

power_loop:
 cmpl $1, %ecx
 je power_return

 movl -4(%ebp), %eax
 imull %ebx, %eax
 movl %eax, -4(%ebp)

 decl %ecx
 jmp power_loop

power_return:
 movl -4(%ebp), %eax    # move local var to return register
 movl %ebp, %esp        # move esp to its base pointer, discarding local vars
 popl %ebp              # re-set old base pointer of calling function
 ret                    # calling ret continues where it left off
