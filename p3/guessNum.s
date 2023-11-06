# Program info

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
   LDR r1, [r1, #0]


   MOV r0, r1
   BL genRand
   MOV r5, r0  // randNum in r5
   
   MOV r6, #0  // isGuessed is false
   MOV r7, #-2 // initialize guess to -2
   MOV r8, #0 // nGuess


   StartWhile:
   # check while condition
      #check if guessed
      MOV r1, #0
      CMP r6, #1
      MOVEQ r1, #1

      # check quit
      MOV r2, #0
      CMP r7, #-1
      MOVEQ r2, #1

      ORR r1, r1, r2
      CMP r1, #1
   BEQ EndWhile

      # Prompt For An Input
      LDR r0, =prompt2
      BL  printf

      #Scanf
      LDR r0, =input1
      LDR r1, =number
      BL scanf
      LDR r1, =number
      LDR r1, [r1, #0]

      MOV r7, r1      // store guess in r7
      ADD r8, r8, #1  // increment nGuess


      #compare to -1
      CMP r7, #-1
      BNE Elif1 
      # if block
         LDR r0, =quitMsg
         SUB r1, r8, #1
         BL printf
         B EndIf
      # end if block
      
      Elif1:
      # use comp to -1
      BGT Elif2 
      # if block
         LDR r0, =errMsg
         SUB r8, r8, #1
         BL printf
         B EndIf
      # end if block
      Elif2:
      # comp guess to num
      CMP r7, r5
      BNE Elif3 
      # if block
         LDR r0, =correctMsg
         MOV r1, r8
         BL printf
         MOV r6, #1
         B EndIf
      # end if block
      Elif3:
      # use comp to guess
      BLT Else 
      # if block
         # guess was too high
         LDR r0, =highMsg
         BL printf
         B EndIf
      # end if block
      Else: 
      # else block
         # guess was too low
         LDR r0, =lowMsg
         BL printf
      # end else block
      EndIf: 
      # end if/else
   B StartWhile
   # end while block
   EndWhile:
   
   # Return to the OS
   LDR lr, [sp, #0]
   ADD sp, sp, #4
   MOV pc, lr

.data
   number: .word 0
   prompt1: .asciz "Enter a max for guess range\n"
   prompt2: .asciz "Enter a guess!!!\n"
   errMsg: .asciz "Your input must either be -1 to quit or non-negative!\n"
   quitMsg: .asciz "After %d guesses, you gave up!?\n"
   highMsg: .asciz "Guess was high\n"
   lowMsg: .asciz "Guess was low\n"
   correctMsg: .asciz "You got it after %d guesses!\n"
   input1: .asciz "%d"
#End main

.text
.global genRand

genRand:

   # Push
   SUB sp, sp, #16
   STR lr, [sp, #0]
   STR r4, [sp, #4]
   STR r5, [sp, #8]
   STR r6, [sp, #12]

   # Store variables that need to be retained when branching in regs > 3
   MOV r4, r0  // upper bound

   # put random num in r0
   BL rand
   MOV r5, r0

   # randInRange = origRand - (orig rand / upper bound * upper bound)
   # this is equivalent to rand = origRand % upperBound 
   MOV r1, r4  // upper bound is divisor
   BL __aeabi_idiv
   MUL r0, r0, r4 // mul quotient by upper bound 
   SUB r0, r5, r0 // sub clean mult num from orig rand

   # Pop
   LDR lr, [sp, #0]
   LDR r4, [sp, #4]
   LDR r5, [sp, #8]
   LDR r6, [sp, #12]
   ADD sp, sp, #16
   MOV pc, lr

.data
