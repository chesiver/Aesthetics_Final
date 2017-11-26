class Circle {
  
  //childs centers' relatice corrdinates always are (0, 0);
  float x = 0.0f, y = 0.0f;
  float r = 0.0f;
  
  //rho + r1 = r
  float rho = 0.0f;
  //velocity of childs center
  float v = 0.0f;
  
  Circle child = null;
  
  public Circle() {}
  public Circle(float x, float y, float r, float rho) {this.x = x; this.y = y; this.r = r; this.rho = rho; }
  
  public void setChild(float rho1) {
    this.child = new Circle(0.0f, 0.0f, this.r - this.rho, rho1);
  }
  public void setVelocity(float v) { this.v = v; }  
  
  public void drawCircle(PGraphics pg) {
    float theta = v * t;
    
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
      pg.stroke(color(0, 0, 255));
      pg.fill(0, 0, 255, 0.0f);
      pg.ellipse(0, 0, 1, 1);
    pg.popMatrix();
    
  }
  
}