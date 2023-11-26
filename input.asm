.include "macro-syscalls.m"
.globl input_file
.eqv    NAME_SIZE 256	
.eqv    TEXT_SIZE 512	
.data
er_name_mes:    .asciz "Incorrect file name\n"
er_read_mes:    .asciz "Incorrect read operation\n"
ans_yes: .asciz "Y"
file_name:      .space	NAME_SIZE		
answer:      .space	NAME_SIZE
strbuf:	.space TEXT_SIZE			
.text
input_file:  
    li		t1 -1			# Checking for correct opening
    beq		a0 t1 er_name	#
    mv   	s0 a0       	# Saving a file descriptor

    allocate(TEXT_SIZE)		# The result is stored in a0
    mv 		t3, a0			# Storing the heap address in a register
    mv 		t5, a0			# Storing a mutable heap address in a register
    li		t4, TEXT_SIZE	
    mv		t6, zero		# Setting the initial length of the read text
read_loop:
    read_addr_reg(s0, t5, TEXT_SIZE) # reading for block address from register
    beq		a0 t1 er_read	
    mv   	t2 a0      	
    add 	t6, t6, t2	# Ñount number of characters read 	
    bne		t2 t4 end_loop
    allocate(TEXT_SIZE)		
    add		t5 t5 t2		
    b read_loop				
end_loop:
 
    close(s0)  # close file
    li s0 0    # clear 
    # setting zero at the end of the line
    mv	t0 t3		
    add t0 t0 t6	
    addi t0 t0 1	# get last symbol address
    sb	zero (t0)	
    mv a3 t3  
   ret
  
er_name:
    # Error file name message
    la		a0 er_name_mes
    li		a7 4
    ecall
    li a0 -1
    ret
er_read:
    # Error Reading message
    la		a0 er_read_mes
    li		a7 4
    ecall
    li a0 -1
    ret

