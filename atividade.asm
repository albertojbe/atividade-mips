.data
	menu: .asciiz "\n1. Farenheit -> Celsius \n2. Fibonacci\n3. Enesimo par\n4. Sair\n\nDigite a opcao: "
	farenheit_menu: .asciiz "\nDigite a temperatura em farenheit: "
	fibonacci_menu: .asciiz "\nDigite o valor de N (sendo N > 0): "
	par_menu: .asciiz "\nDigite um numero para saber seu enesimo par: "
	resultado: .asciiz "Resultado: "
	pula_linha: .asciiz "\n"
	
.text
main:
	
	li $v0, 4 # Chamando função para imprimir string
	la $a0, menu # Passando a váriavel menu da memoria para o registrador de argumento da função
	syscall
	
	li $v0, 5 # Chamando função para ler inteiro
	syscall
	move $t0, $v0 # Movendo o inteiro lido para o resgistrador $t0
	
	beq $t0, 1, farenheit # Se $t0 for igual a 1, então pula para a função farenheit
	beq $t0, 2, fibonacci # Se $t0 for igual a 2, então pula para a função fibonacci
	beq $t0, 3, enesimo_par # Se $t0 for igual a 3, então pula para a função enesimo par
	beq $t0, 4, sair # Se $t0 for igual a 5, então pula para função sair, fechando o programa
	
	j main # Pula de volta main caso não faça uma branch
	
farenheit:
	# Imprimindo o menu da função farenheit
	li $v0, 4
	la $a0, farenheit_menu
	syscall
	
	li $v0, 6 # Lendo a temperatura em float que ficará salva no registrador $f0
	syscall
	mov.s $f1, $f0 # Passando o valor de $f0 para $f1

	# Armazenando valores como inteiros e transferindo para os registradores de numeros flutuantes
	
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
	
fibonacci:
	# Imprimindo o menu
	li $v0, 4
	la $a0, fibonacci_menu
	syscall 
	
	# Lendo o inteiro de N
	li $v0, 5
	syscall
	move $t1, $v0 # Armazenando em $t1
	
	li $t7, 1 # Inializando um contador com 1
	li $t2, 0 # Definindo $t2 como F(0) = 0
	li $t3, 1 # Definindo $t3 como F(1) = 1

	fibonacci_calc:
		beq $t7, $t1, fibonacci_result # Se o contador chegar a N ($t7 == N) pula para fibonacci_result 
		move $t4, $t3 # Armazena o valor de F(N-1) em $t4
		add $t3, $t3, $t2 # Soma F(N-1) + F(N-2) e armazena em $t3 ($t3 = $t3 + $t2)
		move $t2, $t4 # Armazena o valor de F(N-1) em $t2, agora sendo F(N-2)
		addi $t7, $t7, 1 # Soma +1 ao contador ($t7 = $t7 +1)
		j fibonacci_calc # Chama a si mesmo de forma recursiva
		
	fibonacci_result:
		# Imprimindo o resultado
		li $v0, 4
		la $a0, resultado
		syscall

		li $v0, 1
		move $a0, $t3
		syscall
		
		# Pulando linha
		li $v0, 4
		la $a0, pula_linha
		syscall

	j main # Pula de volta para main

enesimo_par:
	# Imprimindo o menu
    	li $v0, 4
    	la $a0, par_menu
    	syscall

    	# Lendo o número inteiro
    	li $v0, 5
   	syscall
    	move $t0, $v0          # Passando o número lido em $t0

    	# Multiplicando o número por 2 (deslocando os bits para a esquerda)
    	sll $t1, $t0, 1        # $t1 = $t0 * 2

    	# Imprimindo o resultado
    	li $v0, 4
    	la $a0, resultado
    	syscall

    	li $v0, 1
    	move $a0, $t1
    	syscall

    	# Pulando Linha
    	li $v0, 4
   	la $a0, pula_linha
    	syscall

	j main # Pula de volta pra main

sair:
	li $v0, 10
	syscall
