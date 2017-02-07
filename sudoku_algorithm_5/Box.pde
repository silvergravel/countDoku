class Box {

  int s;
  int posX;
  int posY;
  String num;
  color c;
  color aC;
  int textOffset;
  boolean isActive;
  boolean isAvailable;

  Box(int posX_, int posY_) {

    s = 60;
    posX = posX_;
    posY = posY_;
    num = "";
    c = color(255,0);
    aC = color(255, 0, 0, 128);
    textOffset = 30;
    isActive = false;
    isAvailable = true;
  }

  void display() {
    fill(c);
    stroke(255);
    rect(posX, posY, s, s);
    noStroke();
    fill(255);
    text(num, posX+textOffset, posY+textOffset);
  }

  void activeState() {
    c = aC;
  }
  
  void notActiveState() {
    c = color(255,0);
  }
}