String allUniqueDigits = ""; //needed for the automated analysis in void draw(){}
String uniqueDigit = "";
String blackList = "";

//UNIQUE CHAR CHECK | RULE 4
////////////////////////////////////////////////////////////////////////////
//Going through all the possible digits generated by the Basic Analysis, this function can search for  
//unique occurances of a particular digit within a row, column or block, depending on the values of
//variables parsed into the function.

void uniqueDigitCheck(int c_r_bShift2, int c_r_bShift, int boxShift2, int boxShift) {   


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