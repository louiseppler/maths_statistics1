Points points = new Points();
int tx = 250;
int ty = 250;
float f = 50;

void setup() {
  size(500,500);
}

void draw() {
  translate(tx,ty);
  background(255);
  drawAxis();
  points.draw();
  points.drawMean();
  if(mousePressed) {
    mouse();
  }
}

void drawAxis() {
  stroke(0);
  line(0,-height,0,height);
  line(width,0,-width,0);

  for(int i = -int(width/f); i < width/f; i++) {
   line(i*f,-5,i*f,5);
   line(-5,i*f,5,i*f);
  }
}

void mousePressed() {
  if(keyCode == SHIFT) {
    println("Selecting point");
    points.getPoint();
  }
  else if(key == 'm') {}
  else {
    points.mousePressed();
  }
}

void keyPressed() {
  if(key == 's') {
    points.getStandartDeviation();
  }
}

void mouse() {
  if(key == 'm') {
    points.move();
  }
}

public class Point {
  float x;
  float y;

  Point(int x, int y) {
    this.x = (x-tx+0.0)/f;
    this.y = -(y-ty+0.0)/f;
    println("New point: "+this.x+" "+this.y);
  }

  void draw(int s) {
    ellipse(x*f,-y*f,s,s);
  }

  void move(int x, int y) {
    this.x = (x-tx+0.0)/f;
    this.y = -(y-ty+0.0)/f;
  }

  float distance(int x, int y) {
    float xx = (x-tx+0.0)/f;
    float yy = -(y-ty+0.0)/f;
    return abs(this.x-xx)+abs(this.y-yy);
  }

}

public class Points {

  int j = -1;

  float meanX; float meanY;
  float stdX; float stdY;
  float covariance;
  float cfc;

  Point[] points;
  int n = 0;

  Points() {
    points = new Point[64];
  }

  void draw() {
    for(int i = 0; i < n; i++) {
      if(i == j){
      fill(255,0,0);
      }
      else {
       fill(0);
      }
      points[i].draw(10);
    }
  }

  void mousePressed() {
    print("Adding points");
    if(n >= points.length) {
      println("ERROR: out of range");
      return;
    }

    points[n] = new Point(mouseX,mouseY);

    n++;
    calc();
  }

  void move() {
    points[j].move(mouseX,mouseY);
    calc();
  }

  void getPoint() {
    float min = width*height*10;//a big number...
    int jloc = 0;

    for(int i = 0; i < n; i++) {
      float m = points[i].distance(mouseX,mouseY);
      if(m < min) {
        jloc = i;
        min = m;
      }
    }

    j = jloc;
    println("new point is: "+j);
  }

  void calc() {
    getMean();
    getStandartDeviation();
    getCovariance();
    getCfC();
  }

  void getMean() {
    float sx = 0;
    float sy = 0;
    for(int i = 0; i < n; i++) {
       sx += points[i].x;
       sy += points[i].y;
    }
    meanX = sx/(n-0.0);
    meanY = sy/(n-0.0);
  }

  void getStandartDeviation() {
    float sx = 0;
    float sy = 0;

    for(int i = 0; i < n; i++) {
       sx += pow(points[i].x-meanX,2);
       sy += pow(points[i].y-meanY,2);
    }

    stdX = sqrt(sx/n);
    stdY = sqrt(sy/n);

    println("Standart Deviation      X: " + stdX);
    println("                        Y: " + stdY);
  }

  void getCovariance() {
    float s = 0;
    for(int i = 0; i < n; i++) {
       s += (points[i].x-meanX) * (points[i].y-meanY);
    }


    covariance = s/n;
    println("Covariance:              " + covariance);
  }

  void getCfC() { //Coefficient of correlation
    cfc = covariance/stdX/stdY;
    println("Coefficient of correlation : " + cfc);

  }

  void drawMean() {
    stroke(0,0,255);
    line(meanX*f,-height,meanX*f,height);
    line(width,meanY*-f,-width,meanY*-f);

    strokeWeight(5);
    stroke(0,128,0);
     line(meanX*f,meanY*-f+stdY*-f,meanX*f,meanY*-f);
    line(meanX*f+stdX*f,meanY*-f,meanX*f,meanY*-f);
    strokeWeight(1);

  }
}
