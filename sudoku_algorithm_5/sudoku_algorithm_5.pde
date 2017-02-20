ArrayList<Box> boxes = new ArrayList<Box>(); 

// X and Y distance of each box from the previous (edge to edge, since side of box == 60 as well). 
int boxPosX = 60;  
int boxPosY = 60;

// X and Y distance of each block from the previous
int blockPosX = (boxPosX * 3)+5;  
int blockPosY = (boxPosY * 3)+5;





void setup() {

  size(800, 800);

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
          boxes.add(new Box( 60+boxPosX+(boxPosX*i)+(blockPosX*k), 60+boxPosY+(boxPosY*j)+(blockPosX*l) ));
        }
      }
    }
  }
} // VOID SETUP ENDS HERE



void draw() {

  background(35,35,35);

  // display the boxes generated earlier
  for (Box b : boxes) {
    b.display();
  }
}// VOID DRAW ENDS HERE


void keyPressed() {




  if (keyCode == 10) { //if 'return' is pressed

    //******RULE 1,2,3: THREE BASIC SUDOKU RULES***********

    basicAnalysis();

    //***************************************************************
  } else if (keyCode == 16 ) { // 'SHIFT' arrow

    //******RULE 4.1: CHECK FOR UNIQUE DIGIT IN THE SAME ROW***********

    uniqueDigitCheck(27, 3, 9, 1);  //   c_r_bShift2 = 27  c_r_bShift = 3   boxShift2 = 9  boxShift = 1

    //***************************************************************
  } else if (keyCode == 47) { // '/' key

    //******RULE 4.2: CHECK FOR UNIQUE DIGIT IN THE SAME COLUMN***********

    uniqueDigitCheck(9, 1, 27, 3);  //   c_r_bShift2 = 9  c_r_bShift = 1   boxShift2 = 27  boxShift = 3    

    //***************************************************************
  } else if (keyCode == 46) { // '.' key

    //******RULE 4.3: CHECK FOR UNIQUE DIGIT IN THE SAME BLOCK***********

    uniqueDigitCheck(27, 9, 3, 1);  //   c_r_bShift2 = 27  c_r_bShift = 9   boxShift2 = 3  boxShift = 1    

    //***************************************************************
  }else if (keyCode == 44) { // ',' key

    //******RULE 5***********block

    numBoxMatch(27,9,3,1);      

    //***************************************************************
  }else if (keyCode == 77) { // 'm' key

    //******RULE 5***********column

    numBoxMatch(9,1,27,3);      

    //***************************************************************
  }else if (keyCode == 78) { // 'n' key

    //******RULE 5***********row

    numBoxMatch(27,3,9,1);      

    //***************************************************************
  }else if (keyCode == 38) { // 'UP' arrow

    int finalizedBoxCount = 0; //counter to keep track of boxes with the final 'solution digit'

    for (int i = 0; i < boxes.size(); i++) {
      Box b = boxes.get(i);
      if (b.num.length() == 1) { //if the digit in the box is a single number then obviously it is the final 'solution digit' hence...
        finalizedBoxCount++;     
        b.isAvailable = false;   //that box is no longer available, for any future inputs.
      } else {
        b.num = "";              //if box DOES NOT have finalized 'solution digit', then wipe it clean, for a fresh start to the rule based analysis.
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
}// VOID KEYPRESSED ENDS HERE


void mousePressed() {

  //ACTIVATE BOX THAT IS CLICKED
  ////////////////////////////////////////////////////////////////////////////
  for (Box b : boxes) {  
    float d = dist(mouseX, mouseY, b.posX, b.posY );

    if (mouseX > b.posX && mouseY > b.posY && d < b.s) {
      b.activeState();                              //object function: change box color to RED
      b.isActive = true;                            //object function: boolean ON, so we can modify the String inside

      println("THE BOX ID IS " + boxes.indexOf(b)); //get the 'id' (so to say) of the box
    } else {
      b.notActiveState();                           //object function: change box color back to black
      b.isActive = false;                           // boolean OFF
    }
  }
}// VOID MOUSEPRESSED ENDS HERE