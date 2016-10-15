		.data
newline:	.asciiz "\n"
		.text
	
# In main, we have to make push N times, till we write a 0. Then we should
# eliminate a node whose value is 'X' and show us the value of the deleted node.
# Finally we have to print the stack left. $s0 is used to point to the stack's peak, and
# his value must be kept updated every time.	
main:
	addi $s0,$zero,0
	move $a0,$s0
	# we write a value till that's 0
	li $v0,5
	syscall
	move $a1,$v0
	jal push
	
	move $s0,$v0		# v0 gives us the new peak
	
	li $v0,10
	syscall
	
push:
	beq $a0,0, create	# a0 contains s0
	subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	addu $fp, $sp, 28
	sw $s0, -4($fp)
	sw $s1, -8($fp)
	
create:
	# we reserve memory with sbrk --> how many bytes do I need?
	# sbrk devuelve (en $v0) la direccion donde me ha reservado los bytes
	li $a0, 30
	li $v0, 9
	syscall
	move $s0,$v0		# now a0 contains the address of the created node
	beqz $s0, no_memory
	sw $a1,0($s0)		# we store the value in the first memory'possition 
	b return
	
return:
	jr $ra	
	
no_memory:
	la $a0, no_memory
	li $v0, 4
	syscall
	
