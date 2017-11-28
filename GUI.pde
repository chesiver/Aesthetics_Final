void keyPressed() {
  switch (key) {
    case 'a': ui.setMode(1); break;
    case 'c': ui.setMode(2); break;
    default: ui.setMode(0); break;
  }
}

void mouseClicked() {
  switch (ui.mode) {
    case 0: ui.updateChosen(); break;
    case 1: ui.addCircle(); break;
    case 2: ui.addPoint(); break;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  ui.changeR(e*5);
}

class GUI {
  Circle chosen = null;
  int mode = 0;
  
  GUI () {
  }
  
  void draw() {
    //println("key: " + key + ", pressed: " + keyPressed);
    if (mode == 1) {
      updateChosen();
      stroke(color(255, 0, 0));
      fill(255, 1.0f);
      ellipse(mouseX, mouseY, 100, 100);
    }
    else if (mode == 2) {
      updateChosen();
      stroke(color(255, 0, 255));
      fill(255, 1.0f);
      ellipse(mouseX, mouseY, 20, 20);
    }
    
    if (chosen != null) {
      // draw the circle with highlight
      stroke(color(0, 0, 0));
      fill(255, 3.0f);
      ellipse(chosen.x, chosen.y, chosen.radius, chosen.radius);
    }
  }
  
  void setMode(int m) {
    mode = (mode == m ? 0 : m);
  }

  Circle findCircle(float x, float y, Circle c) {
    Circle res = null;
    println(((c.x-x)*(c.x-x)) + " " + ((c.y-y)*(c.y-y)) + " " + c.radius*c.radius);
    if ((c.x-x)*(c.x-x)+(c.y-y)*(c.y-y) <= c.radius*c.radius) {
      res = c;
      for (Circle child : c.childs) {
        Circle tmp = findCircle(x, y, child);
        if (tmp != null) return tmp;
      }
    }
    return res;
  }
  
  void updateChosen() {
    chosen = findCircle(mouseX, mouseY, root);
  }
  
  void addCircle() {
  }
  
  void addPoint() {
  }
  
  void changeR(float value) {
    if (chosen != null) {
      
    }
  }
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;
  
  String name;
  
  float minV = -5, maxV = 5;
  float interval = 0.2;

  HScrollbar (float xp, float yp, int sw, int sh, String st) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw;
    ratio = (float)1.0 / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth;
    name = st;
  }
  
  void setRange(float vMin, float vMax, float vInterval) {
    minV = vMin;
    maxV = vMax;
    interval = vInterval;
  }

  void update() {
    newspos = spos;
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
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos);
    }
    int tmp = ceil(getValue() / interval);

    setPos(tmp*interval);
    
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
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    if (spos >= sposMin && spos <= sposMax) rect(spos-sheight/2, ypos, sheight, sheight);
    fill(0);
    textSize(16);
    text(name + ": ", xpos-sheight*3, ypos + sheight);
    textSize(14);
    if (interval < 0.1) text(String.format("%.2f", getValue()), xpos+swidth+5, ypos + sheight);
    else text(String.format("%.1f", getValue()), xpos+swidth+5, ypos + sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio * swidth;
  }
  
  void setPos(float value){
    spos = xpos + (value-minV) / ratio / (maxV-minV);
  }
  
  float getValue() {
    return minV + (spos - xpos) * ratio * (maxV - minV);
  }
}