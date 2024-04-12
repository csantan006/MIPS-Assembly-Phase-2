.data
     A: .word 6, 34, -7, 3, 0, -20, 6, -2, 10
     B: .word 3, -1, 2, -9, -1, 4, 6, 11, 4
     myString: .asciiz "Array elements sum = " 
.text
addi $t4, $zero, 0    # Initial sum
addi $t0, $zero, 0    # i = 0, index value for array, If we call back to this label, we reset the index value.
addi $t3, $zero, 0    # loop counter. If we call back to this label, we reset the loop value.

Main:
     beq $t3, 9, Reset # for (int i = 0; i < 9)
     lw $t1, A($t0) 	    # load the value of A[i] to t1
     lw $t2, B($t0) 	    # load value of B[i] to t2
     add $t1, $t1, $t2     # compute sum of A[i] + {i} to t1
     sw $t1, A($t0) 	    # save t1 to the address of A[i] in memory
     jal Print 		    # Print for each iteration
     addi $t0, $t0, 4 	    # Update array index
     addi $t3, $t3, 1 	    # Update loop counter (i++)
     j Main 	    # repeat until loop counter is 9, then jump to Reset
     
Print:
    # Print values of the main for loop
     addi $v0, $zero, 1 # Make a service call to print an integer
     add $a0, $t1, $zero # Print the number
     syscall
     addi $v0, $zero, 11 # Make a serive call to print a character
     addi $a0, $zero, 0xA # Print a new line
     syscall
     jr $ra # Jump back to the next statement in the main loop after the print call

Sum:
     beq $t3, 9, Print_String    # for (int i = 0; i < 9)
     lw $t1, A($t0) 	    # load the value of the new A[i] to t1
     lw $t2, B($t0) 	    # load value of B[i] to t2
     add $t1, $t1, $t2     # compute sum of t1 and t2, store result to t1
     add $t4, $t4, $t1     # add old sum and t1, store the new sum to t4
     addi $t0, $t0, 4 	    # Update array index
     addi $t3, $t3, 1      # Update loop counter (i++)
     addi $t4, $t4, 1      # increment sum to sum + 1
     j Sum          # repeat until loop counter is 9, the jump to the String
     
Reset:
# At this point in the code, we reset all of our registers for the next for loop.
addi $t0, $zero, 0  
addi $t1, $zero, 0  
addi $t2, $zero, 0
addi $t3, $zero, 0 
j Sum

Print_String:
     # Print: Array elements sum =;
     addi $v0, $zero, 4 # Service call to print a string
     la $a0, myString
     syscall
     j Print_Sum
     
Print_Sum:
    # Print sum which is held in $t4
     addi $v0, $zero, 1 # Print the sum
     add $a0, $t4, $zero 
     syscall
     addi $v0, $zero, 11 # Endline
     addi $a0, $zero, 0xA
     syscall
     j done

done:
