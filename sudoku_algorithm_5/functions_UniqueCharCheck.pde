void uniqueDigitCheck_row() {
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

void uniqueDigitCheck_col() {
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