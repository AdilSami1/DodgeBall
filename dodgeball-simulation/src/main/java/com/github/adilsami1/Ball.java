package com.github.adilsami1;

import processing.core.PVector;

class Ball {
  PVector pos, vel;
  float size, maxSpeed, airTime;
  int ballColor;
  boolean inHand, airborne, onGround;
  Player holder;
  Team team; //so that we know what team threw the ball
  private MySketch sketch;
  
  Ball (MySketch sketch, float s, float mspeed, int c, Team t) {
    this.sketch = sketch;
    this.size = s;
    this.maxSpeed = mspeed;
    this.ballColor = c;
    this.inHand = false;
    this.airborne = false;
    this.onGround = false;
    this.vel = new PVector(0, 0);
    this.team = t;
    this.airTime = 0; //airTime is used so that boundries are only checked after a certain amount of airTime. This is so that balls don't get stuck on the edges when a player tries to throw it.
 
    
  }
  
  void drawMe() { 
   sketch.fill(this.ballColor);
   sketch.circle(this.pos.x, this.pos.y, this.size);
  }
  
  void move() {
       
     if (this.inHand) {
       this.pos = new PVector(this.holder.pos.x, this.holder.pos.y);
       this.vel = new PVector(0, 0);
      }
      
     else{ //if the ball in the air or on ground
       if (this.airborne) {
         if (this.hitPlayer())
           this.stopBall();
           
         if (!this.inBounds() && airTime >0.5)
           this.stopBall();
         
         airTime += 0.01;
       }
       else
         this.airTime = 0;
       
       this.pos.add(this.vel);
     
     }
  }
  
  void stopBall() { //stops the ball and gets it ready for being able to be picked up
   this.vel = new PVector(0, 0); 
   this.airborne = false;
   this.onGround = true;
   
  }
  
  void ballThrown() {
    this.holder = null;
    this.inHand = false;
    this.airborne = true;
    
    if (this.team == sketch.red) //switch teams of the ball so it can determine if it hits someone on the other team.
      this.team = sketch.blue;
    else if (this.team == sketch.blue)
      this.team = sketch.red;

    
  }
  
  
  void ballGrabbed(Player p) {
    this.inHand = true;
    this.onGround = false;
    this.holder = p;
    this.pos = new PVector(p.pos.x, p.pos.y);
  }
  
  boolean hitPlayer() {
    
    boolean hit = false;
    for (Player p : this.team.playersIn) {
      float distance = PVector.dist(p.pos, this.pos);
     
      if(distance<p.radius && this.team == p.team) { // whenever a ball is thrown, its team is the same as the enemy team it is heading towards. So its checking if it hits any players on the same team. 
        hit = true;
        p.out(this);
        break;
      }
      
    }

    return hit;
    
    
  }
  
  boolean inBounds() {
   return  this.pos.x>0+this.size*2 //size*2 so that the balls don't land outside of the player's reach
           && this.pos.x<sketch.width-this.size*2
           && this.pos.y>50+this.size*2
           && this.pos.y<sketch.height-this.size*2;
  }
   
}
