// Straight from processing examples with some extra tweaks
  class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;
  color barColor, handleColor, clickedColor; // Bar & handleColor
  float minVal, maxVal;
  float value;
  

  
    HScrollbar (float xp, float yp, int sw, int sh, int l, color bc, color hc, color c, float minv, float maxv, float v) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    spos = map(v, minv, maxv, sposMin, sposMax);
    newspos = spos;
    loose = l;
    barColor = bc;
    handleColor = hc;
    clickedColor = c;
    value = v;
    minVal = minv;
    maxVal = maxv;
  }
  
  void updateValue(float v) {
    value = v;
    spos = map(v, minVal, maxVal, sposMin, sposMax);
  }
  
  void updateBar(float minv, float maxv, float v) {
    value = v;
    minVal = minv;
    maxVal = maxv;
    spos = map(v, minv, maxv, sposMin, sposMax);
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
      value = map(newspos, sposMin, sposMax, minVal, maxVal);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    rectMode(CORNER);
    noStroke();
    fill(barColor);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(handleColor);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}
