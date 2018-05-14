			.data
			
array:		.space 80
newLine: 	.asciiz "\n"
space:		.asciiz " "
prompt:		.asciiz "Enter an integer:"
promptTwo:	.asciiz "Enter an integer between 1 and 20:"
			
			.text
			
main:		li $t0, 20			#counter for number of integers to read
			li $t2, 20			#counter for number of integers to print w/ newLine
			li $t4, 20			#counter for number of integers to print w/ spaces
			li $t6, 20			#counter for number of integers to print in reverse
			li $t7, 20			#counter for number of integers to print in groups
			la $t1, array		#array location for reading
			la $t3, array		#array location for printing w/ newLine
			la $t5, array		#array location for printing in reverse
			la $t8, array		#array location for printing in groups
			
			#counter in t0, array in t1
LoopRead:	beqz $t0, LoopNL	#goto LoopNL when all integers read
			la $a0, prompt 		#store prompt in $a0
			li $v0, 4			
			syscall				#print prompt
			li $v0, 5 
			syscall				#read integer from user
			sw $v0, ($t1)		#save integer read from user in $t1 (array)
			add $t0, $t0, -1	#decrement counter of integers to read			
			add $t1, $t1, 4 	#move array location to next space for integer
			b LoopRead			#repeat, still more integers to read
			
			#counter in t2, array in t3
LoopNL:		beqz $t2, LoopS		#goto LoopS when all integers printed
			lw $a0, ($t3)		#load contents of array location into $a0
			li $v0, 1
			syscall				#print number in array
			la $a0, newLine		#store newLine in $a0
			li $v0, 4
			syscall				#print newLine
			add $t2, $t2, -1	#decrement counter of integers to print
			add $t3, $t3, 4		#move array location to next integer
			b LoopNL			#repeat, still more integers to print
			
			#counter in t4, array in t5
LoopS:		beqz $t4, RevNL		#goto LoopRev when all integers printed
			lw $a0, ($t5)		#load contents of array location into $a0
			li $v0, 1
			syscall				#print number in array
			la $a0, space		#store prompt in $a0
			li $v0, 4
			syscall				#print space
			add $t4, $t4, -1	#decrement counter of integers to print
			add $t5, $t5, 4		#move array location to next integer
			b LoopS				#repeat, still more integers to print
			
			#counter in t6, array in t5
RevNL:		la $a0, newLine
			li $v0, 4
			syscall				#print new line
LoopRev:	beqz $t6, LoopMLP	#goto LoopMLP when all integers printed
			lw $a0, -4($t5)		#load contents of array location into $a0
			li $v0, 1
			syscall				#print number in array
			add $t6, $t6, -1	#decrement counter of integers to print
			add $t5, $t5, -4	#move array location to next integer
			la $a0, space		#store space in $a0
			li $v0, 4
			syscall				#print space
			b LoopRev			#repeat, still more integers to print
			
			#counter in t7, array in t8, nums/line in t9, line counter in s0
LoopMLP:	la $a0, newLine
			li $v0, 4
			syscall				#print new line
			la $a0, promptTwo	#store prompt2 in $a0
			li $v0, 4
			syscall				#print prompt2
			li $v0, 5
			syscall				#read integer from user
			move $s2, $v0		#store integer in $s2
			
			move $t9, $s2		#store numbers per line in $t9
LoopML:		lw $a0, ($t8)		#load contents of array location into $a0
			li $v0, 1			
			syscall				#print number in array
			add $t9, $t9, -1	#decrement numbers left to print this line
			add $t7, $t7, -1	#decrement numbers left to print total
			add $t8, $t8, 4		#move to next array location
			la $a0, space
			li $v0, 4
			syscall				#print space
			beqz $t7, end		#end when all numbers printed
			bnez $t9, LoopML	#repeat until all numbers per line printed
			la $a0, newLine
			li $v0, 4
			syscall				#print new line
			move $t9, $s2		#reset number of integers per line
			b LoopML			#repeat, still more integers to print
			
end:		li $v0, 10
			syscall
			
