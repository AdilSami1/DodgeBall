
class Player {
  float size, radius, throwlevel, catchlevel, speed, greenTime, holdTime;
  color playerColor;
  boolean isOut, spottedBall;
  PVector pos, vel;
  Team team, opposingTeam;
  Ball ballBeingHeld, closestBall;
  
  Player ( Team t, float s, float tlvl, float clvl, float sp) {
    this.team = t;
    this.throwlevel = tlvl;
    this.catchlevel = clvl;
    this.isOut = false;
    this.size = s;
    this.speed = sp;
    this.vel = new PVector(this.speed, 0);
    this.radius = size/2;     
    this.playerColor = this.team.teamColor;
    this.greenTime = 0;
    if (this.team==red) 
      this.opposingTeam = blue; //useful for when choosing a target to throw ball at
    if (this.team==blue)
      this.opposingTeam = red;
  
  }
  
  void drawMe() {
   stroke(0);
   if (this.isOut)
     this.playerColor = color(200);
     
   else if (this.playerColor ==green) { //a player will breifly turn green when they catch a ball.
       if (this.greenTime> 1) {
         this.playerColor = this.team.teamColor;
         this.greenTime =0;
       }
       else {
        this.greenTime += 0.01; 
       }
   }
   else {
     this.playerColor = this.team.teamColor;
   }
   
   fill(this.playerColor);
   circle(this.pos.x, this.pos.y, this.size);
    
    
  }
  
  
  void move() {
   
   this.spottedBall = false;
   if (!this.isOut) {
      if (this.ballBeingHeld ==null) {
      this.lookForBall(); 
      
      if (this.spottedBall){
       this.grabBall(this.closestBall);
      }
      }
      
    
      
      if (this.ballBeingHeld != null) { //if holding a ball
        if (this.holdTime>1)
          throwBall(this.ballBeingHeld);
        else
          holdTime+=0.01; //holdTime is so that the player doesn't immediately throw the ball.
      }
      
      //picking a random direction
      if (!this.spottedBall && this.inBounds()) {
      float randNum = random(100);
      float randAngle = random(0, TWO_PI);
      if (randNum<3) 
        this.vel = new PVector(this.speed*cos(randAngle), this.speed*sin(randAngle));
      }
      
      if (!this.inBounds()) 
        this.vel.mult(-1); 
    
   }
   
   
   
    if (this.pos.y <= 25) //for when a player is out
      this.vel = new PVector(0, 0);
   
    this.pos.add(this.vel);
  }
  
  
  
  
  void out(Ball b) { //this is called whenever ball.hitPlayer() is true
    if (this.ballBeingHeld !=null) // if player has a ball when getting hit by another one, they will throw the ball before getting out
      throwBall(this.ballBeingHeld);
    
    float chance = random(100); //random chance to catch the ball that hit the player
    if (chance<=this.catchlevel) {
     this.grabBall(b); 
     this.playerColor = green;
     if(this.team.playersOut.size()>0){
       int latestPlayerOutIndex = this.team.playersOut.size()-1;
       this.team.playersOut.get(latestPlayerOutIndex).backIn(); //brings back the latest person that got out
     }
    }
    
    else{ //if catch fails, player is out
      this.team.playersIn.remove(this);
      this.team.playersOut.add(this);
      this.isOut = true;
      //this part is to make it so that the players line up at the top instead of stack on top of each other
      float xGap = (width/2)/numPlayersPerTeam;
      int numRedPlayersOut = red.playersOut.size();
      int numBluePlayersOut = blue.playersOut.size();
      
      //determining the direction of velocity to reach the out line
      PVector destination, displacement;
      if (this.team ==red) {
        destination = new PVector(width/2 + xGap*numRedPlayersOut, 25);
        displacement = PVector.sub(destination, this.pos);
      }
      else {
        destination = new PVector(xGap*numBluePlayersOut, 25);
        displacement = PVector.sub(destination, this.pos);
      }
        float angle = displacement.heading();
        this.vel = new PVector(this.speed*cos(angle), this.speed*sin(angle));
    }
    
    
  }
  
  void backIn() { //called in out(Ball b)
    this.team.playersOut.remove(this);
    this.team.playersIn.add(this);
    this.isOut = false;
    if (this.team==red)
      this.pos = new PVector((width/2+50), 100); //teleports the player back into the game (because of problems with boundries)
    else
      this.pos = new PVector(50, 100);
    
  }
  
  void throwBall(Ball b) { //called in move() and out(Ball b)
    int numPlayers = opposingTeam.playersIn.size();
    int randPlayer = round(random(numPlayers-1)); //a random player is chosen from the opposing team to throw the ball at
    //calculating the direction the ball will go in
    PVector displacement = PVector.sub(opposingTeam.playersIn.get(randPlayer).pos, b.pos);  
    float angle = displacement.heading();
    float ballSpeed = b.maxSpeed * this.throwlevel;
    b.vel = new PVector(ballSpeed*cos(angle), ballSpeed*sin(angle));
    
    this.ballBeingHeld = null;
    b.ballThrown();
    
  }
  
 
  void grabBall(Ball b) { //called in setup() and anytime a player spots a ball on the ground
   float distance = dist(b.pos.x, b.pos.y, this.pos.x, this.pos.y);
   if (distance<b.size){
     b.ballGrabbed(this); 
     this.ballBeingHeld = b;
     this.holdTime = 0;
   }
  }
  
  void lookForBall() { //search for any balls on the ground (has to be on same side as player)
    for (Ball b : balls) {
      if(b.onGround){
       if (this.team == b.team) { 
        float distance = dist(b.pos.x, b.pos.y, this.pos.x, this.pos.y);
        if(distance<this.radius*radiusMultiplier) { //each player has a sight radius of 5 times their radius (this increases as the game goes on)
          PVector displacement = PVector.sub(b.pos, this.pos);
          float angle = displacement.heading();
          this.vel = new PVector(this.speed*cos(angle), this.speed*sin(angle));
          this.spottedBall = true;
          this.closestBall = b;
        }
       }
    }
  }
  }

  
  boolean inBounds() {
    if (this.team ==blue) {
      return  this.pos.x>this.radius
              && this.pos.x<(width/2-this.radius) 
              && this.pos.y>(50+this.radius) 
              && this.pos.y<height-this.radius;
      
    }
   
    else { //red team boundries
      return  this.pos.x>(width/2+this.radius) 
              && this.pos.x<width-this.radius 
              && this.pos.y>50+this.radius 
              && this.pos.y<height-this.radius;
     
    }
  }
    
    
    
    
}
