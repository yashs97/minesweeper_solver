# minesweeper_solver
C and Assembly Implementation of a minesweeper solver

To run the C code:

    cd /C\ Implementation

    make

    ./msweep 0.25 -1 1



Make command will create an executable msweep which can be executed on the command line using 3 flags:

(i) first denoting the probability of a square in the minefield being a mine

(ii) the seed denoting the placement of mines in the field, -1 for random placement

(iii) 1 indicating a verbose printout on the terminal and 0 for otherwise.

The ouput would look something like this:
