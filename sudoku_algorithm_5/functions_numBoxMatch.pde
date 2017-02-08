int digitMatchCounter = 0;
int boxMatchCounter = 0;
String tempStr = "";

void numBoxMatch(int c_r_bShift2, int c_r_bShift, int boxShift2, int boxShift ) {

  for (int l = 0; l < c_r_bShift2*3; l += c_r_bShift2) {
    for (int k = 0; k < c_r_bShift*3; k += c_r_bShift) {
      for (int j1 = 0; j1 < boxShift2*3; j1 += boxShift2) {
        for (int m1 = 0; m1 < boxShift*3; m1 += boxShift) {

          Box b = boxes.get(l +k + j1 + m1);

          if (b.num.length() > 1) {
            for (int j = 0; j < boxShift2*3; j += boxShift2) {
              for (int m = 0; m < boxShift*3; m += boxShift) { //the boxes being checked for matching digits
                Box bCheck = boxes.get(l+k+j+m);
                for (int i = 0; i< bCheck.num.length(); i++) { //cycle through the digits in the box
                  if (b.num.indexOf(bCheck.num.charAt(i)) >= 0 && bCheck.num.length() > 1) {
                    digitMatchCounter++;
                  }
                }

                if (digitMatchCounter == bCheck.num.length()) {
                  //println("All " + bCheck.num.length() + " numbers are present in the b.num" );
                  boxMatchCounter++;
                  tempStr += l+k+j+m + ",";
                  //fill up a temporary array with the 'l+k+j+m' of bCheck.num
                } else {
                  //println("FAIL. Numbers dont match" );
                }
                digitMatchCounter = 0;
              }
            }
            if (boxMatchCounter == b.num.length()) {
              print("we have " + boxMatchCounter  + " boxes that have only " );
              println( boxMatchCounter  + " numbers in common " );
              println("the numbers are " + b.num);
              println("the box IDs are " + tempStr);

              for (int j = 0; j < boxShift2*3; j += boxShift2) {
              for (int m = 0; m < boxShift*3; m += boxShift) { //the boxes being appended based on prev analysis
                Box bAppend = boxes.get(l+k+j+m); 
                if ( tempStr.indexOf(str(l+k+j+m)) == -1 && bAppend.num.length() > 1 ) {
                  //remove any occurance of the b.num digits from that particular box
                  for (int n = 0; n < b.num.length(); n++) {
                    if (bAppend.num.indexOf(b.num.charAt(n)) != -1) {
                      int index = bAppend.num.indexOf(b.num.charAt(n));
                      bAppend.num = bAppend.num.replace(str(bAppend.num.charAt(index)), "");
                      
                    }
                  }
                  bAppend.appended = true;
                      bAppend.appendedNum = bAppend.num;
                }
              }
            }
            } else {
              println("we dont have a NUM TO BOX MATCH. Sorry." + "the numbers we see are " + b.num   );
            }
            boxMatchCounter = 0;
            tempStr = "";
            //empty temp array
          } else {
            println("INVALID");
          }
        }
      }
    }
  }
}