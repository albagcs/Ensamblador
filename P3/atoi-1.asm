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
	
Loop:
	lb $t2,0($t0)
	beq $t2,10,exit
	mul $t1,$t1,10
	sub $t2,$t2,48
	add $t1,$t1,$t2
	addi $t0,$t0,1
	b Loop
	
exit:
	la $a0,result
	li $v0,4
	syscall
	
	move $a0,$t1
	li $v0,1
	syscall
	
	li $v0, 10
	syscall