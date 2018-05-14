			.data
array:		.space 480 				#each record is 48B
promptName: .asciiz "Please enter employee name: "
promptAge:	.asciiz "Please enter employee age: "
promptSalary:.asciiz "Please enter employee salary: "
promptSwap: .asciiz "Please enter the numbers of two records two swap (1-10): "
dispName:	.asciiz "Employee name: "
dispAge:	.asciiz "  Age: "
dispSalary:	.asciiz ", Salary: $"
newLine:	.asciiz "\n"
space:		.asciiz " "
			
			.text
			li $t0, 0				#number of records read
			la $s0, array			#load array into s0
readRec:	la $a0, promptName		
			li $v0, 4
			syscall					#print promptName
			move $a0, $s0			#move array pointer into a0
			li $a1, 40				#maximum 40 characters
			li $v0, 8
			syscall					#read into array
			la $a0, promptAge
			li $v0, 4
			syscall					#print promptAge
			li $v0, 5
			syscall					#read integer
			sw $v0, 40($s0)			#save age integer after name
			la $a0, promptSalary
			li $v0, 4
			syscall					#print promptSalary
			li $v0, 5
			syscall					#read integer
			sw $v0, 44($s0)			#save salary integer after age
			add $t0, $t0, 1			#increment number of records read
			add $s0, $s0, 48		#move to next record space
			blt $t0, 10, readRec	#loop readRec if less than 10 records
			
			li $t0, 0				#number of records printed
			la $a1, array			#load array into a1
printRec:	la $a0, dispName
			li $v0, 4
			syscall					#print dispName
			move $a0, $a1			#move array into a0 to print name
			syscall					#print name
			la $a0, dispAge
			li $v0, 4
			syscall					#print dispAge
			lw $a0, 40($a1)			#load age into a0
			li $v0, 1
			syscall					#print age
			la $a0, dispSalary
			li $v0, 4
			syscall					#print dispSalary
			lw $a0, 44($a1)			#load salary into a0
			li $v0, 1
			syscall					#print salary
			la $a0, newLine
			li $v0, 4
			syscall					#print newLine
			add $a1, $a1, 48		#move to next record
			add $t0, $t0, 1			#increment number of records printed
			blt $t0, 10, printRec	#loop printRec if less than 10 records printed
			
swapRec:	la $a0, promptSwap
			li $v0, 4
			syscall					#print promptSwap
			li $v0, 5
			syscall					#read index 1
			move $t1, $v0			#store index 1 in t1
			li $v0, 5
			syscall					#read index 2
			move $t2, $v0			#store index 2 in t2
			add $t1, $t1, -1		#convert record numbers into indices
			add $t2, $t2, -1
			la $s1, array			#load array into s1, s2
			la $s2, array
			mul $t1, $t1, 48		#calculate offsets for index 1 and 2
			mul $t2, $t2, 48
			add $s1, $s1, $t1		#add offsets for records
			add $s2, $s2, $t2		#now s1 points to record 1 and s2 to record 2
			#swap names
			li $t3, 0				#number of words swapped
swapWords:	lw $t1, ($s1)			#load name of record 1 in t1
			lw $t2, ($s2)			#load name of record 2 in t2
			sw $t2, ($s1)			#save name of record 2 in record 1
			sw $t1, ($s2)			#save name of record 1 in record 2
			add $t3, $t3, 1			#decrement number of words to swap
			add $s1, $s1, 4			#move to next word
			add $s2, $s2, 4
			blt $t3, 10, swapWords	#loop swapWords if less than 10 words swapped
			add $s1, $s1, -40		#move array pointers back to original offset
			add $s2, $s2, -40
			#swap ages
			lw $t1, 40($s1)			#load age of record 1 in t1
			lw $t2, 40($s2)			#load age of record 2 in t2
			sw $t2, 40($s1)			#save age of record 2 in record 1
			sw $t1, 40($s2)			#save age of record 1 in record 2
			#swap salaries
			lw $t1, 44($s1)			#load salary of record 1 in t1
			lw $t2, 44($s2)			#load salary of record 2 in t2
			sw $t2, 44($s1)			#save salary of record 2 in record 1
			sw $t1, 44($s2)			#save salary of record 1 in record 2
			
			#instructions ask for a program and not a function, so this is exactly same as above
			li $t0, 0				#number of records printed
			la $a1, array			#load array into a1
printRec2:	la $a0, dispName
			li $v0, 4
			syscall					#print dispName
			move $a0, $a1			#move array into a0 to print name
			syscall					#print name
			la $a0, dispAge
			li $v0, 4
			syscall					#print dispAge
			lw $a0, 40($a1)			#load age into a0
			li $v0, 1
			syscall					#print age
			la $a0, dispSalary
			li $v0, 4
			syscall					#print dispSalary
			lw $a0, 44($a1)			#load salary into a0
			li $v0, 1
			syscall					#print salary
			la $a0, newLine
			li $v0, 4
			syscall					#print newLine
			add $a1, $a1, 48		#move to next record
			add $t0, $t0, 1			#increment number of records printed
			blt $t0, 10, printRec2	#loop printRec2 if less than 10 records printed
			
			li $v0, 10
			syscall					#end program