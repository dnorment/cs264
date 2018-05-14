			.data
string:		.space 20 	#max string length is 20
promptS:	.asciiz "Please enter a string: "
numUpper:	.space 104	#65 - 90
numLower:	.space 104	#97 - 122
numSpace:	.space 4	#32
freqS1:		.asciiz "The frequency of character "
freqS2:		.asciiz " is: "
palinT:		.asciiz "The string is a palindrome."
palinF:		.asciiz "The string is not a palindrome."
newLine:	.asciiz "\n"
			
			.text
			la $a0, promptS
			li $v0, 4
			syscall					#print promptS
			li $v0, 8
			la $a0, string
			la $a1, 20
			syscall					#read string into string space
			
			la $a0, string
pString:	lb $t0, ($a0)			#read character into t0
			add $a0, $a0, 1			#move a0 to next character
			beqz $t0, printFreqs	#branch printFreqs if string ends
			beq $t0, 32, incSpace	#branch incSpace if character is space
			bge $t0, 97, incLower	#branch incLower if character is lowercase
			ble $t0, 90, incUpper	#branch incUpper if character is uppercase
			b pString
			
incUpper:	la $t8, numUpper		#load address of uppercase counters
			add $t0, $t0, -65		#so A = 0, B = 1, ..., Z = 25
			mul $t1, $t0, 4			#get offset for letter
			add $t8, $t8, $t1		#add offset for letter
			lw $t7, ($t8)			#load value of counter
			add	$t7, $t7, 1			#increment value
			sw $t7, ($t8)			#save value
			b pString
			
incLower:	la $t8, numLower		#load address of lowercase counters
			add $t0, $t0, -97		#so a = 0, b = 1, ..., z = 25
			mul $t1, $t0, 4			#get offset for letter
			add $t8, $t8, $t1		#add offset for letter
			lw $t7, ($t8)			#load value of counter
			add	$t7, $t7, 1			#increment value
			sw $t7, ($t8)			#save value
			b pString
			
incSpace:	la $t8, numSpace		#load address of space counter
			lw $t7, ($t8)			#load value of space counter
			add	$t7, $t7, 1			#increment value
			sw $t7, ($t8)			#save value
			b pString				#go back to get next character
			
printFreqs:	li $t0, 32				#load t0 as space character
			la $t4, numSpace		#load t4 as number of spaces array
printSpace:	la $a0, freqS1
			li $v0, 4
			syscall					#the frequency of character
			move $a0, $t0
			li $v0, 11
			syscall					#space character
			la $a0, freqS2
			li $v0, 4
			syscall					#is: 
			lw $a0, ($t4)
			li $v0, 1
			syscall					#print number of spaces
			la $a0, newLine
			li $v0, 4
			syscall					#newLine
			
			la $t4, numUpper
			li $t0, 65
			li $t1, 26
printUpper:	la $a0, freqS1
			li $v0, 4
			syscall					#the frequency of character
			move $a0, $t0
			add $t0, $t0, 1			#move to next character
			li $v0, 11
			syscall					#(character)
			la $a0, freqS2
			li $v0, 4
			syscall					#is: 
			lw $a0, ($t4)
			li $v0, 1
			syscall					#print number of character
			add $t4, $t4, 4			#move to next array location
			add $t1, $t1, -1		#decrement counter
			la $a0, newLine
			li $v0, 4
			syscall					#newLine
			bgtz $t1, printUpper	#loop while still more frequencies to print
			
			la $t4, numLower
			li $t0, 97
			li $t2, 26
printLower:	la $a0, freqS1
			li $v0, 4
			syscall					#the frequency of character
			move $a0, $t0
			add $t0, $t0, 1			#move to next character
			li $v0, 11
			syscall					#(character)
			la $a0, freqS2
			li $v0, 4
			syscall					#is: 
			lw $a0, ($t4)
			li $v0, 1
			syscall					#print number of character
			add $t4, $t4, 4			#move to next array location
			add $t2, $t2, -1		#decrement counter
			la $a0, newLine
			li $v0, 4
			syscall					#newLine
			bgtz $t2, printLower	#loop while still more frequencies to print
			

			la $a0, string
			jal isPal
			bgtz $v0, palT			#print true if v0 > 0
palF:		la $a0, palinF
			li $v0, 4
			syscall					#print it is not palindrome
			b end
palT:		la $a0, palinT
			li $v0, 4
			syscall					#print it is a palindrome
			
end:		li $v0, 10
			syscall				#end program
		
# MEEM  
isPal:		li $v0, 0
			move $s0, $a0		#move array to s0
			li $t2, 0			#length counter
toEnd:		lb $t0, ($s0)		#load byte of s0
			beqz $t0, moveEnd	#reached end, so move s0 to end of string
			add $s0, $s0, 1		#move to next character
			add $t2, $t2, 1		#increment length
			b toEnd				#repeat while still more characters
			
moveEnd:	move $s0, $a0
			add $s0, $s0, $t2	#move s0 to end
			add $s0, $s0, -1
			
equalChar:	lb $t3, ($a0)
			lb $t4, ($s0)
			beqz $t3, isTrue
			bne $t3, $t4, notEqual
			add $a0, $a0, 1
			add $s0, $s0, -1
			b equalChar
isTrue:		li $v0, 1
notEqual:	jr $ra