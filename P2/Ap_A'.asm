.data
	num1: .asciiz "Número 1: "
	num2: .asciiz "Número 2: "
	signo_sum: .asciiz "+"
	igual: .asciiz "="
	newline: .asciiz "/n"
	
.text
	main:
		la $a0, num1
		li $v0, 4
		syscall
		
		# Ingresamos nuestro número
		li $v0,5
		syscall
		move $t0,$v0
		
		la $a0, num2
		li $v0, 4
		syscall
		
		#Ingresamos número 2
		li $v0, 5
		syscall
		move $t1,$v0
		
		add $t2,$t1,$t0
		
		#Despliegue resultado
		move $a0,$t0
		li $v0,1
		syscall
		
		la $a0, signo_sum
		li $v0, 4
		syscall
		
		move $a0,$t1
		li $v0,1
		syscall
		
		la $a0, igual
		li $v0, 4
		syscall
		
		move $a0,$t2
		li $v0, 1
		syscall
		
		li $v0, 10 		# 10 es la llamda exit.
		syscall 
		