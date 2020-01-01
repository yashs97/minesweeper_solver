#     Minesweeper
#
#  Your Name: YASH SHAH   
#  Date:  15th OCTOBER 2018
.data
WorkingField:  .word   185273099, 185273099, 168495883, 168430090, 185207306, 168430091, 168430090, 168495882, 168430090, 185207306, 168430091, 168430090, 168495882, 168430090, 185207306, 168430091, 168430090, 168495882, 168430090, 185207306, 168430091, 168430090, 185273098, 185273099, 185273099

# value of 11 in 10x10 WorkingField means the coordinate doesn't exist in 8x8 minefield
# values for through 11-88 are initialized to 10 in 10x10 working field denoting unopened neighbors
# value of 9 indicates flag or mine. Mines are assigned 9 for convenience 
# value of 12 for a box indicates all of its neighbors are flagged/opened. No further compuatation is required for that BOX.

Neighbors: .word 0,0  # coordinates of neighbors for a box are stored here

.text

MineSweep: swi   567    
           addi  $5,$0,10    # VALUE of UNOPENED SQUARES
           addi  $7,$0,9     # FLAGGED SQUARE
           addi  $10,$0,11   # $10 is the COUNTER
           addi  $19,$0,0    # $19 == 0, time for NECESSARY GUESS
           addi  $20,$0,0    # $20 will hold MINECOUNT $20 == $1,Exit

# ======== First guess at position 11 of the 10x10 array==================

           j     Guess3    # First guess condition is made by Guess3

MC1:       sb    $7,WorkingField($10)   # When a necessary guess is a mine
           addi  $20,$20,1   # MineCount++
           beq   $20,$1,Exit
           addi  $10,$10,-11

# ================ Code to solve the project ==================

Code:      slti  $11,$10,89             # counter can't be greater than 88
           beq   $11,$0,OuterLoop
Code2:     lb    $9,WorkingField($10)   # $9 holds the value of the current element 
           slti  $11,$9,9               # current value must be less than 9
           beq   $11,$0,Loop

# ============= Neighbor Detection =======================

# Coordinates of all neighbors are stored in Neighbors

DN:         addi    $2,$0,0  # COunt of Mines/Flag in the surrounding neighbors
            addi    $3,$0,0  # COunt of Unopened neighboring boxes

            addi    $21,$10,-10   #UP
            sb      $21,Neighbors($0)

            addi    $4,$0,1
            addi    $21,$10,10    #DOWN
            sb      $21,Neighbors($4)

            addi    $4,$4,1
            addi    $21,$10,-1   #LEFT
            sb      $21,Neighbors($4)

            addi    $4,$4,1
            addi    $21,$10,1    #RIGHT
            sb      $21,Neighbors($4)

            addi    $4,$4,1
            addi    $21,$10,9    #Left DOWN
            sb      $21,Neighbors($4)

            addi    $4,$4,1
            addi    $21,$10,11    #Right DOWN
            sb      $21,Neighbors($4)

            addi    $4,$4,1
            addi    $21,$10,-11   #Left up
            sb      $21,Neighbors($4)

            addi    $4,$4,1
            addi    $21,$10,-9    #Right up
            sb      $21,Neighbors($4)
            
            addi    $4,$0,0     # Counter for the loop below
            addi    $11,$0,8    # if counter == 8, exit loop

Nloop:      beq     $4,$11,Sum            # $4 is the counter that will iterate through all neighbors
            lb      $21,Neighbors($4)     # coordinates
            lb      $21,WorkingField($21) # value
            beq     $21,$5,Unopened
            beq     $21,$7,BM
            j       NCounter

Unopened:   addi    $3,$3,1   # unopened box count++
            j       NCounter

BM:         addi    $2,$2,1   # Minecount++

NCounter:   addi    $4,$4,1
            j       Nloop    

#============== RULES to SOLVE the game ======================
Sum:        add   $4,$3,$2
            addi  $3,$0,1       
            beq   $9,$4,OFNeighbors     # Sum of mines and unopen boxes == count,flag all neighbors
            addi  $3,$0,0
            beq   $9,$2,OFNeighbors     # Box number == count of flagged neighbors/mines, open all neighbors 
            j     Loop

# =================== Open/Flag Neighbors =======================

OFNeighbors: addi  $9,$0,0                # Counter for the for loop below


StartOF:     lb    $21,Neighbors($9)      # accessing the coordinates of neighbors
             lb    $11,WorkingField($21)  # accessing the values at the neighbor coordinates
             beq   $11,$5,Position        # only unopen boxes allowed
             j     OF2

OFL:         addi  $19,$0,1          # 1 in $19 highlights no need to guess
             bne   $4,$7,OF2         # if its not a flag,OF2
             addi  $20,$20,1         # MINECOUNT ++
             beq   $20,$1,Exit


OF2:         addi  $9,$9,1
             slti  $4,$9,8
             beq   $0,$4,Loop3    # COunter == 9 exit loop. 
             j     StartOF

#==========================================================
Loop3:     addi  $9,$0,12
           sb    $9,WorkingField($10)   # all boxes with all open/flagged neighbors are assigned a value of 11 to skip it through the loop
           addi  $12,$10,12             # inferences can be made only till the bottom right corner of $10
           addi  $19,$0,1               # $19 == 1 means a new box has been opened/flagged.



Loop:      beq   $12,$10,Guess         # after evaluating bottom right corner, go to Guess and check $19 value
Loop4:     addi  $10,$10,1 
           j     Code

OuterLoop:  beq   $19,$0,Guess1   # if no flags/ openning of boxes loop through the field again
            addi  $10,$0,11
            addi  $19,$0,0      # has to be reset
            j     Code

Exit:       jr    $31

Guess:     bne   $19,$0,Loop4    # $19 != 0 means no need to make a guess

Guess1:    addi  $10,$0,12       # Guessing begins in the 1st row
Guess1a:   lb    $9,WorkingField($10)
           beq   $5,$9,Guess3      # only unopened box can be guessed
           j     Loop2

 
Loop2:     addi  $10,$10,1
           j     Guess1a

Guess3:      addi  $3,$0,-1      # value of $3 for guessing
             addi  $21,$10,0     

Position:    div   $21,$5      # calculates the corresponding position of $21 in the 8x8 square
             mflo  $2
             mfhi  $4
             addi  $2,$2,-1
             addi  $4,$4,-1
             addi  $11,$0,8   # working field is 10x10 array, minefield is 8x8
             mult  $2,$11     # this subroutine calculates the correct coordinates
             mflo  $2
             add   $2,$4,$2
             swi   568
             sb    $4,WorkingField($21)
             addi  $2,$0,-1
             bne   $3,$2,OFL    # if its not a guess, OFL

Guess2:     addi  $12,$10,12
            beq   $4,$3,MC1
            addi  $10,$10,-11   # after making a new guess, inferences can be made only for its 8 neighbors. -11 indicates its top left neighbor
            j     Code



   