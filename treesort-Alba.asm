.data
	newline: .asciiz "\n"
	no_memory_mssg: .asciiz "No hay memoria para reservar"
	nodo: .asciiz "Imprimo un nodo (nodo raiz: centro; arbol izquierdo: arriba; arbol derecho: abajo): "
.text

main:
	li $s2,0	# s2=0, the sentinel value
	# 1.Create the root node. root = tree_node_create(s2,0,0)
	move $a0,$s2	# val = $s2
	li $a1,0	# left = null
	li $a2,0 	# right = null
	jal tree_node_create	# the call
	move $s0,$v0	# put the result into $s0
	
	# 2.Read nimbers from the user and add them to the three, until
	#  the value is 0 (until we see the sentinel value). Register s1
	# holds the number read
	
Loop:
	li $v0,5	# read int
	syscall
	move $s1,$v0
	
	beq $s1,$s2, end	# break when we read the sentinel
	
	move $a0,$s1		# number=s1
	move $a1, $s0		# root = s0
	jal tree_node_insert
	
	b Loop
	
end:
	# 3. Print the left & right subtrees
	lw $a0, 4($s0)		# left child
	jal tree_print
	
	lw $a0,8($s0)		# right child
	jal tree_print
	
	b exit
## end of main

## tree_node_create (val, left,right): make a new node with the given value and
## left & right descendants
## s0=val, s1=left, s2=right
tree_node_create:
	# set up the stack pointer
	subu $sp,$sp,32
	sw $ra,28($sp)
	sw $fp,24($sp)
	sw $s0,20($sp)
	sw $s1,16($sp)
	sw $s2,12($sp)
	sw $s3,8($sp)
	addu $fp,$sp,32
	# grab the parameters
	move $a0,$s0		# so=val
	move $a1,$s1		# s1=left
	move $a2,$s2		# s2=right
	
	li $a0,12	# we need 12 bytes for the new node (4*3)
	li $v0,9	# sbrk syscall
	syscall
	
	move $s3,$v0
	beqz $s3, no_memory
	
	sw $s0,0($s3)		# number=number
	sw $s1,4($s3)		# left=left
	sw $s2,8($s3)		# right=right
	
	move $v0,$s3		# put return value in $v0
	
	# release the stack frame
	lw $ra, 28($sp)
	lw $fp,24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2,12($sp)
	lw $s3,8($sp)
	addu $sp,$sp,32
	jr $ra
## end of tree_node_create

## tree_insert (val,root): make a new node with the given value
## s0=val, s1=root, s2=new node,s3=root->val(root_val),s4=scratch pointer(ptr)
tree_node_insert:
	# set up the stack pointer
	subu $sp,$sp,32
	sw $ra,28($sp)
	sw $fp,24($sp)
	sw $s0,20($sp)
	sw $s1,16($sp)
	sw $s2,12($sp)
	sw $s3,8($sp)
	sw $s3,4($sp)		# ¿? s3 again ?
	addu $fp,$sp,32
	# grab the parameters
	move $s0,$a0		# s0=val
	move $s1,$a1		# s1=root
	#make a new_node:
	# new node= tree_node_create(val,0,0);
	move $a0,$s0		# val=s0
	li $a1,0		# left=0
	li $a2,0		# right=0
	jal tree_node_create
	move $s2,$v0
## now we have to search the correct value to put the node
search_loop:
	lw $s3,0($s1)		# root val =root-val
	ble $s0,$s3,go_left
	b go_right
go_left:
	lw $s4,4($s1)		# ptr=root-left
	beqz $s4, add_left	# if ptr=0
	move $s1,$s4
	b search_loop
add_left:
	sw $s2,4($s1)
	b end_search_loop
go_right:
	lw $s4,8($s1)		# ptr=root-right
	beqz $s4,add_right
	move $s1,$s4
	b search_loop
add_right:
	sw $s2,8($s1)
	b end_search_loop

end_search_loop:
	# release the stack frame
	lw $ra, 28($sp)
	lw $fp,24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2,12($sp)
	lw $s3,8($sp)
	lw $s4,4($sp)
	addu $sp,$sp,32
	jr $ra	
## end of node_create

## tree_walk_tree
# do an inorder transversal of the tree, printing out each value
tree_print:
	subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	addu $fp, $sp, 32
	
	move $s0, $a0
	beqz $s0, tree_print_end
	#Imprimo el nodo izquierdo
	lw $a0, 4($s0)
	jal tree_print
	#imprimo el valor que me devuelven en cada linea
	lw $a0, 0($s0)
	li $v0, 1
	syscall
	la $a0, newline
	li $v0, 4
	syscall
	#Imprimo el nodo derecho
	lw $a0, 8($s0)
	jal tree_print
	
tree_print_end:
	# clean up and return
	lw $ra,28($sp)
	lw $fp,24($sp)
	lw $s0,20($sp)
	addu $sp,$sp,32
	jr $ra
## end of tree_print

no_memory:
	la $a0, no_memory_mssg
	li $v0,4
	syscall
	b exit

exit:
	li $v0,10
	syscall
