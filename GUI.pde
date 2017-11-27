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
    }
  }
  
  void setMode(int m) {
    mode = (mode == m ? 0 : m);
  }

  Circle findCircle(float x, float y) {
    return null;
  }
  
  void updateChosen() {
    chosen = findCircle(mouseX, mouseY);
  }
  
  void addCircle() {
  }
  
  void addPoint() {
  }
}