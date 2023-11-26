.include "macro-syscalls.m"
.globl main
.eqv    NAME_SIZE 256
.eqv    TEXT_SIZE 512	
    .data
er_name_mes:    .asciz "Incorrect file name\n"
er_read_mes:    .asciz "Incorrect read operation\n"
er_index: .word -1
ans_yes: .asciz "Y"
file_name:      .space	NAME_SIZE		
answer:      .space	NAME_SIZE
strbuf:	.space TEXT_SIZE	# Buffer for text
        .text
        main:
        print_str ("Input N: ")
        read_int(a1)
        check_size_(a1) # use macro to check that N > -1 (correct sequence length) 
        beqz a0 incorrect_n
        mv s9 a1  # Save N
         print_str ("Input path to file for reading: ")
    	str_get(file_name, NAME_SIZE) # Entering the file name from the console
    	input_file(file_name)
    	lw a1 er_index
    	beq a0 a1 exit
    	mv s3 a3  # Save start of string (file)
   	find_sequence(s3, s9) #
   	mv s10 a4  # Save start of  result subsequence
   	print_str("Do you want to print the file data in the console? Y/N: ")
    	str_get(answer, NAME_SIZE)
    	lb      t1 (a0)      # Get first symbol
    	la      a1 ans_yes
    	lb      t2 (a1)     # Load symbol from ans_yes = Y
    	bne t1 t2 if_no
    	
    	
    beqz a5 if_no_sequence
    
    	# Output text in console
    	if_yes:
    	mv	a0	s10	
    	li 	a7 4
    	ecall
    	newline
    	if_no: 
    	print_str ("Input path to file for writing: ")
    	str_get(file_name, NAME_SIZE)
   	output_file(file_name, s10, s9) 
 exit:
   	clear
    	exit # macro exit
if_no_sequence:
	print_str("There are no sequences in the file!\n")
	print_str ("Input path to file for writing: ")
    	str_get(file_name, NAME_SIZE)
	output_file(file_name,s10, zero)
	clear
	exit 
incorrect_n: 
	print_str("N < 0! Incorrect sequence length \n")
	b exit