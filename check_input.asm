.global check_size
.include "macro-syscalls.m"

# check_size: checks the entered N to satisfy the condition  N > -1
# if it is true subprogram return 0 else 1 in register a0
# Parameter a1 -- value (length) for checking
check_size:
	
	li a0, 1   # Assumption that accurancy is correct, so a0 = 1
	
	li a2, 3     # Check if size < 0 a0 = 0
	blt a1, zero, incorrect_size_error
	
	end_check: 
	ret 	
	
	incorrect_size_error:
	li a0 0
	ret
	
