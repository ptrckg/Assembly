########### nameDisplay.asm ####################
# Pat Gannon                                   #
# nameDisplay.asm                              #
# Description                                  #
#     Program to convert 'Last, First' name    #
#     format to 'First Last'                   #
# Program Logic                                #
# 1.Input name as last,first                   #
# 2.Move first name to seperate variable       #
# 3.Move last name to seperate variable        #
# 4.Display first name                         #
# 5.Display space character                    #
# 6.Display last name                          #
# 7.Ask user to enter another name             #
# 8.Branch to beginning of program if yes      #
################################################


        .text
        .globl __start
__start:

check:  la $t0,name         # load the address of name into t0
        lb $t1,($t0)        # load the character from the name into t1
        beq $t1,$0,input    # branch to input if name is null
        la $t7,first        # load the address of first into t7
        la $t5,last         # load the address of last into t5

scrub:  lb $t2,($t0)        # load the character from the name into t2
	sub $t3,$t2,10      # is that character an enter key
	beq $t3,$0,input    # if it is an enter exit the loop
        sb $0,($t0)         # store the character 0 into name
	addi $t0,$t0,1      # t0 <- t0+1

        lb $t6,($t7)        # load the character from the first into t6
        sb $0,($t7)         # store the character 0 into first
	addi $t7,$t7,1      # t7 <- t7+1

        lb $t4,($t5)        # load the character from the last into t4
        sb $0,($t5)         # store the character 0 into last
	addi $t5,$t5,1      # t5 <- t5+1
        j scrub             # jump to the loop

input:  la $a0,p1           # display "Please enter a name: "
        li $v0,4            # a0 = address of string
        syscall             # v0= 4, indicates display a string

	la $a0,name         # load the address of the name into a0
	li $a1,20           # load the number 20 into a1
	la $v0,8            # load the number 8 into v0
	syscall	            # syscall 

        la $a0,p2           # display "You entered: "
        li $v0,4            # a0 = address of string
        syscall             # v0 = 4, indicates display a string 

        la $a0,name         # Display the name
        li $v0,4            # a0 = address of string
        syscall             # v0 = 4, indicates display a string

	la $t0,name         # load the address of the name into t0
	la $t1,last         # load the address of the last name into t1

L_loop:	lb $t2,($t0)        # load the character from the name into t2
	sub $t3,$t2,44      # is that character a comma
	beq $t3,$0,loopend1 # if it is a comma exit the loop
        sb $t2,($t1)        # store the character in t2 into last
	addi $t0,$t0,1      # t0++ move pointer over one
	addi $t1,$t1,1	    # t1 <- t1+1
	j L_loop	    # jump to the loop

loopend1:
        addi $t0,$t0,1      # t0++ move pointer to first name
        la $t1, first       # load the address of the first name into t1

F_loop:	lb $t2,($t0)        # load the character from the name into t2
	sub $t3,$t2,10      # is that character an enter key
	beq $t3,$0,loopend2 # if it is an enter exit the loop
        sb $t2,($t1)        # store the character in t2 into last
	addi $t0,$t0,1      # t0 <- t0+1
	addi $t1,$t1,1	    # t1 <- t1+1
	j F_loop	    # jump to the loop

loopend2:
        la $a0,p3           # display "Result: "
        li $v0,4            # a0 = address of string
        syscall             # v0= 4, indicates display a string

        la $a0,first        # display first name
        li $v0,4            # a0 = address of string
        syscall             # v0= 4, indicates display a string

        la $a0,space        # display a space
        li $v0,4            # a0 = address of string
        syscall             # v0= 4, indicates display a string

        la $a0,last         # display last name
        li $v0,4            # a0 = address of string
        syscall             # v0= 4, indicates display a string

        la $a0,while        # display "Would you like to enter another name? (y/n) "
        li $v0,4            # a0 = address of string
        syscall             # v0= 4, indicates display a string

	la $a0,again        # load the address of the input into a0
	li $a1,5            # load the number 1 into a1
	la $v0,8            # load the number 8 into v0
	syscall	            # syscall

        la $t7,again        # load the address of again into t7
        lb $t6,($t7)        # load the character from again into t6
        sub $t5,$t6,121     # is it the y character
        beq $t5,$0,check    # branch to beginning of program if it is y

        la $a0,end          # end of program string
        li $v0,4            # a0 = address of string
        syscall             # v0= 4, indicates display a string 

        li $v0,10           # End Of Program	
        syscall             # Call to system

        .data
again:  .space 5
name:   .space 20
first:  .space 20
last:   .space 20
while:  .asciiz "\n\nWould you like to enter another name? (y/n) "
p1:     .asciiz "Please enter a name: last,first: "
p2:     .asciiz "You entered: "
p3:     .asciiz "Result: "
end:    .asciiz "\nEND OF PROGRAM"
space:  .asciiz " "


############## Output ###############################
#  Please enter a name: last,first: Jones,Bill      #
#  You entered: Jones,Bill                          #
#  Result: Bill Jones                               #
#                                                   #
#  Would you like to enter another name? (y/n) y    #
#  Please enter a name: last,first: Yao,Li          #
#  You entered: Yao,Li                              #
#  Result: Li Yao                                   #
#                                                   #
#  Would you like to enter another name? (y/n) y    #
#  Please enter a name: last,first: Smith,John      #
#  You entered: Smith,John                          #
#  Result: John Smith                               #
#                                                   #
#  Would you like to enter another name? (y/n) y    #
#  Please enter a name: last,first: Lee,Stan        #
#  You entered: Lee,Stan                            #
#  Result: Stan Lee                                 #
#                                                   #
#  Would you like to enter another name? (y/n) y    #
#  Please enter a name: last,first: L,F             #
#  You entered: L,F                                 #
#  Result: F L                                      #
#                                                   #
#  Would you like to enter another name? (y/n) n    #
#                                                   #
#  END OF PROGRAM                                   #
#                                                   #
#####################################################