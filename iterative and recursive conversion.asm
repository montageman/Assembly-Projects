#Write a MIPS assembly language program that:

#1. prompts the user for a positive integer N.

#2. calls a subroutine sum_iterative, then displays the returned value

#3. calls a subroutine sum_recursive, then displays the returned value

#Subroutine sum_iterative gets N as the input parameter and calculates the sum of its decimal digits iteratively 
#(i.e. non-recursive) then returns the result. Subroutine sum_recursive does the same but uses recursion.

#The program should also display a string before calling each subroutine to identify which version it is calling 
#(i.e. iterative or recursive).

#Can you tell which version runs faster?

#Submit your work in a Word document by the due date.
#Your submission must include the source code and a screen capture of MARS's output window showing that the program runs correctly.
.data
innitialprompt: .asciiz "Enter a positive integer\n"

prompt1: .asciiz "iterative call: \n"
prompt2: .asciiz "recursive call: \n"

prompttime: .asciiz "time passed: "
promptsum: .asciiz "sum total: "

line: .asciiz "\n"

userinput: .space 201

.text
main: 

	li $v0, 4 		# print prompt
	la $a0, innitialprompt 	# Enter a positive integer
	syscall

	li $v0, 8 		# read string
	la $a0, userinput 	# address of input
	addi $a1, $zero, 200	# max length of 100 characters bacause I can..
    	syscall
	
	lb $t1, ($a0)		# load first byte of the string entered
	subi $t1, $t1, 48
	beqz $t1 exit		# if that byte is char '0', exit using syscall 10
	
	li $t7, 10		# ascii character for [ENTER]
	li $t8, 0		# ascii for [NULL]
	
	li $v0, 4		#print prompt	
	la $a0, line 		# \n
	syscall
	
	##################################################################
	# itterative call:
	li $v0, 4 		# print prompt
	la $a0, prompt1 	# iterative call:
	syscall
	
	la $s0, userinput	# load address of user input
	jal settime 		# get current time
	jal sum_iterative 	# call the first required Subroutine, sum_iterative
	jal gettime 		# displays the time that has passed
	
	jal printsum		# prints the sum
	
	##################################################################
		# line to seperate results to be read easier
	li $v0, 4 		# print prompt
	la $a0, line 		# \n
	syscall
	
	##################################################################
		# recursive call:
	
	li $v0, 4 		# print prompt
	la $a0, prompt2 	# recursive call: 
	syscall
	
	la $s0, userinput
	jal settime 		# get current time
	jal sum_recursive	# call the second required Subroutine, sum_recursive
	jal gettime 		# this displays the time that has passed
	
	jal printsum
	
	##################################################################
	# line to seperate results to be read easier
	
	li $v0, 4 		# print prompt
	la $a0, line 		# \n
	syscall

	j main 			# loop
	
sum_iterative:		# eg. if N = 123, result == 6
	
	lb $t1, ($s0)
	beq $t1, $t7, continue 	# if byte == [ENTER], break
	beq $t1, $t8, continue 	# if byte == [NULL], break
	
	subi $t1, $t1, 48	# change the current byte from ascii to decimal
	add $t2, $t2, $t1	# add that number too the running total
	
	addi $s0, $s0, 1 	# itterate to next byte
	
	j sum_iterative		# loop until done
	
sum_recursive: 	# $sp is the stack pointer regester. subtract 4 each call, add 4 on the break
		# put each result into an address of the stack. 
		# when done, add each used piece in the stack
	
	lb $t1, ($s0)
	beq $t1, $t7, continue 	#if byte == [ENTER], break
	beq $t1, $t8, continue 	#if byte == [NULL], break
	
	subi $t1, $t1, 48	# change the current byte into a decimal number from binary
	
		# store $ra on stack
	sw $ra, ($sp)
	subi $sp, $sp, 4
	
		# store byte on stack
	sw $t1, ($sp)
	subi $sp, $sp, 4
	
	addi $s0, $s0, 1 	#itterate to next byte
	
	jal sum_recursive	#recursive call
		
		# get byte from stack
	addi $sp, $sp, 4
	lw $t1, ($sp)
	
	add $t2, $t2, $t1	#add to the total
		
		# get previous $ra
	addi $sp, $sp, 4
	lw $ra, ($sp)
	
		# return to previous call
	jr $ra			# return
	
	
continue: 	# this lets me return easily using the ittterative method
	jr $ra 			# return


settime:	# This is the first function in getting an elapsed time

	li $v0, 30 		#get current time
	syscall 
	addi $t0, $a0, 0 	#save the least signifigant digits of the time

	jr $ra 			# return
	
gettime:	# This is the second function in getting an elapsed time

	li $v0, 4 		# print prompt
	la $a0, prompttime 	# time passsed: 
	syscall

		
	li $v0, 30 		# get current time	
	syscall
	
	addi $t1, $a0, 0	# save the current time 
	

	
		#prints current time
	li $v0, 1		# print int in $a0
	sub $a0, $t1, $t0	# get the difference from the current time from the time settime calculated
	syscall
	
	li $v0, 4 		#print prompt
	la $a0, line 		# \n
	syscall

	jr $ra			# return

printsum:

	li $v0, 4 		#print prompt
	la $a0, promptsum 	# sum total:
	syscall

	li $v0, 1		#print int
	addi $a0, $t2, 0	# moves the current sum into $a0
	syscall
	
	li $v0, 4 		#print prompt
	la $a0, line # \n
	syscall
	
	add $t2, $zero, $zero 	#reset $t2

	jr $ra			# return
exit:
	
	li $v0, 10
	syscall
