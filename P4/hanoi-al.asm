	.data
disks:	.asciiz "Introduce nº discos (1-8) : "
move_disk: .asciiz "Mueve el disco: "
from_peg: .asciiz " from peg "
to_peg: .asciiz " to peg "
newline:.asciiz "\n"
	.text
main:
	la $a0,disks
	li $v0,4
	syscall
	li $v0,5
	syscall
	move $a0,$v0	# number of disks, n
	# dipsticks
	li $a1,1	# start	
	li $a2,2	# finish
	li $a3,3	# extra
	jal Hanoi
	
	li $v0, 10
	syscall
	
Hanoi:
	bnez $a0, Recursion
	li $v0,0
	jr $ra
	
Recursion:
	subu $sp,$sp,32
	sw $ra,28($sp)
	sw $fp,24($sp)
	addu $fp,$sp,32
	sw $a0, 20($sp)		# store n
	sw $a1,16($sp)		# store start
	sw $a2,12($sp)		# store finish
	sw $a3,8($sp)		# store extra
	
	
	move $t0,$a0		# t0=a0
	sub $a0,$t0,1		# a0=t0-1; n-1
	lw $a1,16($sp)		# start
	lw $a2,8($sp)		# extra
	lw $a3,12($sp)		# finish
	# hano(n-1, start,extra,finish)
	jal Hanoi		
	
	# we are gonna use temporal registers t in order not to modify a registers
	lw $t0,20($sp)		# t0=a0= disk, n, its different, so we have to extract and substract one again
	lw $t1,16($sp)		# t1=a1=start dipstick
	lw $t2,12($sp)		# t2=a2= finish dipstick
	lw $t3,8($sp)		# t3=a3=extra dipstick
	# move disk
	la $a0,move_disk
	li $v0,4
	syscall
	move $a0,$t0
	li $v0,1		# disk n
	syscall
	# from peg (start)
	la $a0,from_peg
	li $v0,4
	syscall
	move $a0,$t1		# start
	li $v0,1
	syscall
	# to peg (finish)
	la $a0,to_peg
	li $v0,4
	syscall
	move $a0,$t2		# finish
	li $v0,1
	syscall
	# new line
	la $a0, newline
	li $v0,4
	syscall
	# now we have to call again hanoi; hanoi (n-1,start,finish,extra)
	lw $t0,20($sp)
	sub $t0,$t0,1
	move $a0,$t0		# n-1
	lw $a1,8($sp)		# extra
	lw $a2,12($sp)		# finish
	lw $a3,16($sp)		# start
	jal Hanoi
	lw $ra,28($sp)
	lw $fp,24($sp)
	addu $sp,$sp,32
	jr $ra
	
	
	
	
