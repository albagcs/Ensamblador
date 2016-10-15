# i = 1; j = 0
# K de 0 a n-1:
#	t = i + j
#	j = i
#	i = t
# return j

.data
	str: .asciiz "Enter n, I'll give you F(n): "
	
.text

	addi $t0,$zero,1 # i
	addi $t1,$zero,0 # j
	addi $t2,$zero,0 # t
	addi $t3,$zero,0 # counter (k)
	
main:
	# read n
	la $a0, str
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $a0, $v0
	jal Fibonacci
	
	move $a0,$v0
	li $v0,1
	syscall
	
	li $v0,10
	syscall
	
Fibonacci:
	blt $a0,2,return	# a0 is n
	sub $t4, $a0,1		# t4 = n-1
	add $t2, $t0,$t1	# t = i+ j
	beq $t3,$t4, exit	# si k = n-1
	move $t1,$t0		# j = i
	move $t0,$t2		# i = t
	addi $t3,$t3,1		# k = k+1
	b Fibonacci
	
	
return:
	li $v0,1
	jr $ra
	
exit:
	move $v0,$t2
	jr $ra
	
