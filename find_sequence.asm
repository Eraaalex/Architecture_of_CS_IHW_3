.include "macro-syscalls.m"
.globl find_sequence
.data 
one: .word 1
.text
find_sequence: 
# The function receives as input the address of the string and the number of elements for the subsequence. 
# Sequentially reads each character starting from (a0), if N elements in a row are greater than the previous ones, 
# the beginning of such a sequence is preserved, 
# if not, then the sequence from (a0+1) position to N is considered, and so on.

# a0 -- string address; a1 -- N;  -- parameters passed to the function
# a4 -- start of sequenc; a5 - checking index; --- the returned parameter from the function
# a5 - checking index: if sequence exists a5 = 1 else a5 = 0

li t0 0 # 0..N counter
mv t2 a0 # start of sequence
mv t3 a0 # start of result sequence
li t5 0  # if sequence exists t5 = 1 else t5 = 0
blez a1 if_zero
loop:
    lb      t1 (a0) # Load the string symbol 
    beqz    t1 end  # if \0
    
    beq zero t0 if_greater_previous # first element is automatically larger than previous
    if_not_start:
    	addi a0 a0 -1
    	lb      t4 (a0)  # read previous symbol
    	addi a0 a0 1
    	bgt t1 t4 if_greater_previous
    	if_less_previous:
    		addi t2 t2 1   # start for the next sequence
		mv a0 t2      
		li t0 0  # counter = 0 
    		b loop
    	if_greater_previous:
    		addi t0 t0 1
    addi    a0 a0 1		# Next symbol for initial string
 
    beq t0 a1 save_sequence
    b loop
    
save_sequence:	
	mv t3  t2      # start of result sequence
	addi t2 t2 1   # start for the next sequence
	mv a0 t2 
	li t0 0        # counter = 0
	li t5 1        # sequence exists
    	b loop
end:

mv a4 t3 # return start of sequence
mv a5 t5
bnez t5 add_zero
ret
add_zero: 
add t3 t3 a1 		# Find end of string
sb   zero (t3)       # Store the last symbol in the destination string
ret
if_zero: 
li a4 0  
mv a5 t5
	ret

