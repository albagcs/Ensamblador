.data
	A: .asciiz "Insert number A: "
	B: .asciiz "Insert number B:"
	messageA: .asciiz "The biggest is A "
	messageB: .asciiz "The biggest is B"
	
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
	
	bgt $t0,$t1, Abigger # This is true when A > B
	
Bbigger:
	la $a0, messageB
	li $v0, 4
	syscall
	li $v0,10
	syscall

Abigger:
	la $a0, messageA
	li $v0, 4
	syscall
	li $v0,10
	syscall