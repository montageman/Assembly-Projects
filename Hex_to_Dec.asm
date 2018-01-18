.data
#	li $v0, 4 # print a prompt
#    	la $a0, prompt0 #load address
#    	syscall

userinput: .space 10 	#this is larger than it needs to be to avoid errors right now

prompt0: .asciiz "\nEnter a number between 0 and 3: "
prompt1: .asciiz "Enter an Unsigned 4 digit hexideciman number.\n"
prompt2: .asciiz "Enter a signed 4 digit hexideciman number.\n"
prompt3: .asciiz "Enter four integers that are equal to or between 65 and 90.\n"

wronginput: .asciiz "\nThe number you entered is invalid\n"
case3wronginput: .asciiz "That number is not valid and was ignored.\n"

#these two strings are used in test code
space: .asciiz "_"
result: .asciiz "\nThe numbers are: "

finalresult: .asciiz "\nThe number in decimal is: "

negativesign: .asciiz "-"
positivesign: .asciiz "+"

.text
main:

	li $v0, 4 # print a prompt
    	la $a0, prompt0 # Enter a number between 0 and 3: 
    	syscall

	li $v0, 5 		# Read next int
	syscall
	
	beq $v0, 0, call0 	# If the input == 0, go to call0
	beq $v0, 1, call1	# If the input == 1, go to call1
	beq $v0, 2, call2	# If the input == 2, go to call2
	beq $v0, 3, call3	# If the input == 3, go to call3
	
	j main         	# Go to Loop 

call1:
#If input is 1, perform UNSIGNED 16-bit hexa-to-decimal conversion by prompting user for a 4 digit hexadecimal number, 
#e.g. F0F1, then print the input number in decimal.
	
	#convert string of hex to decimal

	li $v0, 4 # print a prompt
    	la $a0, prompt1 #Enter an Unsigned 4 digit hexideciman number.
    	syscall

	li $v0, 8 # read string
	la $a0, userinput 	#address of input
	addi $a1, $zero, 5	#max length
    	syscall
    	
    	#this block parses the user's input
	la $s0, userinput
	lb $t0, ($s0) 	
	lb $t1, 1($s0)
	lb $t2, 2($s0)
	lb $t3, 3($s0)
	lb $t4, 4($s0)
		
	jal Movedigits	#this puts zero's in front of the number if the user did not enter 4 characters

	#for each of t0-t3, pass t0 into uhextodecimal and store its result into the passed regester
	
	add $v0, $zero, $t0
	jal uhextodecimal
	add $t0, $zero, $v0

	add $v0, $zero, $t1
	jal uhextodecimal
	add $t1, $zero, $v0
		
	add $v0, $zero, $t2
	jal uhextodecimal
	add $t2, $zero, $v0	
	
	add $v0, $zero, $t3
	jal uhextodecimal
	add $t3, $zero, $v0
	
	addi $s0, $zero, 4096 	#16^3
	addi $s1, $zero, 256	#16^2
	addi $s2, $zero, 16	#16^1
	addi $s3, $zero, 1	#16^0 This one is put for ease of understanding. 

	#Multiply the numbers and get the lower result. we do not need hi becasue our number can not get that large
	multu  $t0, $s0
	mflo $t0
	multu $t1, $s1
	mflo $t1
	multu $t2, $s2
	mflo $t2
	multu $t3, $s3
	mflo $t3
	
	#add t0 - t3
	add $t0, $t0, $t1
	add $t0, $t0, $t2
	add $t0, $t0, $t3
	
	li $v0, 4 # print a prompt
    	la $a0, finalresult # The number in decimal is: 
    	syscall
	
	li $v0, 1 # print a n int
    	add $a0, $zero, $t0 
    	syscall
	
	j main


call2:
#If input is 2, perform SIGNED 16-bit hexa-to-decimal conversion by prompting user for a 4 digit hexadecimal number, 
#e.g. F0F1, then print the input number in decimal with the '-' character if the input is negative. 
#Your test should include at least on conversion that results in a negative decimal number.



	li $v0, 4 # print a prompt
    	la $a0, prompt2 # Enter a signed 4 digit hexideciman number.
    	syscall

	li $v0, 8 # read string
	la $a0, userinput 	#address of input
	addi $a1, $zero, 5	#max length
    	syscall
    	
    	#this block parses the user's input
	la $s0, userinput
	lb $t0, ($s0) 	
	lb $t1, 1($s0)
	lb $t2, 2($s0)
	lb $t3, 3($s0)
	lb $t4, 4($s0)
		
	jal Movedigits	#this puts zero's in front of the number if the user did not enter 4 characters

	#for each of t0-t3, pass t0 into uhextodecimal and store its result into the passed regester
	add $v0, $zero, $t0
	jal uhextodecimal
	add $t0, $zero, $v0

	add $v0, $zero, $t1
	jal uhextodecimal
	add $t1, $zero, $v0
		
	add $v0, $zero, $t2
	jal uhextodecimal
	add $t2, $zero, $v0	
	
	add $v0, $zero, $t3
	jal uhextodecimal
	add $t3, $zero, $v0
	
	
	addi $s0, $zero, 4096 	#16^3
	addi $s1, $zero, 256	#16^2
	addi $s2, $zero, 16	#16^1
	addi $s3, $zero, 1	#16^0 This one is put for ease of understanding. 

	#Multiply the numbers and get the lower result. we do not need hi becasue our number can not get that large
	multu  $t0, $s0
	mflo $t0
	multu $t1, $s1
	mflo $t1
	multu $t2, $s2
	mflo $t2
	multu $t3, $s3
	mflo $t3
	
	#add t0 - t3
	add $t0, $t0, $t1
	add $t0, $t0, $t2
	add $t0, $t0, $t3
	
	li $v0, 4 # print a prompt
    	la $a0, finalresult #The number in decimal is: 
    	syscall

	jal isthenumbernegative
	#if not, continue

	li $v0, 1 # print a n int
    	add $a0, $zero, $t0 
    	syscall
	
	j main


call3:
#If input is 3, prompt for four integers that are between 65 and 90 inclusive, then print out a string of 4 ASCII characters corresponding the the input integers. 
#For instance if user inputs '65 66 67 and 68'  the program would print  'ABCD'.  Assuming that we have only syscall #4 and do not have syscall #11
	
	li $v0, 4 # print a prompt
    	la $a0, prompt3 # Enter four integers that are equal to or between 65 and 90.\n"
    	syscall
	
	jal case3inputvalidation
	add $t0, $zero, $v0
	
	jal case3inputvalidation
	add $t1, $zero, $v0
		
	jal case3inputvalidation
	add $t2, $zero, $v0
		
	jal case3inputvalidation
	add $t3, $zero, $v0
	
	#Build the string of ascii characters
	la $s0, userinput
	sb $t0, ($s0) 	
	sb $t1, 1($s0)
	sb $t2, 2($s0)
	sb $t3, 3($s0)
	sb $zero, 4($s0)
	
	li $v0, 4 # print a prompt
    	la $a0, userinput # what the user entered as a string
    	syscall


	j main
	
call0:
#exit

	li $v0, 10 		# Exit
	syscall

uhextodecimal: # I wish i knew a better way to do this
	
	#passed $v0
	addi $t7, $zero, 48 # '0'
	beq $v0, $t7, passeddigit	
	addi $t7, $zero, 49 # '1'
	beq $v0, $t7, passeddigit
	addi $t7, $zero, 50 # '2'
	beq $v0, $t7, passeddigit
	addi $t7, $zero, 51 # '3'
	beq $v0, $t7, passeddigit
	addi $t7, $zero, 52 # '4'
	beq $v0, $t7, passeddigit
	addi $t7, $zero, 53 # '5'
	beq $v0, $t7, passeddigit
	addi $t7, $zero, 54 # '6'
	beq $v0, $t7, passeddigit
	addi $t7, $zero, 55 # '7'
	beq $v0, $t7, passeddigit
	addi $t7, $zero, 56 # '8'
	beq $v0, $t7, passeddigit
	addi $t7, $zero, 57 # '9'
	beq $v0, $t7, passeddigit
	
	
	addi $t7, $zero, 65 # 'A'
	beq $v0, $t7, passedcharCAP
	addi $t7, $zero, 66 # 'B'
	beq $v0, $t7, passedcharCAP
	addi $t7, $zero, 67 # 'C'
	beq $v0, $t7, passedcharCAP
	addi $t7, $zero, 68 # 'D'
	beq $v0, $t7, passedcharCAP
	addi $t7, $zero, 69 # 'E'
	beq $v0, $t7, passedcharCAP
	addi $t7, $zero, 70 # 'F'
	beq $v0, $t7, passedcharCAP
	
	addi $t7, $zero, 97 # 'a'
	beq $v0, $t7, passedcharLOW
	addi $t7, $zero, 98 # 'b'
	beq $v0, $t7, passedcharLOW
	addi $t7, $zero, 99 # 'c'
	beq $v0, $t7, passedcharLOW
	addi $t7, $zero, 100 # 'd'
	beq $v0, $t7, passedcharLOW
	addi $t7, $zero, 101 # 'e'
	beq $v0, $t7, passedcharLOW
	addi $t7, $zero, 102 # 'f'
	beq $v0, $t7, passedcharLOW
	
	#otherwise the number is not valid
	
	j ERROR
	
	#print error
	#return to call1 or main


passeddigit:

	subi $v0, $v0, 48 #subtract '0' from the given character. if this is a digic, it changes to it's decimal notation

	# $ra herer is the same as uhextodecimal
	jr $ra


passedcharCAP:

	subi $v0, $v0, 55 #subtracts from $v0 to change its ascii into its hex value 
	
	# $ra here is the same as uhextodecimal
	jr $ra

passedcharLOW:

	subi $v0, $v0, 87 #subtracts from $v0 to change its ascii into its hex value 
	
	# $ra herer is the same as uhextodecimal
	jr $ra

Movedigits:

	#check if a char "ENTER" : ascii enter = 10
	addi $s2, $zero, 10
	beq $t0, $s2, movethem 
	beq $t1, $s2, movethem 
	beq $t2, $s2, movethem 
	beq $t3, $s2, movethem 
    	
    	# $ra does not change even though I am branching off. 
    	jr $ra

movethem:
	#if an ENTER is found, put a zero as the first digit of the inputs, and move each other digit down one place value.
	add $s3, $zero, $t0
	add $s4, $zero, $t1
	add $s5, $zero, $t2
	add $s6, $zero, $t3
	
	addi $t0, $zero, 48
	add $t1, $zero, $s3
	add $t2, $zero, $s4
	add $t3, $zero, $s5
	
	j Movedigits
	
printuserinput:
	#This was test code that was written to see the values the user inputed
    
    	li $v0, 4 # print a prompt
    	la $a0, result #load address
    	syscall

	#Print each char
	
	li $v0, 1 # print a prompt
    	add $a0, $zero, $t0 
    	syscall
    	
    	li $v0, 4 # print a prompt
    	la $a0, space #load address
    	syscall
    	
    	li $v0, 1
    	add $a0, $zero, $t1 
    	syscall
    	
    	li $v0, 4 # print a prompt
    	la $a0, space #load address
    	syscall
    	
    	li $v0, 1
    	add $a0, $zero, $t2 
    	syscall
    	
    	li $v0, 4 # print a prompt
    	la $a0, space #load address
    	syscall
    	
    	li $v0, 1
    	add $a0, $zero, $t3 
    	syscall
	
#	li $v0, 4 # print a prompt
	#address already loaded into $a0
#  	syscall
    	
	jr $ra
	

case3inputvalidation:

	li $v0, 5 #read int
	syscall
	
	#If the user entered a valid number, move on.
	#Again, this is not an ideal method of validation, but it dooes reliably work
	li $t7, 65 # 'A'
	beq $v0, $t7, case3GOOD
	li $t7, 66 # 'B'
	beq $v0, $t7, case3GOOD
	li $t7, 67 # 'C'
	beq $v0, $t7, case3GOOD
	li $t7, 68 # 'D'
	beq $v0, $t7, case3GOOD
	li $t7, 69 # 'E'
	beq $v0, $t7, case3GOOD
	li $t7, 70 # 'F'
	beq $v0, $t7, case3GOOD
	li $t7, 71 # 'G'
	beq $v0, $t7, case3GOOD
	li $t7, 72 # 'H'
	beq $v0, $t7, case3GOOD
	li $t7, 73 # 'I'
	beq $v0, $t7, case3GOOD
	li $t7, 74 # 'J'
	beq $v0, $t7, case3GOOD
	li $t7, 75 # 'K'
	beq $v0, $t7, case3GOOD
	li $t7, 76 # 'L'
	beq $v0, $t7, case3GOOD
	li $t7, 77 # 'M'
	beq $v0, $t7, case3GOOD
	li $t7, 78 # 'N'
	beq $v0, $t7, case3GOOD
	li $t7, 79 # 'O'
	beq $v0, $t7, case3GOOD
	li $t7, 80 # 'P'
	beq $v0, $t7, case3GOOD
	li $t7, 81 # 'Q'
	beq $v0, $t7, case3GOOD
	li $t7, 82 # 'R'
	beq $v0, $t7, case3GOOD
	li $t7, 83 # 'S'
	beq $v0, $t7, case3GOOD
	li $t7, 84 # 'T'
	beq $v0, $t7, case3GOOD
	li $t7, 85 # 'U'
	beq $v0, $t7, case3GOOD
	li $t7, 86 # 'V'
	beq $v0, $t7, case3GOOD
	li $t7, 87 # 'W'
	beq $v0, $t7, case3GOOD
	li $t7, 88 # 'X'
	beq $v0, $t7, case3GOOD
	li $t7, 89 # 'Y'
	beq $v0, $t7, case3GOOD
	li $t7, 90 # 'Z'
	beq $v0, $t7, case3GOOD

	#otherwise, enter a different number
	j case3ERROR
	

case3GOOD:

	#Simply return
	jr $ra

case3ERROR:
	
	li $v0, 4 # print a prompt
    	la $a0, case3wronginput # That number is not valid and was ignored.
    	syscall

	#if the number is not valid, have the user input the number again
	j case3inputvalidation


isthenumbernegative:
	
	
	li $t8, 32768 # 0x8000 
	and $t7, $t0, $t8
	#if the first digit is 1, it is negative and needs to branch
	bnez  $t7, thenumberisnegative
	
	
	li $v0, 4 # print a prompt
    	la $a0, positivesign # "+"
    	syscall
	
	jr $ra

thenumberisnegative:



	li $t8, 65535
	subi $t0, $t0, 1 
	sub $t0, $t8, $t0
	
	li $v0, 4 # print a prompt
    	la $a0, negativesign # "-"
    	syscall
	
	# $ra will be the same as isthenumbernegative
	jr $ra

ERROR:
	li $v0, 4 # print a prompt
    	la $a0, wronginput # The number you entered is invalid
    	syscall
	j main
