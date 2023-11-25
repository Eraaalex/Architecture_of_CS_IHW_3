.include "macro-syscalls.m"
.globl main
.eqv    NAME_SIZE 256	# Размер буфера для имени файла
.eqv    TEXT_SIZE 512	# Размер буфера для текста
    .data
er_name_mes:    .asciz "Incorrect file name\n"
er_read_mes:    .asciz "Incorrect read operation\n"
er_index: .word -1
ans_yes: .asciz "Y"
file_name:      .space	NAME_SIZE		# Имячитаемого файла
answer:      .space	NAME_SIZE
strbuf:	.space TEXT_SIZE			# Буфер для читаемого текста
        .text
        main:
        print_str ("Input N: ")
        read_int(a1)
        mv s9 a1  # Save N
         print_str ("Input path to file for reading: ") # Вывод подсказки
    	# Ввод имени файла с консоли эмулятора
    	str_get(file_name, NAME_SIZE)
    	input_file(file_name)
    	lw a1 er_index
    	beq a0 a1 exit
    	mv s3 a3  # Save start of string (file)
   	find_sequence(s3, s9) #
   	mv s10 a4  # Save start of  result subsequence
   	print_str("Do you want to print file data in concole? Y/N: ")
    	str_get(answer, NAME_SIZE)
    	lb      t1 (a0) # get first symbol
    	la      a1 ans_yes
    	lb      t2 (a1)     # Load symbol from ans_yes = Y
    	bne t1 t2 if_no
    	
    	
    beqz a5 if_no_sequence
    
    	# Output text into console
    	if_yes:
    	mv	a0	s10	
    	li 	a7 4
    	ecall
    	newline
    	if_no: 
    	print_str ("Input path to file for writing: ")
    	str_get(file_name, NAME_SIZE) # Ввод имени файла с консоли эмулятора
   	output_file(file_name, s10, s9) 
 exit:
   	clear
    	exit # macro exit
if_no_sequence:
	print_str("There are no sequences in the file!\n")
	print_str ("Input path to file for writing: ")
    	str_get(file_name, NAME_SIZE) # Ввод имени файла с консоли эмулятора
	output_file(file_name,s10, zero)
	exit 
