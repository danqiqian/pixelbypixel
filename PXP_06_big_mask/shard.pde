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
  
void drawShard(float cenX) {                               // function to draw the shard   
  int centerX= locX/pointXs.length;              // find the average x for center of rotation
    pg.pushMatrix();
    pg.translate (centerX, 0);            // translate to center of shard
    pg.rotateY(angle); 
    //pg.rotateY(angle);  
    //rotateY(random(angle));                               // rotate around center of shard

    pg.beginShape();                                // start the shape
    pg.texture(video);                                // use our PImage as texture
    for (int i= 0; i< pointXs.length; i++) {
      for (int n=0;n<5;n++){
      pg.vertex(pointXs[i]-cenX, pointYs[i], 0, pointXs[i], pointYs[i]);   
      }
      
      //use our arrays x and y to define the vertexes and the points on the texture
    }
    pg.endShape(CLOSE);                                                                    // end the shape
    pg.popMatrix();                                                                       // pop our matrix
  }
}


void mousePressed() {
  shards= (Shard[]) append(shards, new Shard(mouseX, mouseY));                        // when the mouse is pressed we start a new shard by calling new(0 and adding to our array
}

void mouseDragged () {
  shards[shards.length-1].addPoint(mouseX, mouseY);                                   // when the mouse is draged we add the mouseX and Y to the last shard arays
}
