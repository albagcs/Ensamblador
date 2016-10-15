	.data
mess_inicio: .asciiz "Introduce el numero de discos (1-8): "
move_disk: .asciiz "Mueve el disco: "
from_peg: .asciiz " from peg "
to_peg: .asciiz " to peg "
salto_linea: .asciiz "\n"
finalizado: .asciiz "Fin del programa."
	.text

main:

	la $a0, mess_inicio
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a0, $v0 # a0 va a guardar la n
	li $a1, 1
	li $a2, 2
	li $a3, 3
	jal hanoi

	la $a0, finalizado
	li $v0, 4
	syscall
	li $v0, 10
	syscall
hanoi:

	bnez $a0, hanoi_recurse
	li $v0, 0
	jr $ra

hanoi_recurse:

	#creamos la pila 
	subu $sp,$sp,32
	sw $ra,28($sp)
	sw $fp,24($sp)
	addu $fp, $sp,32
	sb $a0, 8($sp)
	sb $a1, 12($sp)
	sb $a2, 16($sp)
	sb $a3, 20($sp)
	move $t0, $a0
	sub $a0, $t0,1
	lb $a1, 12($sp)
	lb $a2, 20($sp)
	lb $a3, 16($sp)
 
	jal hanoi
	lb $t0, 8($sp)
	lb $t1, 12($sp)
	lb $t2, 16($sp)
	lb $t3, 20($sp)
	la $a0, move_disk
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1 
	syscall
	la $a0, from_peg
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	la $a0, to_peg
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, salto_linea
	li $v0, 4
	syscall
	lb $t0,8($sp)
	sub $t0, $t0,1
	move $a0, $t0
	lb $a1, 20($sp)
	lb $a2, 16($sp)
	lb $a3, 12($sp)
	jal hanoi
	lw $ra, 28($sp)
	lw $fp, 24($sp) 
	addu $sp, $sp, 32
	lb $a0, 8($sp)
	lb $a1, 12($sp)
	lb $a2, 16($sp)
	lb $a3, 20($sp) 
	jr $ra
