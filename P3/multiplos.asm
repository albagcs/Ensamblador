.data
	A: .asciiz "Insert number A: "
	B: .asciiz "Insert number B:"
	messageA: .asciiz "múltiplos"
	newline: .asciiz "\n"
	
.text
	la $a0, A
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t0,$v0 # t0 contains A
	
	la $a0, B
	li $v0,4
	syscall
	li $v0,5
	syscall
	move $t1,$v0 # t1 contains B
	
	beqz $t1, exit
	
	mul $t2, $t0, $t1 	# t3 contains AxB
	addi $t3,$zero,1   	# index: 1,2,3...
	addi $t4,$zero,0	# "Counter": AxIndex --> multiple
	
Loop:
	bge $t4, $t2, exit # When t3 >= AxB
	mul $t4,$t3,$t0
	# We show the multiple
	move $a0,$t4
	li $v0,1
	syscall
	# new line
	la $a0, newline
	li $v0,4
	syscall
	addi $t3,$t3,1
	j Loop
	
exit:
	li $v0,10
	syscall
	