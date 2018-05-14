			.data
array:		.space 40
newLine:	.asciiz "\n"
promptInt:	.asciiz "Please enter an integer: "
resultMin:	.asciiz "The minimum of the given integer set is: "
promptComb:	.asciiz "Please enter two integers n,r where n>=r and n,r>=0: "
resultComb: .asciiz "The combination of the given integers is: "
			
			.text
			la $t0, array			#array is in t0
			li $t1, 10				#number of integers to read
read:		la $a0, promptInt
			li $v0, 4
			syscall					#display promptInt
			li $v0, 5
			syscall					#read integer
			sw $v0, ($t0)			#save read integer in array
			add $t0, $t0, 4			#move to next array location
			add $t1, $t1, -1		#decrement number of integers to read
			bgtz $t1, read			#loop while more integers to read
			
			la $a0, array
			li $a1, 0
			li $a2, 9
			jal minimum				#minimum(array, 0, 9)
			move $s0, $v0			#save return value
			la $a0, resultMin
			li $v0, 4
			syscall					#display resultMin
			move $a0, $s0
			li $v0, 1
			syscall					#display return value
			la $a0, newLine
			li $v0, 4
			syscall					#display newLine
			
			la $a0, promptComb
			li $v0, 4
			syscall					#display promptComb
			li $v0, 5
			syscall					#read first integer
			move $t0, $v0			#move first integer to t0=n
			la $a0, promptComb
			li $v0, 4
			syscall					#display promptComb
			li $v0, 5
			syscall					#read second integer
			move $a0, $t0
			move $a1, $v0			#move second integer to a1=r
			jal comb				#comb(n,r)
			move $s0, $v0			#save return value
			la $a0, resultComb
			li $v0, 4
			syscall					#display resultComb
			move $a0, $s0
			li $v0, 1
			syscall					#display return value
			la $a0, newLine
			li $v0, 4
			syscall					#display newLine
			
			li $v0, 10
			syscall					#end program
			
minimum:	bne $a1, $a2, minRecu	#if low!=high, recursive case
			move $t0, $a0			#else, return A[low]. copy array to t0
			mul $t1, $a1, 4			#get offset of low value
			add $t0, $t0, $t1		#add offset of low value
			lw $v0, ($t0)			#return low value
			jr $ra
minRecu:	addiu $sp, $sp, -16		#reserve space on stack
			sw $ra, ($sp)			#save return address on stack
			sw $a1, 4($sp)			#save low on stack
			sw $a2, 8($sp)			#save high on stack
			add $t0, $a1, $a2		#low + high
			div $t0, $t0, 2			#divide by 2
			move $a2, $t0			#move mid into a2
			jal minimum				#minimum(A, low, mid)
			sw $v0, 12($sp)			#save min(A, low, mid) on stack
			lw $a1, 4($sp)			#load low into a1
			lw $a2, 8($sp)			#load high into a2
			add $t0, $a1, $a2		#low + high
			div $t0, $t0, 2			#divide by 2
			move $a1, $t0			#move mid into a1
			add $a1, $a1, 1			#increment mid by 1
			jal minimum				#minimum(A, mid+1, high)
			lw $t0, 12($sp)			#load min1 into t0
			bgt $t0, $v0, endMin	#return min2 if min1>min2
			move $v0, $t0			#else return min1
endMin:		lw $ra, ($sp)			#load return address
			addiu $sp, $sp, 16		#release space on stack
			jr $ra
			
comb:		beq $a0, $a1, combR		#if n=r, return 1
			beqz $a1, combR			#if r=0, return 1
			b combRecu				#else, recursive case
combR:		li $v0, 1
			jr $ra
combRecu:	addiu $sp, $sp, -16		#reserve space on stack
			sw $ra, ($sp)			#save return address on stack
			sw $a0, 4($sp)			#save n on stack
			sw $a1, 8($sp)			#save r on stack
			add $a0, $a0, -1
			jal comb				#comb(n-1, r)
			sw $v0, 12($sp)			#save comb(n-1, r) on stack
			lw $a0, 4($sp)			#load n into a0
			lw $a1, 8($sp)			#load r into a1
			add $a0, $a0, -1
			add $a1, $a1, -1
			jal comb				#comb(n-1, r-1)
			lw $t0, 12($sp)
			add $v0, $t0, $v0		#comb(n, r)= comb(n-1, r) + comb(n-1, r-1)
			lw $ra ($sp)			#load return address
			addiu $sp, $sp, 16		#release space on stack
			jr $ra