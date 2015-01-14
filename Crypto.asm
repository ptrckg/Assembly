########### CRYPTO.asm #########################
# Pat Gannon                                   #
# CRYPTO.asm                                   #
# Description                                  #
#     Program Encrypts/Decrypts messages       #
#     using the Caesar Cipher                  #
# Program Logic                                #
# 1.Display intro messages                     #
# 2.Input Encrypt/Decrypt mode                 #
# 3.Input Offset 1-26                          #
# 4.Go to appropriate mode                     #
# 5.Encrypt or Decrypt message                 #
# 6.Display resulting messag                   #
# 7.Ask user if they wish to go again          #
################################################


         .text
         .globl __start


__start:


Intro:
         la $a0,intro1       # display Encrypt/Decrypt message
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string

         la $a0,intro2       # display Encrypt/Decrypt message
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string

         la $a0,intro3       # display Encrypt/Decrypt message
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string

         la $a0,intro4       # display Encrypt/Decrypt message
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string

         la $a0,intro5       # display Encrypt/Decrypt message
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string

         la $a0,intro6       # display Encrypt/Decrypt message
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string

         la $a0,intro7       # display Encrypt/Decrypt message
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string

Check:
         la $t0,msg          # load the address of name into t0
         lb $t1,($t0)        # load the character from the name into t1
         beq $t1,$0,Mode     # branch to input if name is null
         la $t7,result       # load the address of first into t7



Scrub:   
         lb $t2,($t0)        # load the character from the msg into t2
	 sub $t3,$t2,10      # is that character an enter key
	 beq $t3,$0,Mode     # if it is an enter exit the loop
         sb $0,($t0)         # store the character 0 into msg
	 addi $t0,$t0,1      # t0 <- t0+1

         lb $t6,($t7)        # load the character from the result into t6
         sb $0,($t7)         # store the character 0 into result
	 addi $t7,$t7,1      # t7 <- t7+1

         j Scrub             # jump to the loop



Mode:
         la $a0,p5           # display Encrypt/Decrypt message
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string

         la $a0,p6           # display Encrypt/Decrypt message
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string

	 la $a0,which        # load the address of the msg into a0
	 li $a1,20           # load the number 20 into a1
	 la $v0,8            # load the number 8 into v0
	 syscall	     # syscall

         la $t4,which        # load address of mode input
         lb $t3,($t4)        # load byte from mode input

         beq $t3,49,Offset   # if its 1 branch to Offset
         beq $t3,50,Offset   # if its 2 branch to offset
         j Mode              # jump to loop



Offset:
         la $a0,p7           # display Offset message
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string

         li $v0,5            # input the offset and store it in offset
         syscall
         sw $v0,offs

         lw $s1,offs         # load the offset into s1
         
         blt $s1,1,Offset    # is it >1
         bgt $s1,26,Offset   # is it <26



Input:
         la $a0,p1           # display "Please enter the message: "
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string

	 la $a0,msg          # load the address of the msg into a0
	 li $a1,40           # load the number 20 into a1
	 la $v0,8            # load the number 8 into v0
	 syscall	     # syscall 

         la $a0,p2           # display "You entered: "
         li $v0,4            # a0 = address of string
         syscall             # v0 = 4, indicates display a string 

         la $a0,msg          # Display the name
         li $v0,4            # a0 = address of string
         syscall             # v0 = 4, indicates display a string

	 la $t0,msg          # load the address of the msg into t0
	 la $t1,result       # load the address of the result into t1


         beq $t3,49,Encrypt  # go to appropriate mode
         beq $t3,50,Decrypt  # go to appropriate mode



Encrypt: 
         lb $t2,($t0)        # load the character from the name into t2
	 sub $t3,$t2,10      # is that character an enter key
	 beq $t3,$0,loopend1 # if it is an enter exit the loop
         blt $t2,97,ESkip    # skip invalid chars
         bgt,$t2,122,ESkip   # skip invalid chars
         add $t7,$t2,$s1     # add offset to original ascii value
         bgt $t7,122,EInit   # if its > 122 go to wrap
         add $t2,$t2,$s1     # Commence Encryption
         sb $t2,($t1)        # store the character in t2 into result
	 addi $t0,$t0,1      # t0 <- t0+1
	 addi $t1,$t1,1	     # t1 <- t1+1
	 j Encrypt	     # jump to the loop

ESkip:
         sb $t2,($t1)        # store the character in t2 into result
         addi $t0,$t0,1      # iterate through t0
         addi $t1,$t1,1      # iterate through t1
         j Encrypt

EInit:
         move $t7,$0         # t0 -> t7
         move $s2,$s1        # s1 -> s2
         move $t6,$t2        # t2 -> t6

EWrap1:
         bgt $t6,122,EWrap2  # if exceeds a-z alphabet go to next step
         add $t6,$t6,1       # iterate through t6
         sub $s2,$s2,1       # stay in step with t6
         j EWrap1

EWrap2:
         mul $t6,$t6,$0      # clear out t6
         add $t6,$t6,97      # t6 = 97

EWrap3:
         beqz $s2,EWrap4     # if the offset has been completed
         add $t6,$t6,1       # iterate through t6
         sub $s2,$s2,1       # stay in step with t6
         j EWrap3
         
EWrap4:
         sb $t6,($t1)        # store encrypted character into result
         add $t0,$t0,1       # iterate through original message
         add $t1,$t1,1       # iterate through result
         j Encrypt



Decrypt: 
         lb $t2,($t0)        # load the character from the name into t2
	 sub $t3,$t2,10      # is that character an enter key
	 beq $t3,$0,loopend2 # if it is an enter exit the loop
         blt $t2,97,DSkip    # skip invalid chars
         bgt,$t2,122,DSkip   # skip invalid chars
         sub $t7,$t2,$s1     # sub offset from original ascii value
         blt $t7,97,DInit    # if its <97 go to wrap
         sub $t2,$t2,$s1     # Commence Decryption
         sb $t2,($t1)        # store the character in t2 into result
	 addi $t0,$t0,1      # t0 <- t0+1
	 addi $t1,$t1,1	     # t1 <- t1+1
	 j Decrypt	     # jump to the loop

DSkip:   
         sb $t2,($t1)        # store the character in t2 into result
         addi $t0,$t0,1
         addi $t1,$t1,1
         j Decrypt

DInit:
         move $t7,$0         # t0 -> t7
         move $s2,$s1        # s1 -> s2
         move $t6,$t2        # t2 -> t6

DWrap1:
         blt $t6,97,DWrap2   # if exceeds a-z alphabet go to next step
         sub $t6,$t6,1       # iterate through t6
         sub $s2,$s2,1       # stay in step with t6
         j DWrap1

DWrap2:
         mul $t6,$t6,$0      # clear out t6
         add $t6,$t6,122     # t6 = 122

DWrap3:
         beqz $s2,DWrap4     # if the offset has been completed
         sub $t6,$t6,1       # iterate through t6
         sub $s2,$s2,1       # stay in step with t6
         j DWrap3
         
DWrap4:
         sb $t6,($t1)        # store decrypted character into result
         add $t0,$t0,1       # iterate through original message
         add $t1,$t1,1       # iterate through result
         j Decrypt


loopend1:
         la $a0,p3           # display "Encrypted: "
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string
         j loopend3



loopend2:
         la $a0,p4           # display "Decrypted: "
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string



loopend3: 
         la $a0,result       # display result
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string



Continue:
         la $a0,while        # display "Would you like to enter another message? (y/n) "
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string

	 la $a0,again        # load the address of the input into a0
	 li $a1,5            # load the number 1 into a1
	 la $v0,8            # load the number 8 into v0
	 syscall	     # syscall

         la $t7,again        # load the address of again into t7
         lb $t6,($t7)        # load the character from again into t6
         sub $t5,$t6,121     # is it the y character
         beq $t5,$0,Check    # branch to beginning of program if it is y

         sub $t5,$t6,110
         bne $t5,$0,Continue

         la $a0,end          # end of program string
         li $v0,4            # a0 = address of string
         syscall             # v0= 4, indicates display a string 

         li $v0,10           # End Of Program	
         syscall             # Call to system


        .data

which:  .space 5
again:  .space 5
msg:    .space 40
result: .space 40
offs:   .word 15

intro1: .asciiz "\n\nWelcome to the Encryptatron3000!\n\n"
intro2: .asciiz "This program uses the Caesar Cipher to Encrypt and\n"
intro3: .asciiz "Decrypt messages. Simply choose whether you're Encrypting\n"
intro4: .asciiz "or Decrypting a message. Then choose the appropriate offset.\n"
intro5: .asciiz "It's that simple!\n\n"
intro6: .asciiz "NOTE: This program only uses the lowercase a-z alphabet.\n"
intro7: .asciiz "      Any other chars you enter won't be changed!"
while:  .asciiz "\n\nWould you like to enter another message? (y/n) "
p1:     .asciiz "\nPlease enter the message: "
p2:     .asciiz "\nOriginal:  "
p3:     .asciiz "Encrypted: "
p4:     .asciiz "Decrypted: "
p5:     .asciiz "\n\nPress (1) to Encrypt your message\n"
p6:     .asciiz "Press (2) to Decrypt your message\n\n"
p7:     .asciiz "\nPlease enter the offset (1-26): "
end:    .asciiz "\nEND TRANSMISSION"



############## Output ################################
#  
#
# Welcome to the Encryptatron3000!
#
# This program uses the Caesar Cipher to Encrypt and
# Decrypt messages. Simply choose whether you're Encrypting
# or Decrypting a message. Then choose the appropriate offset.
# It's that simple!
#
# NOTE: This program only uses the lowercase a-z alphabet.
#     Any other chars you enter won't be changed!
#
# Press (1) to Encrypt your message
# Press (2) to Decrypt your message
#
# 1
#
# Please enter the offset (1-26): 14
#
# Please enter the message: attack at dawn
#
# Original:  attack at dawn
# Encrypted: ohhoqy oh rokb
#
# Would you like to enter another message? (y/n) y
#
#
# Press (1) to Encrypt your message
# Press (2) to Decrypt your message
#
# 2
#
# Please enter the offset (1-26): 14
#
# Please enter the message: ohhoqy oh rokb
#
# Original:  ohhoqy oh rokb
# Decrypted: attack at dawn
#
# Would you like to enter another message? (y/n) n
#
# END TRANSMISSION
#####################################################