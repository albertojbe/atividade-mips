.data
	menu: .asciiz "\n1. Farenheit -> Celsius \n2. Fibonacci\n3. Enesimo par\n4. Sair\n\nDigite a opcao: "
	farenheit_menu: .asciiz "\nDigite a temperatura em farenheit: "
	resultado: .asciiz "Resultado: "
	pula_linha: .asciiz "\n"
	
	
.text
main:
	
	li $v0, 4 # Chamando função para imprimir string
	la $a0, menu # Imprimindo o menu
	syscall
	
	li $v0, 5 # Chamando função para ler inteiro
	syscall
	move $t0, $v0 # Movendo o inteiro lido para o resgistrador $t0
	
	beq $t0, 1, farenheit # Se $t0 for igual a 1, então pula para a função farenheit
	beq $t0, 4, sair # Se $t0 for igual a 5, então pula para função sair, fechando o programa
	
	j main
	
	
farenheit:
	li $v0, 4
	la $a0, farenheit_menu # Imprimindo o menu da função farenheit
	syscall
	
	
	li $v0, 6 # Lendo a temperatura em float que ficará salva no registrador $f0
	syscall
	mov.s $f1, $f0

	
	# Armazenando os valores como inteiros e transferindo para os registradores de numeros flutuantes
	
	li $t0, 32 # Inicializando valor inteiro no registrador $t0
	mtc1 $t0, $f3 # Passando o valor do registrador $t0 para o registrador $f3 no Coproc 1
	cvt.s.w $f3, $f3 # Convertendo de inteiro para float
	
	li $t0, 9
	mtc1 $t0, $f4 
	cvt.s.w $f4, $f4 
	
	li $t0, 5
	mtc1 $t0, $f5
	cvt.s.w $f5, $f5
	
	# Realizando as operações para Conversão
	
	div.s $f6, $f4, $f5 # Dividindo $f4 por $f5 em armazenando em $f6 - (9 / 5 = 1.8)
	sub.s $f2, $f1, $f3 # Subtraindo a temperatura em farenheit($f1) que foi lida por 32($f3) e armazenando em $f2 (F - 32)
	div.s $f7, $f2, $f6 # Dividindo $f2 por $f6, que será o resultado final, e armazenando em $f7 [(F - 32) / 1.8]
	
	# Imprimindo o texto resultado antes do valor
	li $v0, 4 
	la $a0, resultado 
	syscall 
	
	# Imprimindo o resultado final
	li $v0, 2
	mov.s $f12, $f7 # Movendo o resultado de %f7 para $f12 (registrador para imprimir float ou double)
	syscall 
	
	# Imprimindo String para pular uma linha
	li $v0, 4
	la $a0, pula_linha
	syscall
	
	j main # Pula de volta para a função main

sair:
	li $v0, 10
	syscall
