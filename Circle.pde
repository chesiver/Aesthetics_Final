class Circle {
  
  //childs' centers' relatice corrdinates always are (0, 0);
  float x = 0.0f, y = 0.0f;
  float r = 0.0f;
  
  // number of childs
  int n;
  // rho array, rho + r1 = r0
  float[] rho;
  // theta array, angles of child center to parent center
  float[] theta;
  // velocity of child center
  float[] v;
  // childs pointer
  Circle[] childs;
  // is Leaf child
  boolean isLeaf = true;
  
  public Circle() {}
  public Circle(float x, float y, float r) {this.x = x; this.y = y; this.r = r; }
  
  public void setChilds(float[] rho1) {
    this.rho = rho1;
    this.childs = new Circle[rho1.length];
    this.isLeaf = false;
    for (int i = 0; i < rho1.length; ++i) {
      this.childs[i] = new Circle(0.0f, 0.0f, this.r - rho1[i]);
    }
  }
  public void setTheta(float[] theta) {
    assert(theta.length == childs.length): "error in setting velocity: theta number not equal to child number!";
    this.theta = theta;
  }  
  public void setVelocity(float[] v) {
    assert(v.length == childs.length): "error in setting velocity: velocity number not equal to child number!";
    this.v = v;
  }  
  
  public void drawCircles(PGraphics pg) {
    setMatrix(pg.getMatrix());
    stroke(color(255, 0, 0));
    fill(255, 1.0f);
    ellipse(0, 0, 2 * r, 2 * r);
    resetMatrix();
    for (int i = 0; i < childs.length; ++i) {
      theta[i] += dt * v[i];
      println("theta " + i + ":" + theta[i]);
      pg.pushMatrix();
        pg.rotate(-theta[i]);
        pg.translate(rho[i], 0.0f);
          if (childs[i].isLeaf == false) {
            pg.pushMatrix();
            pg.rotate(theta[i] * rho[i] / (r - rho[i]));
            childs[i].drawCircles(pg);
            pg.popMatrix();
          }
          else {
            pg.stroke(color(0, 0, 255));
            pg.fill(0, 0, 255);
            pg.ellipse(0, 0, 1, 1);
            //lastMatrix.mult(new float[]{0, 0}, pre);
            //PMatrix curMatrix = pg.getMatrix().get();
            //curMatrix.invert();
            //curMatrix.mult(pre, cur);
            //lastMatrix = pg.getMatrix().get();
            //pg.line(cur[0], cur[1], 0, 0);
          }
      pg.popMatrix();
    }
  }
  
}

// rhos fall in range if [0, 1]
Circle createTestRootCircle() {
  Circle root = new Circle(0, 0, 300);
  root.setChilds(new float[] {250, 200});
  root.setTheta(new float[] {0.0, PI / 2});
  root.setVelocity(new float[] {2.0, 2.0});  
  root.childs[0].setChilds(new float[] {50});
  root.childs[0].setTheta(new float[] {0.0});
  root.childs[0].setVelocity(new float[] {2.0});  
  return root;
}