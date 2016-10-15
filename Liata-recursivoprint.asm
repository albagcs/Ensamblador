		.data
newline:	.asciiz "\n"
no_memory:	.asciiz "There's no memory"
str_number:	.asciiz "Insert a value: "

		.text
main:
		# primer valor a insertar con create
		la $a0, str_number 
		li $v0,4
		syscall
		li $v0,5
		syscall
		move $a0,$v0		# valor que meteremos
		li $a1,0
		jal node_create
		# tras insertar el primer nodo, s0 y s1 apuntan a v0
		move $s0,$v0		# SO NO VA A VARIAR MÁS
		move $s1,$v0
		
		loop:
		# pedimos números hasta tener un 0
		li $v0,5
		syscall
		beqz $v0, end_loop
		move $a0,$v0		# a0 tenemos valor a añadir
		move $a1, $s1		# a1 tenemos la dirección último nodo que metimos
		jal insert
		
		move $s1,$v0		# actualizamos s1 al último valor añadido
		b loop
end_loop:
		move $a0,$s0
		jal print
		li $v0,10
		syscall
		
node_create:
		move $t0,$a0		# salvamos valor introducido
		# reservamos memoria
		li $a0,8		# vamos a reservar 8 bytes, 4 valor,4puntero al siguiente
		li $v0,9
		syscall
		move $t1,$v0		# dirección del nodo creado
		beqz $t1,memory_out	# no tenemos memoria
		
		sw $t0,0($t1)		# guardo el valor en 0(v0)
		sw $a1,4($v0)		# cima apunta a null
		
		jr $ra
		
insert:
		subu $sp,$sp,32
		sw $ra, 16($sp)
		sw $fp,12($sp)
		addu $fp,$sp,28
		sw $a0, 0($fp)		# salvo el valor que tengo añadir
		sw $a1,-4($fp)		# salvo la puntero al último nodo
		
		lw $a0,0($fp)		# valor que create añadirá, luego aquí,concatenamos
		li $a1,0		# create siempre me deja nueva cajita y puntero a 0
		jal node_create
		
		# me devuelve la cajita, con el valor y el null al siguiente
		# yo concateno
		
		lw $a1,-4($fp)
		sw $v0,4($s1)
		
		# liberar pila
		lw $ra,16($sp)
		lw $fp,12($sp)
		addu $sp,$sp,32
		jr $ra
		
print:
		lw $t0,4($a0)
		bnez $t0, recursive_print
		lw $a0,0($a0)
		li $v0,1
		syscall 
		li $v0,0
		jr $ra
		
recursive_print:
		subu $sp,$sp,32
		sw $ra,16($sp)
		sw $fp,12($sp)
		addu $fp,$sp,28
		sw $a0,0($fp)			# luego sacaremos valores e imprimimos
		
		lw $a0,4($a0)
		
		jal print		
		
		lw $t0,0($fp)
		lw $t1,0($t0)
		move $a0,$t1
		li $v0,1
		syscall
		
		lw $ra,16($sp)
		lw $fp,12($sp)
		addu $sp,$sp,32
		jr $ra
return:
		jr $ra
		
memory_out:
		la $a0,no_memory
		li $v0,4
		syscall
		
