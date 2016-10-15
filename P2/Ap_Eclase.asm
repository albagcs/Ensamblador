#con .space se reserva el espacio que quiero, pero aleatoriamente, sin tener en cuenta el alineamiento

.data
	# Mensajes
	num1: .half 2
	num2: .word 4	
	mensaje1: .asciiz "El resultado es: "
	

# ********************* Codigo del programa ***********************
.text
main:
	
	## ------------- Despliegue y solicitud de los datos ------------- 
	
	lh $s0,num1		# $s1 se asocia a la variable i
	lw $s1,num2		# $s2 esta asociada a la variable suma
	add $s2,$s1,$s0
	
	## Despliegue del mensaje resultado 
	la $a0, mensaje1	
	li $v0, 4 		
	syscall 
	
	## Despliegue del resultado 
	move $a0, $s2		
	li $v0, 1 		
	syscall 
	## exit the program.
	li $v0, 10 		# 10 is the exit syscall.
	syscall 		# do the syscall.
