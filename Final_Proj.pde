// declare of music parser
MusicParser parser;
Minim minim = null;

//animation
float t = 0.0f;
boolean animating = true;
float v = 5.0f;

//Circles
float r1 = 300.0f;
float r2 = 120.0f;
float x1, y1, x2, y2;
float rho = 80.0f, rho2 = 30.0f;

//root circle
Circle root;

PGraphics pg;


void setup() {
  size(800, 640);
  pg = createGraphics(width, height);
  //noLoop();
  x1 = width / 2;
  y1 = height / 2;
  root = new Circle(width / 2.0f, height / 2.0f, r1, r1 - r2);
  root.setChild(rho);
  root.setVelocity(1.0f);
  root.child.setVelocity(3.0f);
  root.child.setChild(rho2);
  root.child.child.setVelocity(5.0f);
  println("root: " + root.r + " " + root.rho);
  println("root child: " + root.child.r + " " + root.child.rho);
  
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
  root.drawCircle(pg);
  pg.endDraw();
  image(pg, 0, 0);
  if (animating) t += 0.01f;
}

//void mousePressed() {
//  loop();  // Holding down the mouse activates looping
//}

//void mouseReleased() {
//  noLoop();  // Releasing the mouse stops looping draw()
//}