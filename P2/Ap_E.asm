
# ************ Declaracion de variables ***********************

# Space reserva espacio como puede hacerlo word o half...pero no respeta el alineamiento, por lo que si nos
# declaramos space 4 y space dos, estamos reservando 6 bytes, sin embargo no sabemos dónde o cómo están

# ***DUDA --> NO SÉ CÓMO DECLARAR CON SPACE Y LUEGO REEMPLAZAR AL LEER DEL TERMINAL******** 

.data
	# Mensajes
	num1: .space 2
	num2: .space 4	
	men1: .asciiz "Ingrese num1: "
	men2: .asciiz "Ingrese num2: "
	
	# Elementos de despliegue
	resultado: .asciiz "El resultado es "

# ************************ Codigo del programa ********************************
.text
main:
	
	
	## ----------------- Despliegue y solicitud de los datos -----------------

	## Despliegue del primer mensaje
	la $a0, men1 		
	li $v0, 4 			# 4 es la llamada para imprimir una cadena de caracteres.
	syscall 			# Se hace la llamada.

	## Ingreso del primer numero
	la $s0, num1
	li $v0, 5 		
	syscall 		
	move $s0, $v0 		# Esta es una pseudo instruccion (que es esto?)--> guarda el valor del entero en el registro $t0
	sw $s0, num1
	
	## Despliegue del segundo mensaje
	la $a0, men2 	
	li $v0, 4 		
	syscall 	

	## Ingreso del segundo numero
	la $s1, num2
	li $v0, 5 		
	syscall 		
	move $s1, $v0 
	sw $s1, num2		# Esta es una pseudo instruccion (que es esto?)	--> arriba ^
	
	#la $s0, num1	# al usar space es la (lógico, pues no hemos dicho que sea una palabra...)
	#la $s1, num2
	
	## ------------- Operaciones sobre los registros que contienen los datos ------------- 
	
	add $s2,$s1,$s0		# $t2 = $t1 + $t0
	
	## ------------- Despliegue de los resultados ------------- 
	
	##APARTADO C
	 
	## Despliegue del mensaje resultado 
	la $a0, resultado	
	li $v0, 4 		
	syscall 
	
	## Despliegue del resultado 
	move $a0, $s2		
	li $v0, 1 		
	syscall 
	
	## Llamada del sistema para finalizar la ejecucion del programa.
	li $v0, 10 		# 10 es la llamda exit.
	syscall 		# Se hace la llamada.
