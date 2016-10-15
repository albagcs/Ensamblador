.data
	str: .space 1024
	text: .asciiz "Please, enter your text: "
	trueP: .asciiz "It's a palindrome"
	falseP: .asciiz "Ain't a palindrome"
	
.text
	la $a0, text
	li $v0, 4
	syscall
	
	# read text
	la $a0, str
	la $a1,1024
	li $v0,8
	syscall
	
	la $t0, str	# start pointer
	la $t1, str	# end pointer
	addi $t3,$zero,0
	
Loop:	# We set t1 to the end
	beq $t3,10, compare
	addi $t1,$t1,1
	lb $t3,0($t1)
	b Loop
	
compare:
	mul $t3, $t3, $zero	# we reuse this register
	sub $t1,$t1,1		# because before we let it in \n
	lb $t3, 0($t0)		# t3 & t4 to compare
	lb $t4, 0($t1)
	bne $t3, $t4, fp
	beq $t3,$t4, continue
	
continue:
	addi $t0,$t0,1
	sub $t1,$t1,1
	bge $t0, $t1, tp
	lb $t3, 0($t0)
	lb $t4,0($t1)
	beq $t3,$t4, continue
	bne $t3,$t4, fp
	
	

fp:
	la $a0,falseP
	li $v0,4
	syscall
	b exit
	
tp:
	la $a0,trueP
	li $v0,4
	syscall
	b exit
	
exit:
	li $v0,10
	syscall
	