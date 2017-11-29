void fileSelected(File selection) {
  if (selection == null) {
  } else {
    println("User selected " + selection.getAbsolutePath());
    parser.music = minim.loadFile(selection.getAbsolutePath());
  }
}

void keyPressed() {
  switch (key) {
    case 'a': ui.setMode(1); break;
    case 's': ui.setMode(2); break;
    case 'f': selectInput("Select a file to process:", "fileSelected"); break;
    case ' ': ui.setMode(0); ui.toggle(); break;
    default: ui.setMode(0); break;
  }
}

void mouseClicked() {
  switch (ui.mode) {
    //case 0: ui.updateChosen(); break;
    case 1: ui.addCircle(); break;
    case 2: ui.addPoint(); break;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  ui.changeValue(e);
}

class GUI {
  Circle chosen = null;
  int mode = 1;
  float drawR = 5.0f;
  
  HScrollbar bar;
  
  GUI () {
    bar = new HScrollbar(30, 30, 100, 10, "degree velocity");
    chosen = root;
  }
  
  void draw() {
    drawHelper();
    //println("key: " + key + ", pressed: " + keyPressed);
    if (animating) return;
    if (mode == 1) {
      updateChosen();
      if (chosen != null) {
        //mouseY = (int)y1;
        drawR = chosen.radius - sqrt((chosen.x-mouseX)*(chosen.x-mouseX)+(chosen.y-mouseY)*(chosen.y-mouseY));
        stroke(color(128, 128, 128));
        noFill();
        strokeWeight(4);
        ellipse(mouseX, mouseY, drawR*2, drawR*2);
        strokeWeight(1);
      }
    }
    else if (mode == 2) {
      updateChosen();
      
      if (chosen != null) {
        //mouseY = (int)y1;
        stroke(color(255, 0, 255));
        fill(color(255, 0, 255));
        ellipse(mouseX, mouseY, drawR*2, drawR*2);
        noFill();
      }
    }
    
    if (chosen != null) {
      // draw the circle with highlight
      stroke(color(0, 0, 0));
      noFill();
      strokeWeight(2f);
      ellipse(chosen.x, chosen.y, chosen.radius*2, chosen.radius*2);
      strokeWeight(1);
    }
    //bar.update();
    if (mode != 0) bar.display();
  }
  
  void toggle() {
    if (animating) {
      parser.stopPlaying();
      dt = 0;
    }
    else {
      dt = 0.01f;
      parser.play();
    }
  }
  
  void setMode(int m) {
    mode = (mode == m ? 0 : m);
    if (mode == 1) {
      updateChosen();
      bar.setPos(1);
      //if (chosen != null) drawR = chosen.radius / 2;
    }
    else if (mode == 2) {
      drawR = 5.0f;
      bar.setPos(0);
    }
    else {
      chosen = null;
    }
  }

  Circle findCircle(float x, float y, Circle c) {
    Circle res = null;
    if (c.isPoint) return res;
    //println(((c.x-x)*(c.x-x)) + " " + ((c.y-y)*(c.y-y)) + " " + c.radius*c.radius);
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
    if (chosen != null) {
      chosen = chosen.addCircle(mouseX, mouseY, drawR, bar.getValue());
    }
  }
  
  void addPoint() {
    if (chosen != null) {
      Circle point = chosen.addPoint(mouseX, mouseY, bar.getValue());
      point.pIndex = parser.n;
      parser.setN(parser.n+1);
    }
  }
  
  void changeValue(float value) {
    bar.setPos(bar.getValue()+value*bar.interval);
  }
  
  void drawHelper() {
    fill(0);
    textSize(10);
    float posx = 5, posy = height - 120;
    String st = "Helper:\n" + 
                "press ' ': to start displaying\n" +
                "press 'a': enter mode of adding circles\n" +
                "press 's': enter mode of adding printing point\n" + 
                "press 'f': to choose a music file from file system\n" + 
                "In both modes: \n" +
                "  mouse click to add a circle/point;\n  use mouse wheel to adjust degree velocity";
    text(st,posx, posy);
    noFill();
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
  float interval = 0.05;

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
    text(name + ":", xpos-10, ypos-5);
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
    value = max(minV, value);
    value = min(value, maxV);
    spos = xpos + (value-minV) / ratio / (maxV-minV);
  }
  
  float getValue() {
    return minV + (spos - xpos) * ratio * (maxV - minV);
  }
}