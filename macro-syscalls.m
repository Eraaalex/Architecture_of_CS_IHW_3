
.macro print_int (%x)
	li a7, 1
	mv a0, %x
	ecall
.end_macro

.macro print_imm_int (%x)
	li a7, 1
   	li a0, %x
   	ecall
.end_macro

.macro print_str (%x)
   .data
str:
   .asciz %x
   .text
   push (a0)
   li a7, 4
   la a0, str
   ecall
   pop	(a0)
.end_macro

.macro print_char(%x)
   li a7, 11
   li a0, %x
   ecall
.end_macro

.macro newline
   print_char('\n')
.end_macro

.macro read_int_a0
   li a7, 5
   ecall
.end_macro

.macro read_int( %x)

.data 
input: .asciz "Input N: "
empty: .asciz ""
.text
   la      a0 input
   la a1  empty
   li      a7 59
   ecall 
    li      a7 5
    ecall 
   mv %x, a0
.end_macro

#-------------------------------------------------------------------------------
# Entering a line into a buffer of a given size with replacing the line feed with zero
# %strbuf - buffer address
# %size - limits the size of the input string
.macro str_get(%hint, %strbuf, %size)
.data 
input: .asciz %hint
.text
    la      a0 input
    la      a1 %strbuf
    li      a2 %size
    li      a7 54
    ecall 
    li	t0 '\n'
    la	t1	%strbuf
next:
    lb	t2  (t1)
    beq t0	t2	replace
    addi t1 t1 1
    b	next
replace:
    sb	zero (t1)
    la a0 %strbuf
.end_macro

#-------------------------------------------------------------------------------
# Открытие файла для чтения, записи, дополнения
.eqv READ_ONLY	0	# Открыть для чтения
.eqv WRITE_ONLY	1	# Открыть для записи
.eqv APPEND	    9	# Открыть для добавления
.macro open(%file_name, %opt)
    li   	a7 1024     	# Системный вызов открытия файла
    la      a0 %file_name   # Имя открываемого файла
   #mv      a0 %file_name   # Имя открываемого файла
    li   	a1 %opt        	# Открыть для чтения (флаг = 0)
    ecall             		# Дескриптор файла в a0 или -1)
.end_macro

#-------------------------------------------------------------------------------
# Чтение информации из открытого файла
.macro read(%file_descriptor, %strbuf, %size)
    li   a7, 63       	# Системный вызов для чтения из файла
    mv   a0, %file_descriptor       # Дескриптор файла
    la   a1, %strbuf   	# Адрес буфера для читаемого текста
    li   a2, %size 		# Размер читаемой порции
    ecall             	# Чтение
.end_macro

#-------------------------------------------------------------------------------
# Чтение информации из открытого файла,
# когда адрес буфера в регистре
.macro read_addr_reg(%file_descriptor, %reg, %size)
    li   a7, 63       	# Системный вызов для чтения из файла
    mv   a0, %file_descriptor       # Дескриптор файла
    mv   a1, %reg   	# Адрес буфера для читаемого текста из регистра
    li   a2, %size 		# Размер читаемой порции
    ecall             	# Чтение
.end_macro

.macro close(%file_descriptor)
    li   a7, 57       # Системный вызов закрытия файла
    mv   a0, %file_descriptor  # Дескриптор файла
    ecall             # Закрытие файла
.end_macro

.macro allocate(%size)
    li a7, 9
    li a0, %size	# Memory block size
    ecall
.end_macro

.macro exit
    li a7, 10
    ecall
.end_macro

.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro

.macro find_sequence(%string_start, %size)
	mv a0 %string_start
	mv a1 %size
	jal find_sequence
.end_macro


.macro output_file(%file_name, %string_start, %size)
	open(%file_name,  WRITE_ONLY)	
	mv a2 %string_start
	mv a3 %size
	jal output_file
.end_macro

.macro input_file(%file_name)
	open(%file_name,  READ_ONLY)
	jal input_file
.end_macro
.macro clear
	li s1 0 
	li s10 0
	li s4 0
	li s5 0
	li s6 0
	li s2 0
	li s3 0
.end_macro

.macro check_size_(%x) 
	mv a1 %x  # Save the length value to the a1 register for transmission to the function check_size
	jal check_size
.end_macro

