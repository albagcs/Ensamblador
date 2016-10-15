# Autor -- 25/03/2011
# ejemplo1.asm-- Este programa muestra la suma de dos numeros de 4 bytes solicitado por teclado
# Registers used:
# $v0 - Parametro y valor de retorno de una llamada al sistema (syscall).
# $a0 - Parametro de llamada al sistema.

## PREGUNTAS. ¿QUÉ DIFERENCIA HAY ENTRE OVERFLOW Y SIN? COMO EN ADD Y ADDU

# ************************ Declaracion de variables ***************************

.data
	# Mensajes
	num1: .asciiz "Ingrese num1: "
	num2: .asciiz "Ingrese num2: "
	
	# Elementos de despliegue
	s_suma: .asciiz " + "
	s_igual: .asciiz " = "
	n_linea: .asciiz "\n"
	resultado: .asciiz "El resultado es "

# ************************ Codigo del programa ********************************
.text
main:
	
	## ----------------- Despliegue y solicitud de los datos -----------------

	## Despliegue del primer mensaje
	la $a0, num1 		# Carga la direccion de s_suma en $a0.
	li $v0, 4 			# 4 es la llamada para imprimir una cadena de caracteres.
	syscall 			# Se hace la llamada.

	## Ingreso del primer numero
	li $v0, 5 		
	syscall 		
	move $t0, $v0 		# Esta es una pseudo instruccion (que es esto?)--> guarda el valor del entero en el registro $t0

	## Despliegue del segundo mensaje
	la $a0, num2 	
	li $v0, 4 		
	syscall 	

	## Ingreso del segundo numero
	li $v0, 5 		
	syscall 		
	move $t1, $v0 		# Esta es una pseudo instruccion (que es esto?)	--> arriba ^

	## ------------- Operaciones sobre los registros que contienen los datos ------------- 
	
	add $t2,$t1,$t0		# $t2 = $t1 + $t0
	
	## ------------- Despliegue de los resultados ------------- 
	
	## Despliegue del primer entero ingresado
	move $a0, $t0 		
	li $v0, 1 		
	syscall 	
	
	## Despliegue del signo + 
	la $a0, s_suma 		
	li $v0, 4 		
	syscall 			
	
	## Despliegue de un numero entero 
	move $a0, $t1 		
	li $v0, 1 		
	syscall 

	## Despliegue del signo = 
	la $a0, s_igual 		
	li $v0, 4 			
	syscall 				

	## Despliegue del resultado 
	move $a0, $t2		
	li $v0, 1 		
	syscall 
	
	##APARTADO C
	## Despliegue de línea
	la $a0, n_linea	
	li $v0, 4 		
	syscall 
	## Despliegue del mensaje resultado 
	la $a0, resultado	
	li $v0, 4 		
	syscall 
	
	## Despliegue del signo = 
	la $a0, s_igual 		
	li $v0, 4 			
	syscall 
	## Despliegue del resultado 
	move $a0, $t2		
	li $v0, 1 		
	syscall 
	
	## Llamada del sistema para finalizar la ejecucion del programa.
	li $v0, 10 		# 10 es la llamda exit.
	syscall 		# Se hace la llamada.
