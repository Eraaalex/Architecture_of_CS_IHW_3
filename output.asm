.include "macro-syscalls.m"
.globl output_file
.eqv    NAME_SIZE 256	# Buffer size for the file name
.eqv    TEXT_SIZE 512	# Buffer size for text
.data
er_name_mes:    .asciz "Incorrect file name\n"
er_read_mes:    .asciz "Incorrect read operation\n"
ans_yes: .asciz "Y"
file_name:      .space	NAME_SIZE		# Имя читаемого файла
answer:      .space	NAME_SIZE
strbuf:	.space TEXT_SIZE			# Buffer for readable text
.text
output_file: 
# a3 --  parameter of string size 
# a2 -- parameter of the address of the line output to the file 
# a0 -- checking for correct input if incorrect file name  a0 = -1
    
# Saving the read file in another file
    li		t1 -1			# Checking for correct opening
    beq		a0 t1 er_name	# File opening error
    mv   	t0 a0       	# Saving a file descriptor
# Writing information to an open file
    li   a7, 64       		# System call to write to a file
    mv   a0, t0 			# File descriptor
    mv   a1, a2  			# Address of the buffer of the recorded text
    mv   a2, a3   			# The size of the recorded portion from the register
    ecall             		# Writing to a file
    ret
    
er_name:
    # Error File Name message
    la		a0 er_name_mes
    li		a7 4
    ecall
    li a0 -1
    ret
