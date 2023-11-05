#
# Program name: calcGrades.s
# Author: Jack Kurowski
# Date: 10/29/2023
# Purpose: This program outputs whether the user entered number is prime
#          until they want to stop (enter -1)
#
.text
.global main
main:

   # Save return to os on stack
   SUB sp, sp, #4
   STR lr, [sp, #0]

   # Prompt For An Input
   LDR r0, =prompt1
   BL  printf

   #Scanf
   LDR r0, =input1
   LDR r1, =number
   BL scanf
   LDR r1, =number
   LDR r1, [r1]

   StartWhile1:
   # check while condition
      MOV r0, r1
      MOV r1, #-1
      CMP r0, r1
   # end check cond
   BEQ EndWhile1
      # while block
         # check if input is valid
         MOV r1, #2
         CMP r0, r1
         BGT Else1 
         # if block
            LDR r0, =errMsg
            BL printf
         # end if block
         B EndIf1
         Else1: 
         # else block
            # Check if number is prime
            BL checkPrime

         # end else block
         EndIf1: 
         # end if/else
         # Get another input

         # Prompt For An Input
         LDR r0, =prompt1
         BL  printf
         #Scanf
         LDR r0, =input1
         LDR r1, =number
         BL scanf
         LDR r1, =number
         LDR r1, [r1]


      
      # end while block
      B StartWhile1
   EndWhile1:



   # Return to the OS
   LDR lr, [sp, #0]
   ADD sp, sp, #4
   MOV pc, lr

.data
   number: .word 0
   prompt1: .asciz "Enter a number\n"
   errMsg: .asciz "Your input must either be greater than 2 or equal to -1!!\nEnter another number!\n"
   input1: .asciz "%d"
#End main


# Function checkPrime
# checkPrime takes a number  and prints out whether it is prime
# Inputs:
#    r0 - number
# Variables During Main Block
#    r4 - input num
#    r5 - dividing number that gets decremented on each check
#    r6 - boolean variable notPrime
# Outputs:
#    no outputs - print info only



.text
.global checkPrime

checkPrime:
   # Push
   SUB sp, sp, #16
   STR lr, [sp, #0]
   STR r4, [sp, #4]
   STR r5, [sp, #8]
   STR r6, [sp, #12]

   # Store variables that need to be retained when branching in regs > 3
   MOV r4, r0
   SUB r5, r4, #1
   MOV r6, #0

   StartWhile2:
   # check while condition
      # Is the divisor 1 or lower?
      MOV r0, #0
      MOV r3, #1
      CMP r5, r3
      MOVLE r0, #1

      # or the above with r6 (notPrime)
      ORR r1, r0, r6
      CMP r1, #1 
   # end check on while cond
   BEQ EndWhile2
      # while block
      # Check if num % testNum == 0
      # if x/y * y == x, then no truncation during division, aka evenly divided
      MOV r0, r4
      MOV r1, r5
      BL __aeabi_idiv

      MUL r1, r0, r5
      CMP r4, r1
      # Not equal means not prime, bc there was some truncation during division
      BNE Else2 
      # if block
         MOV r6, #1
      # end if block
      B EndIf2
      Else2: 
      # else block
         SUB r5, r5, #1
      # end else block
      EndIf2: 
   
   # end while block
   B StartWhile2
   EndWhile2:

   # Check if num is prime
   MOV r1, r4
   CMP r6, #1
   BEQ Else 
   # if block
      LDR r0, =isPrime
      BL printf
   # end if block
   B EndIf
   Else: 
   # else block
      LDR r0, =notPrime
      BL printf
   # end else block
   EndIf: 

   # Pop
   LDR lr, [sp, #0]
   LDR r4, [sp, #4]
   LDR r5, [sp, #8]
   LDR r6, [sp, #12]
   ADD sp, sp, #16
   MOV pc, lr

.data
   isPrime: .asciz "%d is prime!\n"
   notPrime: .asciz "%d is not prime!\n"

# end checkPrime
