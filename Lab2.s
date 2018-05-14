			.data
array:		.space 80
promptRead:	.asciiz "Please enter an integer: "
printLargest:.asciiz "The largest integer is: "
printSmallest:.asciiz "The smallest integer is: "
printOdd:	.asciiz "The number of odd integers is: "
printEven:	.asciiz "The number of even integers is: "

space:		.asciiz " "
newLine:	.asciiz "\n"
			
			.text
			li $t0, 20				#counter of integers
			la $t1, array			#load array into t1
loopRead:	la $a0, promptRead		
			li $v0, 4
			syscall					#print prompt
			li $v0, 5 
			syscall					#read integer from user
			sw $v0, ($t1)			#save integer read from user in t1
			add $t0, $t0, -1		#decrement counter of integers to read			
			add $t1, $t1, 4 		#move array location to next space for integer
			bgtz $t0, loopRead		#repeat if still more integers to read
			
useFunction1:	la $a0, array			#store array location argument in a0
			li $a1, 20				#store counter argument in a1
			jal smallestLargest		#find smallest in v0, largest in v1
			move $t3, $v0			#save smallest in temp register
			la $a0, printSmallest
			li $v0, 4
			syscall					#print printSmallest
			move $a0, $t3			#move smallest to a0
			li $v0, 1
			syscall					#print smallest
			la $a0, newLine
			li $v0, 4
			syscall					#print newLine
			la $a0, printLargest
			syscall					#print printLargest
			move $a0, $v1			#move largest to a0
			li $v0, 1
			syscall					#print largest
			la $a0, newLine
			li $v0, 4
			syscall					#print newLine
			
useFunction2:	la $a0, array		#store array location argument in a0
			li $a1, 20				#store counter argument in a1
			jal oddEven				#find #odd in v0, #even in v1
			move $t3, $v0			#save odd in temp register
			la $a0, printOdd
			li $v0, 4
			syscall					#print printOdd
			move $a0, $t3			#move odd to a0
			li $v0, 1
			syscall					#print odd
			la $a0, newLine
			li $v0, 4
			syscall					#print newLine
			la $a0, printEven
			syscall					#print printEven
			move $a0, $v1			#move even to a0
			li $v0, 1
			syscall					#print even
			la $a0, newLine
			li $v0, 4
			syscall					#print newLine
			li $v0, 10
			syscall					#end program
			
smallestLargest:	#a0 = array, a1 = counter
			lw $t4, ($a0)			#set smallest integer to t4
			lw $t5, ($a0)			#set largest integer to t5
SL:			beqz $a1, endSL			#end when a1 = 0
			lw $t0, ($a0)			#load next integer in array
			add $a1, $a1, -1		#decrement counter of integers to go through
			add $a0, $a0, 4			#move to next memory location in array
			blt $t0, $t4, newSmallest #if read integer less than smallest, save it
			bgt $t0, $t5, newLargest #if read integer greater than largest, save it
			b SL
endSL:		move $v0, $t4			#move smallest integer to v0 to return
			move $v1, $t5			#move largest integer to v1 to return
			jr $ra					#end function
			
newSmallest:move $t4, $t0			#set new smallest from t0
			b SL
newLargest:	move $t5, $t0			#set new largest from t0
			b SL
			
			
			
oddEven:	li $t4, 0				#number of odd integers
			li $t5, 0				#number of even integers
OE:			beqz $a1, endOE			#end when a1 = 0
			lw $t0, ($a0)			#load next integer in array
			add $a1, $a1, -1		#decrement counter of integers to go through
			add $a0, $a0, 4			#move to next memory location in array
			rem $t1, $t0, 2			#t1 = remainder, t0 % 2
			beqz $t1, countEven		#if remainder = 0, count even
			bnez $t1, countOdd		#if remainder != 0, count odd
			b OE
endOE:		move $v0, $t4			#move number of odd to v0 to return
			move $v1, $t5			#move number of even to v1 to return
			jr $ra
			
countOdd:	add $t4, $t4, 1			#increment number of odd integers
			b OE
countEven:	add $t5, $t5, 1			#increment number of even integers
			b OE