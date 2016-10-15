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
	addi $t2,$zero,0
	
Loop:	# We set t1 to the end
	beq $t2,10, compare
	addi $t1,$t1,1
	lb $t2,0($t1)
	b Loop
		
compare:
	sub $t1,$t1,1
	bge $t0, $t1, tp
	lb $t3, 0($t0)
	lb $t4,0($t1)
	blt $t3,47, gofwd	# if we have any punctuation sign (spacem., ...)
	blt $t4,47, gobwd	# if we have any punctuation sign (spacem., ...)
	ble $t3, 90, capital1	# if the first pointer point to a capital
	ble $t4, 90, capital2	# if the last pointer point to a capital. A bit tricky 'cause of less than 90 after less than 47
	addi $t0,$t0,1
	beq $t3,$t4, compare
	bne $t3,$t4, fp

capital1:
	addi $t3,$t3,32		# we transform capital into lower case
	b compareC
capital2:
	addi $t4,$t4,32		# we transform capital into lower case
	b compareC
	
compareC:
	addi $t0,$t0,1		# because if we are comparing in compare, we need to go forward with the first pointer
	beq $t3,$t4, compare
	bne $t3,$t4,fp
	
gofwd:
	addi $t0,$t0,1		# we have to go forward with the first pointer, but stay equal with the second...
	addi $t1,$t1,1		# ...in compare we subtract, so second pointer stays the same
	b compare
	
gobwd:
	b compare		# if we come back to compare, we skip a 'step' and stay ok with memory's adresses

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
	