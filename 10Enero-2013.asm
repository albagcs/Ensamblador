	.data
first_str: .space 1024
second_str: .space 1024
message: .asciiz "Enter the maxinum number of characters: "
result_1: .asciiz "Your str origen is: "
result_2: .asciiz "Your str destino is: "
new_result_2: .asciiz "Your new str destino is: "
length: .asciiz "Your str's length is: " 
newline:  .asciiz "\n"

	.text

main:
	la $a0, message
	li $v0,4
	syscall
	# parameters for read_string: maxchar & address
	li $v0,5
	syscall
	move $a1, $v0		# a1 contains the maximun number of characters for str1
	
	la $a0, first_str
	jal read_string
	# we print str1
	la $a0,newline
	li $v0,4
	syscall
	la $a0, result_1
	li $v0,4
	syscall
	la $a0,first_str
	li $v0,4
	syscall
	la $a0,newline
	li $v0,4
	syscall
	
	la $a0, message
	li $v0,4
	syscall
	# parameters for read_string: maxchar & address
	li $v0,5
	syscall
	move $a1, $v0		# now a1 contains the maximun number of characters for str2
			
	la $a0, second_str
	jal read_string
	# we print str2
	la $a0,newline
	li $v0,4
	syscall
	la $a0, result_2
	li $v0,4
	syscall
	la $a0,second_str
	li $v0,4
	syscall
	la $a0,newline
	li $v0,4
	syscall
	
	la $a0, first_str
	la $a1, second_str
	jal strcopy
	# we print str2 again, after copy str1 on it
	la $a0,newline
	li $v0,4
	syscall
	la $a0, new_result_2
	li $v0,4
	syscall
	la $a0,second_str
	li $v0,4
	syscall
	la $a0,newline
	li $v0,4
	syscall
	
	# strlen
	la $a0, first_str
	jal strlen
	
	# print length
	move $t0,$v0
	
	la $a0,newline
	li $v0,4
	syscall
	la $a0, length
	li $v0,4
	syscall
	
	#sub $v0,$v0,1
	move $a0,$t0
	li $v0,1
	syscall
	
	li $v0,10
	syscall
	
read_string:
	li $v0, 8
	syscall
	b return
	
strcopy:
	lb $t0, 0($a0)		# first character of str1
	beq $t0,0, return	# it is 0 instead of 10 because this time we dont use enter(\n), we finish with length
	sb $t0, 0($a1)		# we put t0 in place of dest bytes
	addi $a0,$a0,1
	addi $a1,$a1,1
	b strcopy
	
strlen:
	lb $t0,0($a0)
	beq $t0,0,return
	addi $t1,$t1,1		# length's counter
	move $v0,$t1		# subroutine have to give back a value in v0	
	addi $a0,$a0,1
	b strlen
	
return:
	jr $ra