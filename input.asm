.include "macro-syscalls.m"
.globl input_file
.eqv    NAME_SIZE 256	# Размер буфера для имени файла
.eqv    TEXT_SIZE 512	# Размер буфера для текста
.data
er_name_mes:    .asciz "Incorrect file name\n"
er_read_mes:    .asciz "Incorrect read operation\n"
ans_yes: .asciz "Y"
file_name:      .space	NAME_SIZE		# Имячитаемого файла
answer:      .space	NAME_SIZE
strbuf:	.space TEXT_SIZE			# Буфер для читаемого текста

.text
input_file:  
    li		t1 -1			# Checking for correct opening
    beq		a0 t1 er_name	#
    mv   	s0 a0       	# Saving a file descriptor
    ###############################################################
    # Выделение начального блока памяти для для буфера в куче
    allocate(TEXT_SIZE)		# The result is stored in a0
    mv 		t3, a0			# Storing the heap address in a register
    mv 		t5, a0			# Storing a mutable heap address in a register
    li		t4, TEXT_SIZE	
    mv		t6, zero		# Setting the initial length of the read text
read_loop:
    read_addr_reg(s0, t5, TEXT_SIZE) # reading for block address from register
    # Проверка на корректное чтение
    beq		a0 t1 er_read	# Ошибка чтения
    mv   	t2 a0       	# Сохранение длины текста
    add 	t6, t6, t2		# Размер текста увеличивается на прочитанную порцию
    # При длине прочитанного текста меньшей, чем размер буфера,
    # необходимо завершить процесс.
    bne		t2 t4 end_loop
    # Иначе расширить буфер и повторить
    allocate(TEXT_SIZE)		# Результат здесь не нужен, но если нужно то...
    add		t5 t5 t2		# Адрес для чтения смещается на размер порции
    b read_loop				# Обработка следующей порции текста из файла
end_loop:
    # Закрытие файла
    close(s0)

    # Установка нуля в конце прочитанной строки
    ###la	t0 strbuf	 # Адрес начала буфера
    mv	t0 t3		# Адрес буфера в куче
    add t0 t0 t6	# Адрес последнего прочитанного символа
    addi t0 t0 1	# Место для нуля
    sb	zero (t0)	# Запись нуля в конец текста
    mv a3 t3  
   ret
   
   
er_name:
    # Сообщение об ошибочном имени файла
    la		a0 er_name_mes
    li		a7 4
    ecall
    li a0 -1
    ret
er_read:
    # Сообщение об ошибочном чтении
    la		a0 er_read_mes
    li		a7 4
    ecall
    li a0 -1
    ret

