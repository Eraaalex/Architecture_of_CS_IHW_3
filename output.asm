.include "macro-syscalls.m"
.globl output_file
.eqv    NAME_SIZE 256	# ������ ������ ��� ����� �����
.eqv    TEXT_SIZE 512	# ������ ������ ��� ������
.data
er_name_mes:    .asciz "Incorrect file name\n"
er_read_mes:    .asciz "Incorrect read operation\n"
ans_yes: .asciz "Y"
file_name:      .space	NAME_SIZE		# ������������ �����
answer:      .space	NAME_SIZE
strbuf:	.space TEXT_SIZE			# ����� ��� ��������� ������
.text
output_file: # a3 -- s9 
    
# ���������� ������������ ����� � ������ �����
    
    li		t1 -1			# �������� �� ���������� ��������
    beq		a0 t1 er_name	# ������ �������� �����
    mv   	t0 a0       	# ���������� ����������� �����
	# ������ ���������� � �������� ����
    li   a7, 64       		# ��������� ����� ��� ������ � ����
    mv   a0, t0 			# ���������� �����
    mv   a1, a2  			# ����� ������ ������������� ������
    mv   a2, a3   			# ������ ������������ ������ �� ��������
    ecall             		# ������ � ����
    ret
    
er_name:
    # ��������� �� ��������� ����� �����
    la		a0 er_name_mes
    li		a7 4
    ecall
    # � ���������� ���������
    li a0 -1
    ret
