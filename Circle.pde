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
  
  //whether it's a point or a circle
  boolean isPoint = false;
  
  //transform matrix of curent;
  PMatrix transform = new PMatrix2D();
  
  public Circle() {}
  public Circle(float x, float y, float radius) {this.x = x; this.y = y; this.radius = radius;}
  public Circle(float rho, float theta, float velocity, float radius, boolean isPoint) {
    this.rho = rho; this.theta = theta; this.velocity = velocity; this.radius = radius; this.isPoint = isPoint; 
  }
  
  public Circle addCircle(float newX, float newY, float newR) {
    Circle tmp = new Circle(radius - newR, 0, 1.0, newR, false);
    tmp.parent = this;
    childs.add(tmp);
    return tmp;
  }
  
  public void addPoint(float newX, float newY) {
    float newR = sqrt((x-newX)*(x-newX)+(y-newY)*(y-newY));
    println(newR);
    Circle tmp = new Circle(newR, 0, 0, 0, true);
    tmp.parent = this;
    childs.add(tmp);
  }
  
  public void setChilds(float[] rho1, float[] theta1, float[] velocity1, boolean[] isPoints) {
    assert(rho1.length == theta1.length);
    assert(rho1.length == velocity1.length);
    for (int i = 0; i < rho1.length; ++i) {
      childs.add(new Circle(rho1[i], theta1[i], velocity1[i], radius - rho1[i], isPoints[i]));
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
    float[] cur = new float[2];
    transform.mult(new float[] {0, 0}, cur);
    if (parent != null) {
      x = cur[0]; y = cur[1];
    }
    if (isPoint) {
      pg.stroke(color(0, 0, 255));
      pg.fill(255, 0.0f);
      pg.ellipse(0, 0, 5, 5);
      //println(x + ", " + y);
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
    }
    pg.popMatrix();
  }
}

Circle createTestRootCircle() {
  Circle root = new Circle(width / 2 , height / 2, 300);
  //root.setChilds(new float[] {240}, new float[] {0.0}, new float[] {1.0}, new boolean[] {false});
  //root.childs.get(0).setChilds(new float[] {40}, new float[] {0.0}, new float[] {5.0}, new boolean[] {false});
  //root.childs.get(0).childs.get(0).setChilds(new float[] {0, 0}, new float[] {0.0, PI / 2}, new float[] {0.0, 0.0}, new boolean[] {true, true});
  return root;
}