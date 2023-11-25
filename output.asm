.include "macro-syscalls.m"
.globl output_file
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
output_file: # a3 -- s9 
    
# Сохранение прочитанного файла в другом файле
    
    li		t1 -1			# Проверка на корректное открытие
    beq		a0 t1 er_name	# Ошибка открытия файла
    mv   	t0 a0       	# Сохранение дескриптора файла
	# Запись информации в открытый файл
    li   a7, 64       		# Системный вызов для записи в файл
    mv   a0, t0 			# Дескриптор файла
    mv   a1, a2  			# Адрес буфера записываемого текста
    mv   a2, a3   			# Размер записываемой порции из регистра
    ecall             		# Запись в файл
    ret
    
er_name:
    # Сообщение об ошибочном имени файла
    la		a0 er_name_mes
    li		a7 4
    ecall
    # И завершение программы
    li a0 -1
    ret
