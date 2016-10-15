.data
	array: .word 2 4 8 6
	length: .word 4
	value: .word 8
	startpos: .word 1
	newline: .asciiz "\n"
	
.text

main:
	la $a0, array
	lw $a1, value
	lw $a2, startpos
	lw $a3, length
	mul $t1,$a2,4		# because we have to load the array value of the pos set
	add $a0,$a0,$t1		# because we have to load the array value of the pos set
	jal buscarDesde
	
	move $a0,$v0	# Move fact result in $a0
	li $v0, 1	# Load syscall print-int into $v0
	syscall
	
	li $v0,10
	syscall
	
buscarDesde:
	subu $sp,$sp,32
	sw $ra, 16($sp)
	sw $fp, 12($sp)
	addiu $fp,$sp,28
	sw $a2,0($fp)		# we keep the our start pos
	
	lw $v0, 0($fp)		# we catch the pos
	blt $v0,$a3, recbuscar
	li $v0,-1
	b return
	
recbuscar:
	lw $v1, 0($fp)		# actual search pos
	lw $t0,0($a0)		# in t0 we have the current adress (pos) of the array
	move $v0,$v1		# we keep the pos which match our value
	beq $t0, $a1, return	# if the value os the current pos match our searched value we finish
	addi $a0,$a0,4
	addi $a2,$a2,1		# we didnt found our value, we look for it in the next position of the array
	move $a2,$a2
	jal buscarDesde

return:
	lw $ra,16($sp)
	lw $fp,12($sp)
	addiu $sp,$sp,32
	jr $ra
