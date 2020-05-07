// PXP_03_blur_vid_ink
// Made by Danqi Qian
// For ITP 2020Spring Pixel by Pixel Final
// Code is changed based on 'draw shards' by Daniel Roizn
// Move and drag to draw
// Tracks faces with opencv and lets you paint by moving face
// Download openCV for procesing: sketch->inport library->Add library...

import gab.opencv.*;
import processing.video.*;
import java.awt.*;
Shard[] shards = new Shard[0];  
float angle= 1;
float dir = 0.01;
color rndColor;
Capture video;
OpenCV opencv;
PGraphics pg;
void setup() {
  size(640, 480,P3D);
  String videoList[] = Capture.list();
  frameRate(20);
  video = new Capture(this, 640, 480, videoList[0]);                  // make small to make it faster
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
  pg = createGraphics(640, 480,P3D);
  pg.fill(255, 0, 0, 100);
}

void draw() {
  //background(0);
  opencv.loadImage(video);                     // takes the live video as the source for openCV
  image(video, 0, 0 ,640, 480);
  filter(BLUR, 2);
  pg.beginDraw();
  pg.noStroke();
  //pg.background(90,0,0,50);
  Rectangle[] faces = opencv.detect();  // track the faces and put the results in array
  angle+=dir;    
  if ( faces.length>0) {                       // we will do this for first face 
    if (angle > 1.8 || angle < 0.2 ) dir = -dir ;         // change direction
      for (int i = 0; i< shards.length; i++) {            // visit all our shards
        shards[i].drawShard(faces[0].x+faces[0].width/2);    
    }
  //pg.ellipse((faces[0].x+faces[0].width/2)*2, (faces[0].y+faces[0].height/2)*2, 20, 20) ; 
  //pg.ellipse(faces[0].x, faces[0].y, 20, 20);

  pg.endDraw();

  image(pg,faces[0].x-200,faces[0].y-150,640, 480); 
  //image(pg,0,0);
  pg.filter(BLUR, 2);

  }
}                 

void captureEvent(Capture c) {
  c.read();
}
