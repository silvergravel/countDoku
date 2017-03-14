class Box {

  int s;
  int posX;
  int posY;
  String num;
  String numTemp;
  String appendedNum;
  color c;
  color aC;
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

  void display() {
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

  void activeState() {
    c = aC;
  }

  void notActiveState() {
    c = color(255, 0);
  }
}