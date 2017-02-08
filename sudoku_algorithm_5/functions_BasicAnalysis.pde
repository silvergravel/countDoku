
//BASIC ANALYSIS | RULE 1,2,3
////////////////////////////////////////////////////////////////////////////
//cycle through each of the boxes. Based on the provided numbers, and the 3 basic rules of sudoku (no repeatition in block, row or column), 
//fill up each box with all the numbers that could be valid in it.

String[] possibleDigits = {"1", "2", "3", "4", "5", "6", "7", "8", "9"};
int blockRowColChecker = 0;

void basicAnalysis() {
  for (int bl = 0; bl < 9; bl++) { //this is to shift to the next block                        ///////////////// THESE 2 LOOPS ALLOW US TO CYCLE, AND IN A SENSE 'SELECT' EACH  ////////////
    for (int bo = 0; bo < 9; bo++) { //this is to shift to next box within each block          ////////////////  'BOX' AND PERFORM OUR 3 SUDOKU RULES ANALYSIS ON THEM          ////////////
      for (int j = 0; j < possibleDigits.length; j++) { //cycle through the numbers 1 to 9 



        //*******RULE 1: CHECK FOR SAME NUMBER WITHIN THE BLOCK*********

        for ( int i = 0 + (bl*9); i< 9 + (bl*9); i++) { //for the current selected 'box' cycle through every other box in its block 
          Box b = boxes.get(i);
          if (int(possibleDigits[j]) != int(b.num)) {   //if the current possibleDigit (j loop) is not already present then 
            blockRowColChecker++;                       //add 1 to the blockRowColChecker variable, which keeps a count of the number of boxes that DO NOT have the same number
          }
        }
        //**************************************************************



        //******RULE 2: CHECK FOR SAME NUMBER IN THE SAME ROW***********

        for (int n = 0; n < 3; n++) {                 //for the current selected 'box' cycle 
          for (int m = 0; m < 3; m++ ) {              //through every other box in its row
            Box b = boxes.get((n%3)*9 + m + int(bl/3)*27 + int(bo/3)*3);  //I dont know how I figured out this equation, but its correct.
            if (int(possibleDigits[j]) != int(b.num)) {  //same as in RULE 1
              blockRowColChecker++;
            }
          }
        }

        //***************************************************************

        //******RULE 3: CHECK FOR SAME NUMBER IN THE SAME COLUMN***********

        for (int n = 0; n < 3; n++) {              //for the current selected 'box' cycle
          for (int m = 0; m < 9; m += 3 ) {        //through every other box in its column
            Box b = boxes.get((n%3)*27 + m + (bl%3)*9 + (bo%3));      //I dont know how I figured out this equation, but its correct.
            if (int(possibleDigits[j]) != int(b.num)) {  //same as in RULE 1
              blockRowColChecker++;
            }
          }
        }

        //***************************************************************



        if (blockRowColChecker == 27) { //meaning that the current possibleDigit is not repeated in any other box WITHIN the block OR row OR column
  
          Box b = boxes.get(bo + (bl*9)); //get ID (so to speak) of the box that is being analyzed
          if (b.isAvailable == true) {    //if this box isn't already filled up with a solution digit...
            b.num += possibleDigits[j];   //then write the current possibleDigit into the box.
          }
        }
        blockRowColChecker = 0; //reset blockRowColChecker variable so that it can start the same analysis for the next possibleDigit (j loop).
      } //ending the 'j' for loop
    } //ending the 'bo' for loop
  } //ending the 'bl' for loop
} //CLOSING THE basicAnalysis() FUNCTION