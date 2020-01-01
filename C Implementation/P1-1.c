/*    This program solves a minesweeper game.
 
 PLEASE FILL IN THESE FIELDS:
 Your Name: Yash Shah
 Date: 28th September 2018
 */
// ./msweep 0.50 -1 1
#include "minefield.h"
int WorkingField[64]; // Global Variable
int count1=0; int count2=0;
int BoxCount(){  // keeps the count of unopened boxes
    int count=0;
    for (int x=0;x<64;x++){
        if (WorkingField[x] != 1000){
            count++;
        }
    }
    return count;
}

int z [8]; // array to store all my neighbors
int DetectNeighbors( int r, int c){ // detect all neighbors
    for (int k=0; k<8;k++){
        z[k]=10000;
    }
    if (r==0 && c==0){ // top left corner
        z[0]= (r+1)*8+c; z[1]=r*8+c+1;z[2]=(r+1)*8+c+1;
        // z[k]=10000 highlight the condition where a neighbor doesn't exist in 8x8 field
    } else if(r==0 && c==7){ // top right corner
        z[0]= (r+1)*8+c-1; z[1]= r*8+c-1; z[2]=(r+1)*8+c;
    } else if(r==7 && c==0){ // bottom left corner
        z[0]=(r-1)*8+c;z[1]=8*r+c+1;z[2]=8*(r-1)+c+1;
    } else if (r==7 && c==7){ // bottom right corner
        z[0] = r*8+c-1; z[1] = 8*(r-1)+c;z[2]=8*(r-1)+c-1;
    } else if (c==0 && r!=0 && r!=7){ // first column
        z[0] = r*8+c+1; z[1] = 8*(r-1)+c;z[2]=8*(r-1)+c+1;
        z[3] = 8*(r+1)+c; z[4]= 8*(r+1)+c+1;
    } else if (r==0 && c!=0 && c!=7){ // first row
        z[0] = r*8+c-1; z[1] = 8*(r)+c+1;z[2]=8*(r+1)+c-1;
        z[3] = 8*(r+1)+c; z[4]= 8*(r+1)+c+1;
    } else if( c==7 && r!=0 && r!=7){ // last column
        z[0] =8*(r-1)+c; z[1] = 8*(r-1)+c-1;z[2]=8*(r)+c-1;
        z[3] = 8*(r+1)+c; z[4]= 8*(r+1)+c-1;
    } else if(r==7 && c!=0 && c!=7){ // last row
        z[0] =8*(r-1)+c; z[1] = 8*(r-1)+c-1;z[2]=8*(r-1)+c+1;
        z[3] = 8*(r)+c-1; z[4]= 8*(r)+c+1;
    } else { // elements wth 8 neighbors
        z[0] =8*(r)+c+1; z[1] = 8*(r)+c-1;z[2]=8*(r-1)+c;
        z[3] = 8*(r-1)+c-1; z[4]= 8*(r-1)+c+1;
        z[5]=8*(r+1)+c;z[6]= 8*(r+1)+c-1;z[7]=8*(r+1)+c+1;
    }
    return 0;
}
int OpenNeighbors(int r, int c){
    DetectNeighbors(r,c);
    for (int k=0; k<8;k++){
        if (z[k] != 10000 && WorkingField[z[k]] == 1000){
            WorkingField[z[k]]= open(z[k]/8,z[k]%8);
        }
    }
    return 0;
}
int FlagNeighbors(int r, int c){
    DetectNeighbors(r,c);
    for (int k=0; k<8;k++){
        if (z[k] != 10000 && WorkingField[z[k]] == 1000){
            WorkingField[z[k]]= 100;flag(z[k]/8,z[k]%8);
        }
    }
    return 0;
}

int Counting(){ // function that will be called upon to solve the code
    for (int xyz=0; xyz<80;xyz++){
        for(int i = 0; i < 64; i++) {
            if (WorkingField[i] == 0){ // if a box is 0 open all neighbors
                OpenNeighbors(i/8,i%8);
            }
            else if (WorkingField[i] == 8){ // if a box is 8 flag all neighbors
                FlagNeighbors(i/8,i%8);
            }
            else if (WorkingField[i]<=7 && WorkingField[i]>=1){
                int sum=0;
                int r =i/8; int c =i%8; // row column
                DetectNeighbors(r,c);
                for (int k =0; k<8; k++){
                    if (z[k] != 10000){
                        sum = sum + WorkingField[z[k]];
                    }
                }
                int firstdigit = sum /1000; //firstdigit will be the # of unopened square
                int seconddigit = sum/100; // second didgit is number of already opened mines
                if (seconddigit>=10){
                    seconddigit = seconddigit % 10;}
                if( seconddigit==WorkingField[r*8+c]){ // box # equal to openned mines,reveal all neighbors
                    OpenNeighbors(r,c);
                } else if (WorkingField[r*8+c]==firstdigit+seconddigit){ // box number equal to unopened boxes
                    FlagNeighbors(r,c);
                }
            }
        }}
    return 0;
}
// =================================================================================
// solver function starts here
void solver(int mn) {
    for(int i = 0; i < 64; i++) {
        WorkingField[i] = 1000; // all elements in working field are 1000
    }
    WorkingField[56] = guess(7,0);// guessing the bottom left  corner
    if (WorkingField[56]==-1){
        WorkingField[56]=100; // setting first guess to 100
    }
    for (int po=0;po<100;po++){
        if(po%2==0){
            Counting();
            count1 = BoxCount();
        } else if (po%2 !=0){
            Counting();
            count2 = BoxCount();
        }
        if (count1 == count2){
            Counting(); // calling it again to double check that a necessary is really required
            count1 = BoxCount();
            if (count1==count2){ // if count doesn't change after running the loop again, NECESSARY GUESS
                int iq = (rand() % (63 - 0 + 1)) + 0; // iq is just used yo choose any # btwn 0-63
                while (WorkingField[iq] != 1000){ // guess can't be made on an open box
                    iq = (rand() % (63 - 0 + 1)) + 0;
                }
                WorkingField[iq] = guess(iq/8,iq%8);
                if (WorkingField[iq]==-1){
                    WorkingField[iq]=100; // mines in my working field are assigned a value of 100
                }
            }
            
            
        }
        
    }}




