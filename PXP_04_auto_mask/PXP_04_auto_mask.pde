// PXP_04_auto_mask
// Made by Danqi Qian
// For ITP 2020Spring Pixel by Pixel Final
// Code is changed based on 'draw shards' by Daniel Roizn
// Don't need to do anything, it automatically draws around your face
import gab.opencv.*;
import processing.video.*;
import java.awt.*;
OpenCV opencv;
Shard[] shards = new Shard[0];                   //an empty array that will hold our shard objects as we add them                        
float angle= 1;
float dir = 0.01;
import processing.video.*;
Capture pigs;
PGraphics pg;

color rndColor;
int [][] startpoints = {{width/2, 500},{width/2-100, 300}, {width/2, 600}};
int startTime= millis();
boolean stopDraw =false;

float xoff = 0;
float yoff=0;
float scalar = 600;
float speed = .00008;
float location=200;
float noiseX, noiseY;
float shardX, shardY;
float dists;

int faceX,faceY;
void setup() {
  size (640, 480, P3D);
  frameRate(20);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  pigs= new Capture(this, width, height);
  pigs.start();
  pg = createGraphics(640, 480,P3D);
  
  
  float centX=width/2;
  float centY=height/2;
  yoff+=speed;
  xoff = yoff + location;
  noiseX = noise(xoff) * scalar;
  noiseY = noise(yoff) * scalar;

  for(int i = 0; i< 3; i++){
    shards= (Shard[]) append(shards, new Shard(startpoints[i][0], startpoints[i][1]));
  }
  
}

void draw() {
  opencv.loadImage(pigs);
  image(pigs,0,0);
  filter(BLUR, 2);
  
  yoff+=speed;
  xoff = yoff + location;
  noiseX = int(noise(xoff) * scalar);
  noiseY = int(noise(yoff) * scalar);
  //shardX = map(noiseX, 0, 600, 0, width);
  
  //if (pigs.available())pigs.read();
  Rectangle[] faces = opencv.detect();

  if (faces.length>0) {
    pg.beginDraw();
    pg.noStroke();
    faceX=int(faces[0].x+faces[0].width/2);
    faceY=int(faces[0].y+faces[0].height/2);
    angle+=dir;                                          // increment our rotation angle
    if (angle > 1.8 || angle < 0.2 )dir = -dir ;         // change direction
    for (int i = 0; i< shards.length; i++) {            // visit all our shards
      shards[i].drawShard(faceX,faceY);                            // draw all our shards
    }  

    pg.endDraw();
    image(pg, faceX-350, faceY-350);  
   //image(pg, mouseX, mouseY); 
  
    if (millis()-startTime > 10000) {
       stopDraw = true;
    }
  
  
    if(stopDraw == false){
      println("stopDraw == false");
      for(int i = 0; i <2; i++){
      //shards[i].addPoint(int(noiseX), int(noiseY));
      //shards[i].addPoint(mouseX - int(noiseX), mouseY + int(noiseY));
      //shards[i].addPoint(mouseX - int(shardX), mouseY + int(shardY));
        shards[i].addPoint(faceX + int(shardX), faceY + int(shardY));
      }
    }else{
      println("stopDraw == true");
    } 
  }
}

class Shard {                                        // class to hold shard data and functions 
  int[] pointXs=new int[0];                          // arrays to hold all the points of the shape
  int[] pointYs=new int[0];

  int locX, locY, locZ;                             // ints to hold the center of the shapes                                   

  Shard(int x, int y) {                             // constructor
    pointXs= append(pointXs, x);                    // add the x, y to the arrays
    pointYs= append(pointYs, y);
    locX=x;                                     
    locY=y;
  }

  void addPoint(int x, int y) {                   // function to add points to the shape
    pointXs= append(pointXs, x);                  // add the x, y to the arrays
    pointYs= append(pointYs, y);
    locX+= x;                                    // sum the x and y so we can average to get center 
    locY+= y;
  }
  
void drawShard(int centX, int centY) {                               // function to draw the shard   
  //int centerX= locX/pointXs.length;              // find the average x for center of rotation
    int centerX= centX;
    int centerY= centY;
    pg.pushMatrix();
    pg.translate (centerX, 0);                       // translate to center of shard
    pg.rotateY(angle);                                // rotate around center of shard

    pg.beginShape();                                // start the shape
    pg.texture(pigs);                                // use our PImage as texture
    for (int i= 0; i< pointXs.length; i++) {
      for (int n=0;n<50;n+=10){
      //pg.vertex(pointXs[i]-centerX+n, pointYs[i]-centerY+n, 0, pointXs[i]+mouseX, pointYs[i]+mouseY);   
      pg.vertex(pointXs[i]+n, pointYs[i]+n, 0, pointXs[i], pointYs[i]); 
      }
    }
    pg.endShape(CLOSE);                                                                    // end the shape
    pg.popMatrix();                                                                       // pop our matrix
  }
}

void captureEvent(Capture c) {
  c.read();
}
