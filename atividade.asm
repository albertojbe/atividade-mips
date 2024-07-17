.data
	menu: .asciiz "1. Farenheit -> Celsius \n2. Fibonacci\n3. Enesimo par\n4. Sair\n\nDigite a opcao: "
	farenheit_menu: .asciiz "\nDigite a temperatura em farenheit: "
	
	
.text
main:
	loop:
		li $v0, 4
		la $a0, menu
		syscall
	
		li $v0, 5
		syscall
	
	
		move $t1, $v0
	
		beq $t1, 1, farenheit 
	
		li $v0, 1
		move $a0, $t1
		syscall
		
		j loop
	
	
farenheit:
	li $v0, 4
	la $a0, farenheit_menu
	syscall