import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sudoku_algorithm_5 extends PApplet {

ArrayList<Box> boxes = new ArrayList<Box>(); 

// X and Y distance of each box from the previous (edge to edge, since side of box == 60 as well). 
int boxPosX = 60;  
int boxPosY = 60;

// X and Y distance of each block from the previous
int blockPosX = (boxPosX * 3)+5;  
int blockPosY = (boxPosY * 3)+5;


int finalizedBoxCount; //variable to keep track of the boxes that have been finalized. Need to automate the suDoku solving.
int pFinalizedBoxCount = -1; //variable to keep track of previous finalized count.

boolean startAnalysis = false;
boolean startUniqueDigitCheckRow = false;
boolean startUniqueDigitCheckCol = false;
boolean startUniqueDigitCheckBlock = false;

boolean saveDigits = true;
boolean victory = true;
boolean finalizeAndClearGate = false;

int baCounter = 0;

PImage dooku;

PFont font;
PFont fontBold;
String status;


String controlKey1;
String controlKey2;
String controlKey3_1;
String controlKey3_2;

int selectedBox;

public void setup() {

  

  //CREATE THE SUDOKU GRID
  ////////////////////////////////////////////////////////////////////////////
  /*the boxes are generated in the following order: (for the sake of convenience later on)
   
   | 0  | 1  | 2  |    | 9  | 10 | 11 |    | 18 | 19 | 20 |      
   | 3  | 4  | 5  |    | 12 | 13 | 14 |    | 21 | 22 | 23 |      
   | 6  | 7  | 8  |    | 15 | 16 | 17 |    | 24 | 25 | 26 |      
   
   | 27 | 28 | 29 |    | 36 | 37 | 38 |    | 45 | 46 | 47 |      
   | 30 | 31 | 32 |    | 39 | 40 | 41 |    | 48 | 49 | 50 |      
   | 33 | 34 | 35 |    | 42 | 43 | 44 |    | 51 | 52 | 53 |      
   
   | 54 | 55 | 56 |    | 63 | 64 | 65 |    | 72 | 73 | 74 |      
   | 57 | 58 | 59 |    | 66 | 67 | 68 |    | 75 | 76 | 77 |      
   | 60 | 61 | 62 |    | 69 | 70 | 71 |    | 78 | 79 | 80 |  
   
   */  ///////////////////////////////////////////////////////////////////////////

  for (int l = 0; l < 3; l++) {
    for (int k = 0; k < 3; k++) {
      for (int j = 0; j < 3; j++) {
        for (int i = 0; i < 3; i++) {
          boxes.add(new Box( 0+boxPosX+(boxPosX*i)+(blockPosX*k), 0+boxPosY+(boxPosY*j)+(blockPosX*l) ));
        }
      }
    }
  }

  dooku = loadImage("dooku.png");

  font = loadFont("Circular_Book.vlw");
  fontBold = loadFont("Circular_Bold.vlw");

  status = "Fill out the provided numbers, then hit RETURN to subjugate Doku and";
  status += "\n" + "get him to solve shit for you!";

  controlKey1 = "RETURN to initiate solving";

  controlKey2 = "To input digit in box:" + "\n" + "- CLICK on box";
  controlKey2 += "\n" + "- TYPE number between 0 - 9 ";
 

  controlKey3_1 = "Finalized Digits in WHITE";
  controlKey3_2 = "\n" + "Digit Possibilities in RED";
} // VOID SETUP ENDS HERE



public void draw() {

  background(35, 35, 35);

  tint(255, 8);

  image(dooku, 60, 60);


  // display the boxes generated earlier
  for (Box b : boxes) {
    b.display();
  }

  fill(255, 90);
  textFont(font, 12);
  textLeading(15);
  text(controlKey1, 60, height-78);
  text(controlKey2, 260, height-78);
  text(controlKey3_1, 475, height-78);
  fill(226, 35, 104, 180);
  text(controlKey3_2, 475, height-78 + 1.5f);


  fill(226, 35, 104);
  textFont(fontBold, 16);
  textAlign(LEFT, CENTER);
  textLeading(24);
  text(status, 60, height - 190);
  fill(255);
  textAlign(LEFT, TOP);
  text("COUNT DOKU", 0, 0);

  if (startAnalysis == true) {

    finalizeAndClearGate = true;
    for (int i = 0; i < boxes.size(); i ++) {
      Box b = boxes.get(i);
      /*if even 1 box has no number, that means we did not have any 
       human input previous to this (during which all the possible 
       digits are displayed in each box), so no need to run the finalizeAndClear function*/
      if (b.num.equals("") == true) { 
        finalizeAndClearGate = false;
        break;
      }
    }

    if (finalizeAndClearGate == true) {
      finalizeAndClear();
    }




    while (finalizedBoxCount != pFinalizedBoxCount) {
      println("***** STARTING BASIC ANALYSIS " + baCounter++ + "...");
      basicAnalysis();
      finalizeAndClear();
    }
    baCounter = 0;
    if (finalizedBoxCount != 81) {
      println("***** STARTING NUM BOX MATCH...");
      basicAnalysis();
      numBoxMatch(27, 9, 3, 1); 
      numBoxMatch(9, 1, 27, 3);
      numBoxMatch(27, 3, 9, 1);
      finalizeAndClear();
      if (finalizedBoxCount == pFinalizedBoxCount) {
        startAnalysis = false;

        startUniqueDigitCheckRow = true;
        println("***** STARTING UNIQUE DIGIT CHECK --ROW--...");
      }
    }//ending if condition to check if all 81 boxes have NOT been finalized
    else {
      startAnalysis = false;
      congrats();
    }
  }



  if (startUniqueDigitCheckRow == true) {
    basicAnalysis();
    //******RULE 4.1: CHECK FOR UNIQUE DIGIT IN THE SAME ROW***********
    uniqueDigitCheck(27, 3, 9, 1);  //   c_r_bShift2 = 27  c_r_bShift = 3   boxShift2 = 9  boxShift = 1
    finalizeAndClear();
    if (allUniqueDigits.equals("") == false) { //if a unique digit was found...
      startAnalysis = true; //then run the start analysis loop again.
    } else {
      startUniqueDigitCheckCol = true;
      println("***** STARTING UNIQUE DIGIT CHECK --COL--...");
    }
    allUniqueDigits = "";
    startUniqueDigitCheckRow = false;
  }

  if (startUniqueDigitCheckCol == true) {
    basicAnalysis();
    //******RULE 4.2: CHECK FOR UNIQUE DIGIT IN THE SAME COLUMN***********
    uniqueDigitCheck(9, 1, 27, 3);  
    finalizeAndClear();
    if (allUniqueDigits.equals("") == false) { //if a unique digit was found...
      startAnalysis = true; //then run the start analysis loop again.
    } else {
      startUniqueDigitCheckBlock = true;
      println("***** STARTING UNIQUE DIGIT CHECK --BLOCK--...");
    }
    allUniqueDigits = "";
    startUniqueDigitCheckCol = false;
  }

  if (startUniqueDigitCheckBlock == true) {
    basicAnalysis();
    //******RULE 4.3: CHECK FOR UNIQUE DIGIT IN THE SAME BLOCK***********
    uniqueDigitCheck(27, 9, 3, 1);  
    if (allUniqueDigits.equals("") == false) { //if a unique digit was found...
      finalizeAndClear();
      startAnalysis = true; //then run the start analysis loop again.
    } else { /*else, we have reached the last part of the analysis, 
     and all boxes are still not filled. So its time to start preparing for 
     human input*/


      if (saveDigits == true) { 
        /*..then it is def the first time we reaching this part of the programme
         which means, we are stuck but we havn't made any human input or error at
         this point...*/
        println("***** ANALYSIS COMPLETE ***** & WE ARE STUCK !!! :( :( :(");
        println("saving the current digits...");
        status = "DOKU'S ANALYSIS IS DONE. AND HE'S STUCK. STUPID GUY." + "\n" ;
        status += "He needs your help. Try finalizing any one box using one of its";
        status += "\n" + "Digit Possibilities. Pro tip, try a box with the fewest Digit Possibilities.";
        status += "\n" + "...then push that RETURN key and get Doku to do some solving.";
        saveDigits("savedDigits/savedDigits.txt");
        saveDigits = false;
      } else /*this is the second time we reaching this point which is only possible
       after some human input, which means there is a possibility of error, so check for that*/
      {
        checkForErrors();
      }
    } 
    allUniqueDigits = "";
    startUniqueDigitCheckBlock = false;
  }
}// VOID DRAW ENDS HERE


public void keyPressed() {




  if (keyCode == 10) { //if 'return' is pressed
    status = "ANALYSIS IN PROGRESS...";
    startAnalysis = true;
  } else if (keyCode == 77  ) { //'M'

    loadDigits("savedDigits/savedDigits.txt");
  } else if (keyCode == 38) { // 'UP' arrow

    finalizeAndClear();
  } else {

    String s = str(key);

    for (Box b : boxes) {

      if (b.isActive == true) {
        if (PApplet.parseInt(s) > 0 && PApplet.parseInt(s) <= 9 ) { //only if user types in a number between 1 to 9, 
          b.num = s;                      // then input it into the box
          b.isAvailable = false;          // change the availability of the box to 'UNAVAILABLE'
        } else {                          //if user presses any other key, 'DELETE' for example, or anything else by mistake...
          b.num = "";                     //then dont input any character / remove any existing character in the box
          b.isAvailable = true;           // change the availablity of the box to 'AVAILABLE' again.
        }
      }
    }
  }
}// VOID KEYPRESSED ENDS HERE


public void mousePressed() {

  //ACTIVATE BOX THAT IS CLICKED
  ////////////////////////////////////////////////////////////////////////////
  for (Box b : boxes) {  
    float d = dist(mouseX, mouseY, b.posX, b.posY );

    if (mouseX > b.posX && mouseY > b.posY && d < b.s) {
      b.activeState();                              //object function: change box color to RED
      b.isActive = true;                            //object function: boolean ON, so we can modify the String inside
      
      selectedBox = boxes.indexOf(b);
      
      println("THE BOX ID IS " + boxes.indexOf(b)); //get the 'id' (so to say) of the box
    } else {
      b.notActiveState();                           //object function: change box color back to black
      b.isActive = false;                           // boolean OFF
    }
  }
}// VOID MOUSEPRESSED ENDS HERE


public void checkForErrors() {

  int errorCounter = 0;

  for (int i = 0; i < boxes.size(); i++) {
    Box b = boxes.get(i);
    if (b.num.equals("") == true) { //if even ANY one box doesnt have any 'possible digit' loaded into it...something is wrong
      println("Something is wrong.... !!! :( :(");
      loadDigits("savedDigits/savedDigits.txt");
      println("NO WORRIES!, we loaded the digits from the last correct state!");
      status = "NOP!!! THAT DIGIT SEEMS TO BE INCORRECT." + "\n";
      status += "Try finalizing the same box with one of its OTHER Digit Possibilities";
      status += "\n" + "...then hit RETURN to get Doku back to work ;)";
      errorCounter++;
      println("error counter: " + errorCounter);
      break;
    }
  }
  if (errorCounter == 0 ) {
    println("Everything seem okay as of now...but you are still STUCK :( :(");
    status = "DOKU IS STUCK AGAIN. I APOLOGIZE FOR HIS INCOMPETENCE >:(";
    status += "\n" + "Once again, try finalizing a digit in one of the boxes.";
    status += "\n" + "And yet again, whack that RETURN key. Maybe Doku will finally deliver :/";
  }
}

public void saveDigits(String fileName) {

  String out = "";
  for (int i = 0; i < boxes.size(); i++) {
    out += boxes.get(i).num + "\n";
  }
  saveStrings(fileName, out.trim().split("\n"));
  println("DIGITS HAVE BEEN SAVED!");
}

public void loadDigits(String fileName) {
  String[] in = loadStrings(fileName);

  for (int i = 0; i < in.length; i++) {
    Box b = boxes.get(i);
    /*this is fucking important because the only reason why the program loads
     digits is because, due to human input, it tried to solve the rest of the problem,
     and it failed. In this process it filled up single digits into almost all the boxes,
     and based on the commands in the BasicAnalysis function, it marked all these boxes as
     'unavailable'. Hence, when these boxes are being loaded with digits from the 'past' 
     again, their availability needs to be reset so as to allow the basicAnalysis to 
     correctly do its job.*/
    if (in[i].length() > 1) { 
      b.isAvailable = true;
      println(boxes.indexOf(b) + " is available again");
    } else {
      b.isAvailable = false;
    }
    b.num = in[i];
    b.appendedNum = "";
    b.appended = false;
  }
}

public void congrats() {

  if (victory == true) {

    println("--------------------------------------------------------");  
    println("***** CONGRATULATIONS!! THE PUZZLE HAS BEEN SOLVED *****");
    println("--------------------------------------------------------");
    status = "ITS SOLVED! CONGRATS!!" + "\n" + "LOOK AT YOU, YOU JEDI ;)";
     
    victory = false;
  }
}
class Box {

  int s;
  int posX;
  int posY;
  String num;
  String numTemp;
  String appendedNum;
  int c;
  int aC;
  int textOffsetX;
  int textOffsetY;
  boolean isActive;
  boolean isAvailable;
  boolean appended;


  Box(int posX_, int posY_) {

    s = 60;
    posX = posX_;
    posY = posY_;
    num = "";
    appendedNum = "";
    c = color(255, 0);
    aC = color(226, 35, 104, 128);
    textOffsetX = 27;
    textOffsetY = 34;
    isActive = false;
    isAvailable = true;
    appended = false;
  }

  public void display() {
    fill(c);
    stroke(255);
    rect(posX, posY, s, s);
    noStroke();
    if (num.length() > 1) {
      fill(226, 35, 104);
    } else {
      fill(255);
    }

    textAlign(LEFT);
    textFont(font, 16);
    text(num, posX+textOffsetX, posY+textOffsetY);
  }

  public void activeState() {
    c = aC;
  }

  public void notActiveState() {
    c = color(255, 0);
  }
}

//BASIC ANALYSIS | RULE 1,2,3
////////////////////////////////////////////////////////////////////////////
//cycle through each of the boxes. Based on the provided numbers, and the 3 basic rules of sudoku (no repeatition in block, row or column), 
//fill up each box with all the numbers that could be valid in it.

String[] possibleDigits = {"1", "2", "3", "4", "5", "6", "7", "8", "9"};
int blockRowColChecker = 0;

public void basicAnalysis() {
  for (int bl = 0; bl < 9; bl++) { //this is to shift to the next block                        ///////////////// THESE 2 LOOPS ALLOW US TO CYCLE, AND IN A SENSE 'SELECT' EACH  ////////////
    for (int bo = 0; bo < 9; bo++) { //this is to shift to next box within each block          ////////////////  'BOX' AND PERFORM OUR 3 SUDOKU RULES ANALYSIS ON THEM          ////////////
      for (int j = 0; j < possibleDigits.length; j++) { //cycle through the numbers 1 to 9 



        //*******RULE 1: CHECK FOR SAME NUMBER WITHIN THE BLOCK*********

        for ( int i = 0 + (bl*9); i< 9 + (bl*9); i++) { //for the current selected 'box' cycle through every other box in its block 
          Box b = boxes.get(i);
          if (PApplet.parseInt(possibleDigits[j]) != PApplet.parseInt(b.num)) {   //if the current possibleDigit (j loop) is not already present then 
            blockRowColChecker++;                       //add 1 to the blockRowColChecker variable, which keeps a count of the number of boxes that DO NOT have the same number
          }
        }
        //**************************************************************



        //******RULE 2: CHECK FOR SAME NUMBER IN THE SAME ROW***********

        for (int n = 0; n < 3; n++) {                 //for the current selected 'box' cycle 
          for (int m = 0; m < 3; m++ ) {              //through every other box in its row
            Box b = boxes.get((n%3)*9 + m + PApplet.parseInt(bl/3)*27 + PApplet.parseInt(bo/3)*3);  //I dont know how I figured out this equation, but its correct.
            if (PApplet.parseInt(possibleDigits[j]) != PApplet.parseInt(b.num)) {  //same as in RULE 1
              blockRowColChecker++;
            }
          }
        }

        //***************************************************************

        //******RULE 3: CHECK FOR SAME NUMBER IN THE SAME COLUMN***********

        for (int n = 0; n < 3; n++) {              //for the current selected 'box' cycle
          for (int m = 0; m < 9; m += 3 ) {        //through every other box in its column
            Box b = boxes.get((n%3)*27 + m + (bl%3)*9 + (bo%3));      //I dont know how I figured out this equation, but its correct.
            if (PApplet.parseInt(possibleDigits[j]) != PApplet.parseInt(b.num)) {  //same as in RULE 1
              blockRowColChecker++;
            }
          }
        }

        //***************************************************************



        if (blockRowColChecker == 27) { //meaning that the current possibleDigit is not repeated in any other box WITHIN the block OR row OR column
  
          Box b = boxes.get(bo + (bl*9)); //get ID (so to speak) of the box that is being analyzed
          if (b.isAvailable == true && b.appended == false) {    //if this box isn't already filled up with a solution digit && it hasn't been appended (by rule 5)
            b.num += possibleDigits[j];   //then write the current possibleDigit into the box.
          } else if(b.isAvailable == true && b.appended == true){ //else if it has been appended by rule 5...
            if(b.appendedNum.indexOf(possibleDigits[j]) != -1){ // only if our 'possible digit' is also present in our appended number variable,
            b.num += possibleDigits[j]; // then go ahead, and add this number to our box being analyzed.
            //this way we make sure, that this BasicAnalysis doesnt overwrite our Rule 5.
            }
          }
        }
        blockRowColChecker = 0; //reset blockRowColChecker variable so that it can start the same analysis for the next possibleDigit (j loop).
      } //ending the 'j' for loop
    } //ending the 'bo' for loop
  } //ending the 'bl' for loop
} //CLOSING THE basicAnalysis() FUNCTION
String allUniqueDigits = ""; //needed for the automated analysis in void draw(){}
String uniqueDigit = "";
String blackList = "";

//UNIQUE CHAR CHECK | RULE 4
////////////////////////////////////////////////////////////////////////////
//Going through all the possible digits generated by the Basic Analysis, this function can search for  
//unique occurances of a particular digit within a row, column or block, depending on the values of
//variables parsed into the function.

public void uniqueDigitCheck(int c_r_bShift2, int c_r_bShift, int boxShift2, int boxShift) {   


  for (int l = 0; l < c_r_bShift2*3; l += c_r_bShift2) {
    for (int k = 0; k < c_r_bShift*3; k += c_r_bShift) {
      for (int j = 0; j < boxShift2*3; j += boxShift2) {
        for (int m = 0; m < boxShift*3; m += boxShift) {    
          //-----
          Box b = boxes.get(l +k + j + m);
          if (b.num.length() > 1) { //only consider blocks that have more than 1 number
            for (int i = 0; i < b.num.length(); i++ ) {
              if (blackList.indexOf(b.num.charAt(i)) == -1) {                     //this will store the chars that are repeated, and hence blackList for our purpose
                if (uniqueDigit.indexOf(b.num.charAt(i)) == -1) {                  //if uniqueDigit doesnt already have the char that is being analyed in our main string...
                  uniqueDigit += b.num.charAt(i);                                  //then this takes in the first occurence of each new(unique) character
                } else if (uniqueDigit.indexOf(b.num.charAt(i)) >= 0) {            //if uniqueDigit already consists this char, meaning its occured before in our main string..
                  uniqueDigit = uniqueDigit.replace(str(b.num.charAt(i)), "");      //then remove that char from our uniqueChar string
                  blackList += b.num.charAt(i);                                   //also add it to our 'blacklisted' blackList chars, so that it is never added again to our uniqueChar
                }
              }
            }
          }
          //-----
        }
      } //this loop finishes cycling through each box in a particular row / column / block

      // get the output here.
      println("UNIQUE IS " + uniqueDigit);
      allUniqueDigits += uniqueDigit;


      // now that are unique char string is prepared (since we cycled through the entire row / column),
      // we must cycle through the row / column again, to find which box actually holds this unique character, and 
      // put it back in there as the 'solution digit'. Probably not the most optimized approach. But works.
      for (int j = 0; j < boxShift2*3; j += boxShift2) {
        for (int m = 0; m < boxShift*3; m += boxShift) {
          Box b = boxes.get(l +k + j + m);
          for (int n = 0; n < uniqueDigit.length(); n++) {
            if (b.num.indexOf(uniqueDigit.charAt(n)) >= 0 && uniqueDigit.equals("") == false) { 
              /* uniqueDigit.equals("") == false is required to make sure that
               in the case where there is no unique character (meaning the result is ""), 
               the program doesn't replace all the existing characters with "" (empty)
               
               b.num.indexOf(uniqueDigit.charAt(n)) >= 0 - this means that we check whether either of
               the digits in the selected box match any one of the numbers in the uniqueDigit string.*/
              b.num = str(uniqueDigit.charAt(n)); //if it does, then replace the possibleDigits in that box with this uniqueDigit
              b.isAvailable = false;
            }
          }
        }
      }

      //refresh the variables so that the same process starts for the next row / column / block
      uniqueDigit = "";
      blackList = "";
    }
  }
}
public void finalizeAndClear(){
      pFinalizedBoxCount = finalizedBoxCount;
      finalizedBoxCount = 0; //counter to keep track of boxes with the final 'solution digit'

    for (int i = 0; i < boxes.size(); i++) {
      Box b = boxes.get(i);
      if (b.num.length() == 1) { //if the digit in the box is a single number then obviously it is the final 'solution digit' hence...
        finalizedBoxCount++;     
        b.isAvailable = false;   //that box is no longer available, for any future inputs.
      } else {
        b.num = "";              //if box DOES NOT have finalized 'solution digit', then wipe it clean, for a fresh start to the rule based analysis.
      }
    }
    print("Finalized Boxes= " + finalizedBoxCount + "  |  ");
    println(" Previous Final Boxes= " + pFinalizedBoxCount);
  
}
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

public void numBoxMatch(int c_r_bShift2, int c_r_bShift, int boxShift2, int boxShift ) {

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
              //print("we have " + boxMatchCounter  + " boxes that have only " );
              //println( boxMatchCounter  + " numbers in common " );
              //println("the numbers are " + b.num);
              //println("the box IDs are " + tempStr);

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
              //println("we dont have a NUM TO BOX MATCH. Sorry." + "the numbers we see are " + b.num   );
            }
            boxMatchCounter = 0; //reset to 0, since we will now move on to the next box to be analyzed
            tempStr = ""; //same as above.
            //empty temp array
          } else { 
            //println("INVALID");
          }
        } // we shift to the next Box that needs to be analyzed.. and we run this entire process again.
      }
    }
  }
}//function closes here.
  public void settings() {  size(670, displayHeight, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sudoku_algorithm_5" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
