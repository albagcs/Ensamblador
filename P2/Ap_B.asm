		.data
str:   	.asciiz "\tHello World!\n"
		.text
main:	la $a0, str
		li $v0, 4
		syscall
		li $v0, 10
		syscall
		
#8 bits (1byte) en hexadecimal se traduce como 2 dígitos. Para interpretar el código, cogemos cada dos dígitos en data
# segment y en la tabla ascii vemos la equivalencia.
