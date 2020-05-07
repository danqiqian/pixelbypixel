// PXP_00&01_triangle_brush
// Made by Danqi Qian
// For ITP 2020Spring Pixel by Pixel Final
// Code is changed based on 'draw shards' by Daniel Roizn
// Move your mouse with video texture

Shard[] shards = new Shard[0];                   //an empty array that will hold our shard objects as we add them                        
float angle= 1;
float dir = 0.01;
import processing.video.*;
Capture pigs;
PGraphics pg;

color rndColor;
int [][] startpoints = {{100, 500},{200, 300}, {300, 300}};
int startTime= millis();
boolean stopDraw =false;

float xoff = 0;
float yoff=0;
float scalar = 600;
float speed = .00008;
float location=200;
float noiseX, noiseY;
float dists;

void setup() {
  size (1280, 720, P3D);
  pigs= new Capture(this, width, height,  "FaceTime HD Camera");
  pigs.start();
  pg = createGraphics(1280, 720,P3D);
  
  
  float centX=width/2;
  float centY=height/2;
  yoff+=speed;
  xoff = yoff + location;
  noiseX = noise(xoff) * scalar;
  noiseY = noise(yoff) * scalar;
  //first get several points that is inside a circle that centers and (width/2,height/2)
  dists=dist(noiseX,noiseY,centX,centY);
  
  
  for(int i = 0; i< 3; i++){
    shards= (Shard[]) append(shards, new Shard(startpoints[i][0], startpoints[i][1]));
  }
  
}

void draw() {
  
  yoff+=speed;
  xoff = yoff + location;
  noiseX = int(noise(xoff) * scalar);
  noiseY = int(noise(yoff) * scalar);
  
  
  if (pigs.available())pigs.read();
  image(pigs,0,0);  
  pg.beginDraw();
  pg.noStroke();
  angle+=dir;                                          // increment our rotation angle
  if (angle > 1.8 || angle < 0.2 )dir = -dir ;         // change direction
  for (int i = 0; i< shards.length; i++) {            // visit all our shards
    shards[i].drawShard();                            // draw all our shards
  }
  pg.endDraw();
  image(pg, 0, 0); 
  
  if (millis()-startTime > 10000) {
    stopDraw = true;
  }
  
  
  if(stopDraw == false){
    println("stopDraw == false");
    for(int i = 0; i <2; i++){
      shards[i].addPoint(int(noiseX), int(noiseY));
    }
  }else{
    println("stopDraw == true");
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
  
void drawShard() {                               // function to draw the shard   
  //int centerX= locX/pointXs.length;              // find the average x for center of rotation
  int centerX= width/2;    
    pg.pushMatrix();
    pg.translate (mouseX, mouseY);                       // translate to center of shard
    pg.rotateY(angle);                                // rotate around center of shard

    pg.beginShape();                                // start the shape
    pg.texture(pigs);                                // use our PImage as texture
    for (int i= 0; i< pointXs.length; i++) {
      for (int n=0;n<50;n+=10){
      pg.vertex(pointXs[i]+n, pointYs[i]+n, 0, pointXs[i]+mouseX, pointYs[i]+mouseY);   
      }
      
      //use our arrays x and y to define the vertexes and the points on the texture
    }
    pg.endShape(CLOSE);                                                                    // end the shape
    pg.popMatrix();                                                                       // pop our matrix
  }
}
