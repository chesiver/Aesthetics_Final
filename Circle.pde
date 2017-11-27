class Circle {
  
  //childs centers' relatice corrdinates always are (0, 0);
  float x = 0.0f, y = 0.0f;
  float r = 0.0f;
  
  //rho + r1 = r
  float rho = 0.0f;
  //angle of child center to parent center
  float theta = 0.0f;
  //velocity of child center
  float v = 0.0f;
  
  Circle child = null;
  
  public Circle() {}
  public Circle(float x, float y, float r, float rho) {this.x = x; this.y = y; this.r = r; this.rho = rho; }
  
  public void setChild(float rho1) {
    this.child = new Circle(0.0f, 0.0f, this.r - this.rho, rho1);
  }
  public void setVelocity(float v) { this.v = v; }  
  
  public void drawCircle(PGraphics pg) {
    theta += dt * v;
    setMatrix(pg.getMatrix());
    stroke(color(255, 0, 0));
    fill(255, 1.0f);
    ellipse(0, 0, 2 * r, 2 * r);
    resetMatrix();
    pg.pushMatrix();
      pg.rotate(-theta);
      pg.translate(rho, 0.0f);
        if (child != null) {
          pg.pushMatrix();
          pg.rotate(theta * rho / (r - rho));
          child.drawCircle(pg);
          pg.popMatrix();
        }
      else {
        pg.stroke(color(0, 0, 255));
        pg.fill(0, 0, 255);
        pg.ellipse(0, 0, 2, 2);
        last_x = screenX(0, 0);
        last_y = screenY(0, 0);
        println("last_x: " + last_x + " " + "last_y: " + last_y);
      }
    pg.popMatrix();
  }
  
}

// rhos fall in range if [0, 1]
Circle[] createCircleArray(int n, float x, float y, float r0, float[] rho, float v) {
  assert(rho.length == n);
  Circle[] res = new Circle[n];
  res[0] = new Circle(x, y, r0, r0 * rho[0]); 
  for (int i = 1; i < n; ++i) {
    res[i] = new Circle(0, 0, res[i - 1].r * (1 - rho[i - 1]), res[i - 1].r * (1 - rho[i - 1]) * rho[i]);
    res[i - 1].child = res[i];
  }
  for (int i = 0; i < n; ++i) res[i].setVelocity(v);
  last_x = x; last_y = y;
  return res;
}