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
	sw $ra,16($sp)
	sw $fp,12($sp)
	addu $fp,$sp,28
	sw $a0, 0($fp)		# store n
	sw $a1,-4($fp)		# store start
	sw $a2,-8($fp)		# store finish
	sw $a3,-12($fp)		# store extra
	
	
	move $t0,$a0		# t0=a0
	sub $a0,$t0,1		# a0=t0-1; n-1
	lw $a1,-4($fp)		# start
	lw $a2,-12($fp)		# extra
	lw $a3,-8($fp)		# finish
	# hano(n-1, start,extra,finish)
	jal Hanoi		
	
	# we are gonna use temporal registers t in order not to modify a registers
	lw $t0,0($fp)		# t0=a0= disk, n, its different, so we have to extract and substract one again
	lw $t1,-4($fp)		# t1=a1=start dipstick
	lw $t2,-8($fp)		# t2=a2= finish dipstick
	lw $t3,-12($fp)		# t3=a3=extra dipstick
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
	lw $t0,0($fp)
	sub $t0,$t0,1
	move $a0,$t0		# n-1
	lw $a1,-12($fp)		# extra
	lw $a2,-8($fp)		# finish
	lw $a3,-4($fp)		# start
	jal Hanoi
	lw $ra,16($sp)
	lw $fp,12($sp)
	addu $sp,$sp,32
	jr $ra
	