.include "macro-syscalls.m"
.globl find_sequence
.data 
one: .word 1
.text
find_sequence: # a0 -- start # a1 - N
li t0 0 # 0..N counter
mv t2 a0 # start of sequence
mv t3 a0 # start of result sequence
li t5 0  # if sequence exists t5 = 1 else t5 = 0
blez a1 if_zero
loop:
    lb      t1 (a0)         # Load the string symbol 
    beqz    t1 end  # if \0
    
    beq zero t0 if_greater_previous # start element automatically greater than previous
    if_not_start:
    	addi a0 a0 -1
    	lb      t4 (a0)  # read previous symbol
    	addi a0 a0 1
    	bge t1 t4 if_greater_previous
    	if_less_previous:
    		addi t2 t2 1   # start for the next sequence
		mv a0 t2       #  start-1 for the next sequence
		li t0 0  # counter = 0 
    		b loop
    	if_greater_previous:
    		addi t0 t0 1
    addi    a0 a0 1		# Next symbol for initial string
 
    beq t0 a1 save_sequence
    b loop
    
save_sequence:	
	mv t3  t2  # start of result sequence
	addi t2 t2 1   # start for the next sequence
	mv a0 t2 # 
	li t0 0 # counter = 0
	li t5 1
    	b loop
end:

mv a4 t3 # return start of sequence
mv a5 t5
bnez t5 add_zero
ret
add_zero: 
add t3 t3 a1 # find end of string
sb   zero (t3)       # Store the last symbol in the destination string
ret
if_zero: 
li a4 0  
mv a5 t5
	ret

