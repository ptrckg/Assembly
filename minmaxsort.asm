########### minmaxsort.asm #####################
# Pat Gannon                                   #
# minmax.asm                                   #
# Description                                  #
#     User inputs length of array, all numbers #
#     in the array, then the list is sorted    #
#     and the lowest and highest               #
#     numbers in the array are found           #
# Program Logic                                #
# 1. prompt to enter size of array             #
# 2. loop through and enter each array num     #
# 3. display entire array                      #
# 4. loop through array and find low/high nums #
# 5. display lowest number                     #
# 6. display highest number                    #        
# 7. bubble sort                               #
# 8. display sorted list                       #
################################################

        .text
        .globl __start
__start:
        jal read            # jump and link to read subprogram
        jal write           # jump and link to write subprogram
        jal comp            # jump and link to compute subprogram
        jal sort            # jump and link to sort subprogram
        jal write           # jump and link to write subprogram
        jal redo            # jump and link to redo subprogram

read:   la $a0,p3           # Display "Enter the number of numbers in the array: "
        li $v0,4            # a0 = address of message
        syscall             # v0 = 4 which indicates display a string

        li $v0,5            # input the count and store it in count
        syscall
        sw $v0,count

        la $t0,array        # initialize t0 to the address of the array
        lw $t1,count        # t1 <- count

rloop:  la $a0,p4           # Display "Enter number: "
        li $v0,4            # a0 = address of message
        syscall             # v0 = 4 which indicates display a string

        li $v0,5            # input the number
        syscall
        sw $v0,($t0)        # store it in the array
        add $t0,$t0,4       # t0 <- t0+4 (increment the word address)       
        add $t1,$t1,-1      # decrement count t1--
        bnez $t1,rloop      # if (t1 != 0) loop branch to rloop
        jr $ra              # return to main

write:  la $t0,array        # t0 = address of array
        lw $t1,count        # t1 = count
        lw $t2,($t0)        # t2 = a[0]
        b rstrng

 
wloop:  lw $t2,($t0)        # t2 = a[0]
        move $a0,$t2        # Display the current number
        li $v0,1
        syscall

        add $t0,$t0,4       # move pointer ahead to next array element a[1]
        add $t1,$t1,-1      # decrement counter to keep in step with array
        bnez $t1,cloop      # if (t1 != 0) loop branch to cloop
        jr $ra              # return to main

cloop:  la $a0,comma        # Display comma
        li $v0,4            # a0 = address of message
        syscall             # v0 = 4 which indicates display a string
        j wloop

rstrng: la $a0,result       # Display "Results:"
        li $v0,4
        syscall
        j wloop

loop:   lw $t4,($t0)        # t4 = next element in array
        bge $t4,$t2,notMin  # if array element is  >= min goto notMin

        move $t2,$t4        # min = a[i]
        j notMax

notMin: ble $t4,$t3,notMax  # if array element is <= max goto notMax
        move $t3,$t4        # max = a[i]

notMax: add $t1,$t1,-1      # t1 --  ->  counter --
        add $t0,$t0,4       # increment counter to point to next word
        bnez $t1,loop

        la $a0,p1           # Display "The minimum number is "
        li $v0,4            # a0 = address of message
        syscall             # v0 = 4 which indicates display a string	

        move $a0,$t2        # Display the minimum number 
        li $v0,1
        syscall

        la $a0,p2           # Display "The maximum number is "
        li $v0,4            # a0 = address of message
        syscall             # v0 = 4 which indicates display a string

        move $a0,$t3        # Display the maximum number 
        li $v0,1
        syscall
    
        jr $ra

redo:   la $a0,while        # display "Would you like to enter more numbers? (y/n) "
        li $v0,4            # a0 = address of string
        syscall             # v0= 4, indicates display a string

        la $a0,again        # load the address of the input into a0
        li $a1,5            # load the number 1 into a1
        la $v0,8            # load the number 8 into v0
        syscall	            # syscall

        lb $t5,again        # load the character from again into t6
        sub $t6,$t5,121     # is it the y character
        beq $t6,$0,__start  # branch to beginning of program if it is y

        la $a0,crlf         # Display "cr/lf"
        li $v0,4            # a0 = address of message
        syscall             # v0 = 4 which indicates display a string

        li $v0,10           # End Of Program
        syscall

comp:   la $t0,array        # t0 = address of array
        lw $t1,count        # t1 = count, exit loop when it goes to 0
        lw $t2,($t0)        # t2 = min = a[0] (initialization)
        lw $t3,($t0)        # t3 = max = a[0] (initialization)
        add $t0,$t0,4       # move pointer ahead to next array element a[1]
        add $t1,$t1,-1      # decrement counter to keep in step with array
        j loop


sort:   lw $t1,count        # t1 = count, exit loop when it goes to 0
        add $t1,$t1,-1      # t1--
        add $t7,$0,$0

        la $t0,array        # load address of array into t0


sloop:  lw $t2,($t0)        # load current element of array
        lw $t3,4($t0)       # load next element of array
        bgt $t2,$t3,swap    # if current is greater go to swap
        add $t0,$t0,4       # go to next element in array
        add $t1,$t1,-1      # t1--
        beqz $t1,check      # if t1 = 0 this passthrough is done
        j sloop             # jump to loop
        
swap:   sw $t2,4($t0)       # swap t2 and t3
        sw $t3, ($t0)       # swap t2 and t3
        add $t7,$t7,1       # flag noting that swap has been made
        add $t0,$t0,4       # go to next element in array
        add $t1,$t1,-1      # t1--
        beqz $t1,check      # if t1 = 0 this passthrough is done
        j sloop

check:  beqz $t7,end        # if t7 = 0 then arrat is sorted
        j sort

end:    jr $ra              # return to main



        .data
array:  .space 100
again:  .space  5
count:  .word 15
p1:     .asciiz "\n\nThe minimum number is "
p2:     .asciiz "\nThe maximum number is "
p3:     .asciiz "\nEnter the number of numbers in the array: "
p4:     .asciiz "\nEnter number: "
comma:  .asciiz ", "
result: .asciiz "\n\nResults:\n\n"
crlf:   .asciiz "\n"
while:  .asciiz "\n\nWould you like to enter another set of numbers? (y/n) "

################ Output ################################
#                                           
# Enter the number of numbers in the array: 3
#
# Enter number: 3
#
# Enter number: 2
#
# Enter number: 1
#
# Results:
#
# 3, 2, 1
#
# The minimum number is 1
# The maximum number is 3
#
# Results:
#
# 1, 2, 3
#
# Would you like to enter another set of numbers? (y/n) y
#
# Enter the number of numbers in the array: 4
#
# Enter number: 4
#
# Enter number: 3
#
# Enter number: 2
#
# Enter number: 1
#
# Results:
#
# 4, 3, 2, 1
#
# The minimum number is 1
# The maximum number is 4
#
# Results:
#
# 1, 2, 3, 4
#
# Would you like to enter another set of numbers? (y/n) n
##########################################################
