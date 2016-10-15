# main--
## Registers used:
##	$a0 -- syscall parameter -- the number to print
#	$v0 -- syscall parameter and return value

.data
	fib: .asciiz "Give me a number here, then I'll show you its fibonacci value: "
.text

main:
	la $a0, fib
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $a0, $v0	# subroutine agreement
	jal Fibonacci
	
	move $a0,$v0	# Move fact result in $a0
	li $v0, 1	# Load syscall print-int into $v0
	syscall
	
	li $v0,10	# we've finished
	syscall
	
Fibonacci:
	# We create the stack
	subu $sp,$sp,32		#Stack frame is 32 bytes long
	sw $ra, 16($sp)		#Save return address
	sw $fp, 12($sp)		#Save frame pointer
	addiu $fp,$sp,28	#Set up frame pointer
	sw $a0,0($fp)		#Save argument (n)
	
	# we check if we need recursion
	lw $v0, 0($fp)
	bgt $v0,1,recursive_fib
	li $v0,1
	b return

recursive_fib:
	lw $v1, 0($fp)		# Load n
	subu $t0,$v1,1		# n -1 = t0
	move $a0,$t0		# in order to compute f(n-1)
	jal Fibonacci
	
	sw $v0, -4($fp)		# keep fibo (n-1) value
	
	lw $v1,0($fp)
	subu $t1,$v1,2
	move $a0,$t1
	jal Fibonacci
	
	lw $s0,-4($fp)		# Load n (?) **
	
	add $v0,$s0,$v0		# Compute f(n-1) + f(n-2)
	
	
	
return:
	lw $ra, 16($sp)
	lw $fp, 12($sp)
	addiu $sp,$sp,32
	jr $ra