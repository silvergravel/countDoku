void finalizeAndClear(){
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