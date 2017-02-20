int digitMatchCounter = 0;
int boxMatchCounter = 0;
String tempStr = "";

//UNIQUE NUM BOX MATCH | RULE 5
////////////////////////////////////////////////////////////////////////////
//The way this logic works is, if for example, 2 squares within a row, column or block, share only 2 possible digits, 
//then the rest of the boxes in that row/column/block cannot have those digits. Hence, this function, eliminates those extra
//occurances of those digits. It works the same if 3 numbers are shared between 3 boxes, 4 between 4, and so on.

//eg 1. 1234 | 12 | 12 | 13459 | 134 | etc.. --- in this case, since we have 2 numbers shared between 2 boxes (12), the 1 and 2 will be eliminated from all other boxes.
//eg 2. 1349 | 13 | 14 | 134 | 1476 | etc.. --- in this case, since we have 3 numbers shared between 3 boxes (134), the 1,3 and 4 will be eliminated from all other boxes. 

void numBoxMatch(int c_r_bShift2, int c_r_bShift, int boxShift2, int boxShift ) {

  for (int l = 0; l < c_r_bShift2*3; l += c_r_bShift2) {
    for (int k = 0; k < c_r_bShift*3; k += c_r_bShift) {
      for (int j1 = 0; j1 < boxShift2*3; j1 += boxShift2) {
        for (int m1 = 0; m1 < boxShift*3; m1 += boxShift) {

          Box b = boxes.get(l +k + j1 + m1); //the current box that is being analyzed

          if (b.num.length() > 1) { //only run this function on boxes that have multiple digit possibilities. (of course skip the finalized boxes)
            for (int j = 0; j < boxShift2*3; j += boxShift2) { //cycle through every box,
              for (int m = 0; m < boxShift*3; m += boxShift) { // within the current row/column/block
                Box bCheck = boxes.get(l+k+j+m); 
                for (int i = 0; i< bCheck.num.length(); i++) { //cycle through the digits in the box being checked
                  if (b.num.indexOf(bCheck.num.charAt(i)) >= 0 && bCheck.num.length() > 1) { //if we find matching digits between the box being analyzed and the box being checked...
                    digitMatchCounter++; //self explanatory
                  }
                }

                if (digitMatchCounter == bCheck.num.length()) { //if checked box shares all its digits with amalyzed box..
                  //println("All " + bCheck.num.length() + " numbers are present in the b.num" );
                  boxMatchCounter++; 
                  tempStr += l+k+j+m + ","; //store the index of this checked box in a temporary string. we might need to access it later.
                } else {
                  //println("FAIL. Numbers dont match" );
                }
                digitMatchCounter = 0; //reset this counter so it can start afresh for the next box that will be checked.
              }
            }
            /*this is the key priciple behind this function's logic.
             if number of matched boxes == number of digits in our analyzed box, then, 
             we can eliminate those digits, from every other box!*/

            if (boxMatchCounter == b.num.length()) {  
              print("we have " + boxMatchCounter  + " boxes that have only " );
              println( boxMatchCounter  + " numbers in common " );
              println("the numbers are " + b.num);
              println("the box IDs are " + tempStr);

              for (int j = 0; j < boxShift2*3; j += boxShift2) { //cycle through all boxes in current row/column/block again..
                for (int m = 0; m < boxShift*3; m += boxShift) { //and append them, based on prev analysis
                  Box bAppend = boxes.get(l+k+j+m); 
                  /*if current appendable box is NOT stored in the temp string..
                   remember, temp string stores the index of the matched boxes...*/
                  if ( tempStr.indexOf(str(l+k+j+m)) == -1 && bAppend.num.length() > 1 ) { 
                    //remove any occurance of the "box being analyzed's" digits from that appendable box
                    for (int n = 0; n < b.num.length(); n++) { //cycle through the digits of the box being analyzed...
                      int index = bAppend.num.indexOf(b.num.charAt(n)); //get index value of current digit within the appendable box,
                      if (index != -1) { //if the current digit exists within the appendable box,

                        bAppend.num = bAppend.num.replace(str(bAppend.num.charAt(index)), ""); //then just get rid of it.
                      }
                    }
                    bAppend.appended = true; //switch boolean within the box object.
                    bAppend.appendedNum = bAppend.num; //store these appended numbers in a separate variable.
                  }
                }
              }
            } else { //if our function core function logic does not hold true...
              println("we dont have a NUM TO BOX MATCH. Sorry." + "the numbers we see are " + b.num   );
            }
            boxMatchCounter = 0; //reset to 0, since we will now move on to the next box to be analyzed
            tempStr = ""; //same as above.
            //empty temp array
          } else { 
            println("INVALID");
          }
        } // we shift to the next Box that needs to be analyzed.. and we run this entire process again.
      }
    }
  }
}//function closes here.