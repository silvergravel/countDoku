String s1 = "44555668";
String s2 = "383a83802";
String s3 = "121919";
String s4 = "211829182";
String s5 = "001232";
String[] set = {s1, s2, s3, s4, s5};
String uniqueChar = "";
String blackList = "";
void setup() {

  size(200, 200);
  for (int j = 0; j < set.length; j++) {
    for (int i = 0; i < set[j].length(); i++ ) {
      if (blackList.indexOf(set[j].charAt(i)) == -1) { //this will store the chars that are repeated, and hence blackList for our purpose
        if (uniqueChar.indexOf(set[j].charAt(i)) == -1) { //if uniqueChar doesnt already have the char that is being analyed in our main string...
          uniqueChar += set[j].charAt(i); //then this takes in the first occurence of each new(unique) character
        } else if (uniqueChar.indexOf(set[j].charAt(i)) >= 0) { //if uniqueChar already consists this char, meaning its occured before in our main string..
          uniqueChar = uniqueChar.replace(str(set[j].charAt(i)), ""); //then remove that char from our uniqueChar string
          blackList += set[j].charAt(i); //also add it to our 'blacklisted' blackList chars, so that it is never added again to our uniqueChar
        }
      }
    }
  }
  for(int j = 0; j < set.length; j++){
   if(set[j].indexOf(uniqueChar) >= 0){
   println("the unique character is in s" + (j+1));
   }
  }
  println("...and the unique character is " +uniqueChar);
}

void draw() {
}

/*for the sudoku we need to (probably)
 
 - go through every row
 - spot out the boxes that have multiple number possibilities, 
 - put all those numbers into a single string, separated by a comma
 - find the unique char, if there is one,
 - then based on the comma separation, place that SINGLE number back into
 the box where it belongs
 
 -then we do this same thing for every column as well and every row as well.
 
 another imp rule that needs to be implemented is the pair occurence, within the same row, 
 column or block, because what that would do is remove those number occurences from all other
 blocks
 
 
 */