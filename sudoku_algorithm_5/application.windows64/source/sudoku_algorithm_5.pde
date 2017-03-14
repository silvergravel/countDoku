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

void setup() {

  size(670, displayHeight, P3D);

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



void draw() {

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
  text(controlKey3_2, 475, height-78 + 1.5);


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


void keyPressed() {




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
}// VOID KEYPRESSED ENDS HERE


void mousePressed() {

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


void checkForErrors() {

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

void saveDigits(String fileName) {

  String out = "";
  for (int i = 0; i < boxes.size(); i++) {
    out += boxes.get(i).num + "\n";
  }
  saveStrings(fileName, out.trim().split("\n"));
  println("DIGITS HAVE BEEN SAVED!");
}

void loadDigits(String fileName) {
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

void congrats() {

  if (victory == true) {

    println("--------------------------------------------------------");  
    println("***** CONGRATULATIONS!! THE PUZZLE HAS BEEN SOLVED *****");
    println("--------------------------------------------------------");
    status = "ITS SOLVED! CONGRATS!!" + "\n" + "LOOK AT YOU, YOU JEDI ;)";
     
    victory = false;
  }
}