.data
	# First we state string issues
	str: .asciiz "Introduce valores del array "
	startpos: .asciiz "Enter the pos from which you wanna start searching: "
	result: .asciiz "Your value is in pos: "
	newline: .asciiz "\n"
	# Then, we state number issues
	array: .word 0:4
	length: .word 4
	value: .word 3	
.text

main:
	# we prepare for inicializar
	la $a0,str
	li $v0,4
	syscall
	la $a0,newline
	li $v0, 4
	syscall
	la $a0,array		# parameter for inicializar
	addi $t0,$zero,0	# stop condition parameter for inicializar
	jal inicializar		
	# We decide our startpos
	la $a0,startpos
	li $v0,4
	syscall
	li $v0,5
	syscall
	# we prepare for buscarDesde
	la $a0, array		# address
	lw $a1, value		# value we are looking for
	move $a2,$v0		# start search pos
	lw $a3, length		# array's length
	mul $t1,$a2,4		# because we have to load the array's value of the pos set
	add $a0,$a0,$t1		# because we have to load the array's value of the pos set
	jal buscarDesde
	
	move $t0,$v0		# until we print message
	la $a0,result
	li $v0, 4
	syscall
	
	move $a0,$t0	# Move our pos result in $a0
	li $v0, 1	# Load syscall print-int into $v0
	syscall
	
	
	# prepare for switch
	la $a1, array	# we need the array's adress
	add $a2,$a0,1	# a0 contains pos,a2 pos+1
	jal intercambiar

	la $a1, array
	mul $t3,$t3,0	# counter
	jal imprimir

	li $v0,10
	syscall
	
inicializar:
		
	# we insert values
	li $v0,5
	syscall
	sw $v0, array($t0)
	addi $t0,$t0,4
	bgt $t0,12,comeback	
	b inicializar
	
comeback:
	jr $ra
	
	
buscarDesde:
	subu $sp,$sp,32
	sw $ra, 16($sp)
	sw $fp, 12($sp)
	addiu $fp,$sp,28
	sw $a2,0($fp)		# we keep the our start pos
	
	lw $v0, 0($fp)		# we catch the pos
	blt $v0,$a3, recbuscar
	li $v0,-1
	b return		# because we have to eliminate all the stacks from this ra
	
recbuscar:
	lw $v1, 0($fp)		# actual search pos
	lw $t0,0($a0)		# in t0 we have the current adress (pos) of the array
	move $v0,$v1		# we keep the pos which match our value
	beq $t0, $a1, return	# if the value os the current pos match our searched value we finish
	addi $a0,$a0,4
	addi $a2,$a2,1		# we didnt found our value, we look for it in the next position of the array
	move $a2,$a2
	jal buscarDesde
	b return

# should intercambiar be recursive too?	
intercambiar:
	subu $sp,$sp,32
	sw $ra, 16($sp)
	sw $fp, 12($sp)
	addiu $fp,$sp,28
	sw $a0,0($fp)	#pos
	sw $a2, -4($fp)	#pos+1
	
	# if we didnt find our value, we dont have to switch
	beq $a0,-1, return
	
	lw $v0,0($fp)	# we obtain pos
	lw $v1,-4($fp)	# we obtain pos+1
	beq $v1,$a3, return
	
	mul $t0,$v0,4		# because we have to load the array value of the pos set
	add $a1,$a1,$t0		# because we have to load the array value of the pos set
	lw $t1,0($a1)		# we have the value of pos
	lw $t2,4($a1)		# we have the value of pos+1
	sw $t2, 0($a1)		# we put value of pos in pos+1
	sw $t1, 4($a1)		# we put value of pos+1 in pos
	b return
	

# I believe imprimir should't be recursive, ask it	
imprimir:
	subu $sp,$sp,32
	sw $ra, 16($sp)
	sw $fp, 12($sp)
	addiu $fp,$sp,28
	sw $a1,0($fp)	# adress
	
	#newline
	la $a0,newline
	li $v0,4
	syscall
	bge $t3,$a3,return
	lw $t0,0($a1)
	# print value
	move $a0,$t0
	li $v0,1
	syscall
	
	addi $t3,$t3,1
	addi $a1,$a1,4
	jal imprimir

return:
	lw $ra,16($sp)
	lw $fp,12($sp)
	addiu $sp,$sp,32
	jr $ra
