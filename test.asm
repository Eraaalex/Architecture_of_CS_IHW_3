.include "macro-syscalls.m"
.globl tests
.data
file_name_1:       .asciz "Incorrect file name\n"
file_name_2:       .asciz "C:\\Users\\Eraaa\\Pictures\\Architecture_of_�S\\Individual_HomeAssesment_3\\test_files\\test1.txt"
file_name_3:       .asciz "C:\\Users\\Eraaa\\Pictures\\Architecture_of_�S\\Individual_HomeAssesment_3\\test_files\\empty.txt"
file_name_4:       .asciz "C:\\Users\\Eraaa\\Pictures\\Architecture_of_�S\\Individual_HomeAssesment_3\\test_files\\output1.txt"
file_name_5:       .asciz "C:\\Users\\Eraaa\\Pictures\\Architecture_of_�S\\Individual_HomeAssesment_3\\test_files\\output2.txt"
file_name_6:       .asciz "C:\\Users\\Eraaa\\Pictures\\Architecture_of_�S\\Individual_HomeAssesment_3\\test_files\\output3.txt"

string_1:       .asciz "abcdefghijk"
string_2:       .asciz "abcde\niksge\abcdefA"
string_3:       .asciz ""
string_4:       .asciz "edcba"
string_5:       .asciz "ABCD"
N_1: .word 0
N_2: .word 4
er_index: .word -1
.text
tests:
	print_str("Test 1: abcdefghijk; Expected result = hijk; Result = ")
		la a0 string_1
		lw a1 N_2
		jal find_sequence
		mv a0 a4  # Save start of  result subsequence	
		li a7 4
		ecall
		newline
		newline
	print_str("Test 2: abcdefghijk, N = 0; Expected result = error_message ; Result = ")
		la a0 string_1
		lw a1 N_1
		jal find_sequence
		beqz a5 er_sequence
		mv a0 a4  # Save start of  result subsequence	
		li a7 4
		ecall
		er_sequence: 
		print_str("There are no sequences of this length")
		newline
		newline
	print_str("Test 3: edcba, N = 4; Expected result = error_message ; Result = ")
		la a0 string_4
		lw a1 N_2
		jal find_sequence
		beqz a5 er_sequence_test3
		mv a0 a4  # Save start of  result subsequence	
		li a7 4
		ecall
		er_sequence_test3: 
		print_str("There are no sequences of this length")
		newline
		newline
	print_str("Test 4: abcde\niksge\abcdefA, N = 4; Expected result = cdef ; Result = ")
		la a0 string_2
		lw a1 N_2
		jal find_sequence
		mv a0 a4  # Save start of  result subsequence	
		li a7 4
		ecall
		newline
		newline 
		
	print_str("Test 5: file: incorrect file name; Expected result = (a0 = -1) ; Result = ")
		open(file_name_1,  READ_ONLY)
		jal input_file
		lw a1 er_index
    		beq a0 a1 er_
    		# print test text 
    		mv a0 a3  # Save start of string (file)
    		li a7 4
    		ecall
		er_:
		print_str("a0 = -1")
		
		newline
		newline
	print_str("Test 6: file: test1.txt; Expected result = abcdefghGFBA ; Result = ")
		open(file_name_2,  READ_ONLY)
		jal input_file
    		# print test text 
    		mv a0 a3  # Save start of string (file)
    		li a7 4
    		ecall
		newline
		newline
	
	print_str("Test 7: file: empty.txt; Expected result =  ; Result = ")
		open(file_name_3,  READ_ONLY)
		jal input_file
    		# print test text 
    		mv a0 a3  # Save start of string (file)
    		li a7 4
    		ecall
		newline
		newline
	
	print_str("Test 8: file: output1.txt; Expected result: the string ABCD is written to the file;  ")
		open(file_name_4,  WRITE_ONLY)
		la a2 string_5
		lw a3 N_2
		jal output_file
		newline
		newline
	print_str("Test 8: file: incorrect name; Expected result: Incorrect file name; Result =   ")
		open(file_name_1,  WRITE_ONLY)
		la a2 string_5
		lw a3 N_2
		jal output_file
		newline
		newline
	exit
