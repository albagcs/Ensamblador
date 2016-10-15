.data
	str: .space 1024
	text: .asciiz "Enter your text: "
	result: .asciiz "The equivalent to your text is "
	
.text
	la $a0, text
	li $v0, 4
	syscall
	
	la $a0, str
	la $a1, 1024
	li $v0, 8
	syscall
	
	la $t0, str		# start pointer
	addi $t1,$zero,0	# num
	addi $t2,$zero,0	# next char - 48
	addi $t3,$zero, 0
Loop:
	lb $t2,0($t0)
	beq $t2,45, negative
	blt $t2, 48, exit	# implementing UNIX library atoi
	bgt $t2, 57, exit	# implementing UNIX library atoi
	beq $t2,10,exit
	mul $t1,$t1,10
	mfhi $t4
	bnez $t4, overflow
	mflo $t5
	bltz $t5, overflow
	sub $t2,$t2,48
	add $t1,$t1,$t2
	bltz $t1, overflow
	addi $t0,$t0,1
	b Loop
	
negative:
	addi $t0,$t0,1
	addi $t3,$t3,1
	b Loop
	
sign:
	mul $t1,$t1, -1
	mul $t3,$t3,0
	b exit
	
overflow:
	mul $t1,$t1,0
	b exit
exit:
	beq $t3, 1, sign
	la $a0,result
	li $v0,4
	syscall
		
	move $a0,$t1
	li $v0,1
	syscall
	
	li $v0, 10
	syscall