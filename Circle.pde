class Circle {
  
  //circle's center's world corrdinates;
  float x = 0.0f, y = 0.0f;
  
  //circle's radius
  float radius = 0.0f;
  
  //relative rho, theta, velocity from this to it's parent
  float rho = 0.0f, theta = 0.0f, velocity = 0.0f;
  
  //parent pointer
  Circle parent = null;
  //child pointers
  ArrayList<Circle> childs = new ArrayList<Circle>();
  
  //transform matrix of curent;
  PMatrix transform = new PMatrix2D();
  
  public Circle() {}
  public Circle(float x, float y, float radius) {this.x = x; this.y = y; this.radius = radius; }
  public Circle(float rho, float theta, float velocity, float radius) {this.rho = rho; this.theta = theta; this.velocity = velocity; this.radius = radius; }
  
  public void setChilds(float[] rho1, float[] theta1, float[] velocity1) {
    assert(rho1.length == theta1.length);
    assert(rho1.length == velocity1.length);
    for (int i = 0; i < rho1.length; ++i) {
      childs.add(new Circle(rho1[i], theta1[i], velocity1[i], radius - rho1[i]));
      childs.get(i).parent = this;
    }
  }
  public void setRadius(float radius) {
    this.radius = radius;
  }
  public void setTheta(float theta) {
    this.theta = theta;
  }  
  public void setVelocity(float velocity) {
    this.velocity = velocity;
  }  
  public void update() {
    theta += velocity * dt;
  }
  
  public void drawChilds(PGraphics pg) {
    pg.pushMatrix();
    pg.rotate(-theta);
    pg.translate(rho, 0);
    transform.rotate(-theta);
    transform.translate(rho, 0);
    transform.mult(new float[] {0, 0}, cur);
    x = cur[0]; y = cur[1];
    if (childs.size() == 0) {
      pg.stroke(color(0, 0, 255));
      pg.fill(255, 0.0f);
      pg.ellipse(0, 0, 1, 1);
    }
    else {
      setMatrix(pg.getMatrix());
      stroke(color(255, 0, 0));
      fill(255, 1.0f);
      ellipse(0, 0, 2 * radius, 2 * radius);
      resetMatrix();
      for (Circle child: childs) {
        pg.pushMatrix();
        pg.rotate(theta * child.rho / child.radius);
        child.drawChilds(pg);
        child.transform = pg.getMatrix().get();
        pg.popMatrix();
        child.update();
      }
      float[] cur = new float[2];
    }
    pg.popMatrix();
  }
}

Circle createTestRootCircle() {
  Circle root = new Circle(width / 2 , height / 2, 300);
  root.setChilds(new float[] {240}, new float[] {0.0}, new float[] {1.0});
  root.childs.get(0).setChilds(new float[] {40}, new float[] {0.0}, new float[] {5.0});
  root.childs.get(0).childs.get(0).setChilds(new float[] {4, 8}, new float[] {0.0, PI / 2}, new float[] {0.0, 0.0});
  return root;
}