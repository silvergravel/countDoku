ArrayList<Box> boxes = new ArrayList<Box>();
String[] posNums;
int boxPosX = 60;
int boxPosY = 60;
int blockPosX = (boxPosX * 3)+5;
int blockPosY = (boxPosY * 3)+5;
int gap = 25;
String[] posNumbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9"};
int blockChecker = 0;

void setup() {
  size(800, 800);

  //CREATE THE SUDOKU GRID

  for (int l = 0; l < 3; l++) {
    for (int k = 0; k < 3; k++) {
      for (int j = 0; j < 3; j++) {
        for (int i = 0; i < 3; i++) {
          boxes.add(new Box( boxPosX+(boxPosX*i)+(blockPosX*k), boxPosY+(boxPosY*j)+(blockPosX*l) ));
        }
      }
    }
  }

  posNums = new String[boxes.size()];
  for (int i = 0; i < posNums.length; i++) {
    posNums[i] = " ";
  }
}

void draw() {
  background(0);

  for (Box b : boxes) {
    b.display();
  }
}

void mousePressed() {

  for (Box b : boxes) { //***DEACTIVATE ALL BOXES***
    b.inActive();
    b.isActive = false;
  }

  for (Box b : boxes) {  //***ACTIVATE BOX THAT IS CLICKED***
    float d = dist(mouseX, mouseY, b.posX, b.posY );

    if (mouseX > b.posX && mouseY > b.posY && d < b.s) {
      b.active(); //object function that changes the color of box to red
      b.isActive = true; //turn boolean on, so that we can modify the string inside
      println("THE BOX ID IS " + boxes.indexOf(b)); //get the 'id' (so to say) of the box
    }
  }
}

void keyPressed() {




  if (keyCode == 10) { //if 'return' is pressed


    //basicAnalysisRnd1();
    basicAnalysisRnd2();
  } else if (keyCode == 16 ) { // 'SHIFT' arrow

    //******RULE 4.1: CHECK FOR UNIQUE CHARACTER IN THE SAME ROW***********

    rule4_1();

    //***************************************************************
  } else if (keyCode == 47) {

    //******RULE 4.2: CHECK FOR UNIQUE CHARACTER IN THE SAME COLUMN***********

    rule4_2();

    //***************************************************************
  } else if (keyCode == 38) { // 'UP' arrow

    int finalizedBoxCount = 0;

    for (int i = 0; i < boxes.size(); i++) {
      Box b = boxes.get(i);
      if (b.num.length() == 1) {
        finalizedBoxCount++;
        b.isAvailable = false;
      } else {
        b.num = "";
      }
    }
    println(finalizedBoxCount + " are finalized Boxes");
  } else {


    String s = str(key);

    for (Box b : boxes) {

      if (b.isActive == true) {
        if (int(s) > 0 && int(s) <= 9 ) { //only if user types in a number between 1 to 9, 
          b.num = s;                      // then input it into the box
          b.isAvailable = false;          // change the availability of the box to 'UNAVAILABLE'
        } else {                          //if user presses any other key, 'DELETE' for example, or anything else by mistake...
          b.num = "";                     //then dont input any character / remove any existing character in the box
          b.isAvailable = true;           // change the availablity of the box to 'AVAILABLE' again.
        }
      }
    }
  }
}

void rule4_1() {
  String uniqueChar = "";
  String blackList = "";

  for (int l = 0; l < 81; l += 27) {
    for (int k = 0; k < 9; k += 3) {
      for (int j = 0; j < 27; j += 9) {
        for (int m = 0; m < 3; m++) {
          Box b = boxes.get(l +k + j + m);
          if (b.num.length() > 1) { //only consider blocks that have more than 1 number
            for (int i = 0; i < b.num.length(); i++ ) {
              if (blackList.indexOf(b.num.charAt(i)) == -1) { //this will store the chars that are repeated, and hence blackList for our purpose
                if (uniqueChar.indexOf(b.num.charAt(i)) == -1) { //if uniqueChar doesnt already have the char that is being analyed in our main string...
                  uniqueChar += b.num.charAt(i); //then this takes in the first occurence of each new(unique) character
                } else if (uniqueChar.indexOf(b.num.charAt(i)) >= 0) { //if uniqueChar already consists this char, meaning its occured before in our main string..
                  uniqueChar = uniqueChar.replace(str(b.num.charAt(i)), ""); //then remove that char from our uniqueChar string
                  blackList += b.num.charAt(i); //also add it to our 'blacklisted' blackList chars, so that it is never added again to our uniqueChar
                }
              }
            }
          }
        }
      }
      // get the output here. and refresh the variables so that the process
      //starts for the next line
      println("UNIQUE IS " + uniqueChar);

      for (int j = 0; j < 27; j += 9) {
        for (int m = 0; m < 3; m++) {
          Box b = boxes.get(l +k + j + m);
          for (int n = 0; n < uniqueChar.length(); n++) {
            if (b.num.indexOf(uniqueChar.charAt(n)) >= 0 && uniqueChar.equals("") == false) {
              /* uniqueChar.equals("") == false is required to make sure that
               in the case where there is no unique character (meaning the result is ""), 
               the program doesn't replace all the existing characters with "" (empty) */
              b.num = str(uniqueChar.charAt(n));
              b.isAvailable = false;
            }
          }
        }
      }
      uniqueChar = "";
      blackList = "";
    }
  }
}

void rule4_2() {
  String uniqueChar = "";
  String blackList = "";

  for (int l = 0; l < 27; l += 9) {
    for (int k = 0; k < 3; k ++) {
      for (int j = 0; j < 81; j += 27) {
        for (int m = 0; m < 9; m += 3) {
          Box b = boxes.get(l +k + j + m);
          if (b.num.length() > 1) { //only consider blocks that have more than 1 number
            for (int i = 0; i < b.num.length(); i++ ) {
              if (blackList.indexOf(b.num.charAt(i)) == -1) { //this will store the chars that are repeated, and hence blackList for our purpose
                if (uniqueChar.indexOf(b.num.charAt(i)) == -1) { //if uniqueChar doesnt already have the char that is being analyed in our main string...
                  uniqueChar += b.num.charAt(i); //then this takes in the first occurence of each new(unique) character
                } else if (uniqueChar.indexOf(b.num.charAt(i)) >= 0) { //if uniqueChar already consists this char, meaning its occured before in our main string..
                  uniqueChar = uniqueChar.replace(str(b.num.charAt(i)), ""); //then remove that char from our uniqueChar string
                  blackList += b.num.charAt(i); //also add it to our 'blacklisted' blackList chars, so that it is never added again to our uniqueChar
                }
              }
            }
          }
        }
      }
      // get the output here. and refresh the variables so that the process
      //starts for the next line
      println("UNIQUE IS " + uniqueChar);

      for (int j = 0; j < 81; j += 27) {
        for (int m = 0; m < 9; m += 3) {
          Box b = boxes.get(l +k + j + m);
          for (int n = 0; n < uniqueChar.length(); n++) {
            if (b.num.indexOf(uniqueChar.charAt(n)) >= 0 && uniqueChar.equals("") == false) {
              /* uniqueChar.equals("") == false is required to make sure that
               in the case where there is no unique character (meaning the result is ""), 
               the program doesn't replace all the existing characters with "" (empty) */
              b.num = str(uniqueChar.charAt(n));
              b.isAvailable = false;
            }
          }
        }
      }
      uniqueChar = "";
      blackList = "";
    }
  }
}

void basicAnalysisRnd1() {
  for (int bl = 0; bl < 9; bl++) { //this is to shift to the next block
    for (int bo = 0; bo < 9; bo++) { //this is to shift to next square within each block
      for (int j = 0; j < posNumbers.length; j++) { //cycle through the numbers 1 to 9 



        //*******RULE 1: CHECK FOR SAME NUMBER WITHIN THE BLOCK*********

        for ( int i = 0 + (bl*9); i< 9 + (bl*9); i++) { //for each number, check every box in the block and see if the same number is already present
          Box b = boxes.get(i);
          if (int(posNumbers[j]) != int(b.num)) { //if the number is not already present then 
            blockChecker++;                       //add 1 to the blockChecker variable, which keeps a count of the number of boxes that DO NOT have the same number
          }
        }
        //**************************************************************



        //******RULE 2: CHECK FOR SAME NUMBER IN THE SAME ROW***********

        for (int n = 0; n < 3; n++) {
          for (int m = 0; m < 3; m++ ) {
            Box b = boxes.get((n%3)*9 + m + int(bl/3)*27 + int(bo/3)*3);
            if (int(posNumbers[j]) != int(b.num)) {
              blockChecker++;
            }
          }
        }

        //***************************************************************

        //******RULE 3: CHECK FOR SAME NUMBER IN THE SAME COLUMN***********

        for (int n = 0; n < 3; n++) {
          for (int m = 0; m < 9; m += 3 ) {
            Box b = boxes.get((n%3)*27 + m + (bl%3)*9 + (bo%3));
            if (int(posNumbers[j]) != int(b.num)) {
              blockChecker++;
            }
          }
        }

        //***************************************************************






        if (blockChecker == 27) { //meaning that the currentNumber is not repeated in any other box WITHIN the block
          println(posNumbers[j] + " is not in this block");
          Box b = boxes.get(bo + (bl*9)); //get ID of the box that is being analyzed
          if (b.isAvailable == true) {
            b.num += posNumbers[j];
          }
        } else {
          println(posNumbers[j] + " is in this block");
        }
        blockChecker = 0; //reset blockChecker variable so that it can start checking for the nextNumber in the posNumbers array.
      } //ending the 'j' for loop
    } //ending the 'bo' for loop
  } //ending the 'bl' for loop

  for (int i = 0; i < boxes.size(); i++) {
    Box b = boxes.get(i);
    if (b.num.length() == 1) {
      b.isAvailable = false;
    } else {
      b.num = "";
    }
  }
}

void basicAnalysisRnd2() {
  for (int bl = 0; bl < 9; bl++) { //this is to shift to the next block
    for (int bo = 0; bo < 9; bo++) { //this is to shift to next square within each block
      for (int j = 0; j < posNumbers.length; j++) { //cycle through the numbers 1 to 9 



        //*******RULE 1: CHECK FOR SAME NUMBER WITHIN THE BLOCK*********

        for ( int i = 0 + (bl*9); i< 9 + (bl*9); i++) { //for each number, check every box in the block and see if the same number is already present
          Box b = boxes.get(i);
          if (int(posNumbers[j]) != int(b.num)) { //if the number is not already present then 
            blockChecker++;                       //add 1 to the blockChecker variable, which keeps a count of the number of boxes that DO NOT have the same number
          }
        }
        //**************************************************************



        //******RULE 2: CHECK FOR SAME NUMBER IN THE SAME ROW***********

        for (int n = 0; n < 3; n++) {
          for (int m = 0; m < 3; m++ ) {
            Box b = boxes.get((n%3)*9 + m + int(bl/3)*27 + int(bo/3)*3);
            if (int(posNumbers[j]) != int(b.num)) {
              blockChecker++;
            }
          }
        }

        //***************************************************************

        //******RULE 3: CHECK FOR SAME NUMBER IN THE SAME COLUMN***********

        for (int n = 0; n < 3; n++) {
          for (int m = 0; m < 9; m += 3 ) {
            Box b = boxes.get((n%3)*27 + m + (bl%3)*9 + (bo%3));
            if (int(posNumbers[j]) != int(b.num)) {
              blockChecker++;
            }
          }
        }

        //***************************************************************






        if (blockChecker == 27) { //meaning that the currentNumber is not repeated in any other box WITHIN the block
          //println(posNumbers[j] + " is not in this block");
          Box b = boxes.get(bo + (bl*9)); //get ID of the box that is being analyzed
          if (b.isAvailable == true) {
            b.num += posNumbers[j];
          }
        } else {
          //println(posNumbers[j] + " is in this block");
        }
        blockChecker = 0; //reset blockChecker variable so that it can start checking for the nextNumber in the posNumbers array.
      } //ending the 'j' for loop
    } //ending the 'bo' for loop
  } //ending the 'bl' for loop
}