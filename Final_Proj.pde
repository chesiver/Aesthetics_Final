// declare of music parser
MusicParser parser;
Minim minim = null;

GUI ui = new GUI();

//animation
float t = 0.0f;
float dt = 0.01f;
boolean animating = true;
float v = 5.0f;

//Circles
float r1 = 300.0f;
float r2 = 120.0f;
float x1, y1, x2, y2;
float rho = 80.0f, rho2 = 30.0f;

//root circle 
Circle root;

//last point coornidate
PMatrix lastMatrix;
float[] pre = new float[2], cur = new float[2];

PGraphics pg;

void setup() {
  size(800, 640);
  frameRate(30);
  pg = createGraphics(width, height);
  //noLoop();
  x1 = width / 2;
  y1 = height / 2;
  root = createTestRootCircle();
  //circles = createCircleArray(3, width / 2, height / 2, 300, new float[] {0.6, 0.6, 0.6}, 2.0f);
  //lastMatrix = new PMatrix2D();
  //lastMatrix.translate(width / 2, height / 2);
  //float x0 = 0;
  //for (int i = 0; i < n; ++i) x0 += circles[i].rho;
  //lastMatrix.translate(x0, 0);
  //initialization of music parser
  minim = new Minim(this);
  parser = new MusicParser();
  parser.play();
}

void draw() {
  background(200);
  parser.update();
  pg.beginDraw();
  pg.translate(width / 2, height / 2);
  root.drawCircles(pg);
  pg.endDraw();
  image(pg, 0, 0);
  if (animating) {
    t += dt;
  }
  
  ui.draw();
}

//void mousePressed() {
//  loop();  // Holding down the mouse activates looping
//}

//void mouseReleased() {
//  noLoop();  // Releasing the mouse stops looping draw()
//}