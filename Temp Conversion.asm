

# Phillip Yellott
# 3340.001

# Homework 3 submision

.data
# constants
five: .float 5.0
nine: .float 9.0
tt2:  .float 32.0

# strings
Chooseprompt: .asciiz "\nF or C? "
prompt0: .asciiz "\nWhat is degree in F: "
prompt1: .asciiz "\nWhat is degree in C: "
res0:   .asciiz "\nDegree in C is: "
res1:	.asciiz "\nDegree in F is: "
wronginput: .asciiz "\nInput is invalid!"

# program
.text
main: 
     li $v0, 4 # print first prompt
     la $a0, Chooseprompt # "F or C?"
     syscall
	
     li $v0, 12 # read a single char result will be in $f0
     syscall
     
     li $s0, 67 #mips ascii C
     li $s1, 99 #mips ascii c somethinng is wrong
     
     li $s2, 70 #mips ascii F
     li $s3, 102 #mips ascii f somethinng is wrong
     
     #branch to c2f if user entered 'c' or 'C'
     beq $v0, $s0, c2f 
     beq $v0, $s1, c2f 
     
     #branch to f2c if user entered 'f' or 'F'
     beq $v0, $s2, f2c
     beq $v0, $s3, f2c
     
     
     # if the user entered a character that was not one of the 4 above, do the folowing
     
     li $v0, 4 # print string
     la $a0, wronginput # "Input is invalid!"
     syscall
  
     j main # loop back to main 

     
f2c:
     li $v0, 4 # prompt for F number
     la $a0, prompt0 # "What is degree in F: "
     syscall 
     
     li $v0, 6 # read a single fp number, result will 
     		# be in $f0
     syscall
  
     # Math 
     lwc1  $f16, five #load number
     lwc1  $f18, nine # load number
     div.s $f16, $f16, $f18 # 5/9 in $f16
     lwc1  $f18, tt2 # load number
     sub.s $f18, $f0, $f18 # F - 32.0, f18 holds inputted value - 32
     mul.s $f0,  $f16, $f18 # mult 
     
     
     li $v0, 4 # print a string result set
     la $a0, res0 # "result in C:"
     syscall
     
     li $v0, 2 # print a float
     mov.s $f12, $f0 # move result (C) to $f12
     syscall
     
     #loop back to main
     j main
     
c2f:
     li $v0, 4 # print string
     la $a0, prompt1 # "What is degree in C: "
     syscall 
     
     li $v0, 6 # read a single fp number, result will 
     		# be in $f0
     syscall
     
     # Math
     lwc1  $f16, five
     lwc1  $f18, nine
     div.s $f16, $f18, $f16 # 9/5 in $f16
     lwc1  $f18, tt2
     mul.s $f16,  $f16, $f0 # f16 = (9/5) * user input
     add.s $f0, $f16, $f18 
     
     li $v0, 4 # print a string 
     la $a0, res1 # "result in F:"
     syscall
     
     li $v0, 2 # print a float
     mov.s $f12, $f0 # move result (C) to $f12
     syscall
     
     
     #loop back to main
     j main
      
		
