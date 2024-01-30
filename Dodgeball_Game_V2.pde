int numBallsPerTeam = 3; //balls per team
int numPlayersPerTeam = 5; //players per team
//bug: rare, but when a player gets out very close to the middle line, the ball is unreachable

Ball[] balls= new Ball[numBallsPerTeam*2]; 
Team red, blue;
color green = color(0, 255, 0);
color yellow = color(0, 255, 255);
int radiusMultiplier = 5;
int time = 0;

void setup() {
  size(1000,700);
  background(211, 182, 156);
  ellipseMode(CENTER);
  textAlign(LEFT, TOP);
 
  //Team(name, numPlayers)
  red = new Team("red team", numPlayersPerTeam, color(255, 80, 50));
  blue = new Team("blue team", numPlayersPerTeam, color(50, 80, 255));
  
  for (int i=0; i<numPlayersPerTeam; i++) { //adding players to teams
   
    //Player(team, size, throwLevel, catchLevel)
    Player redPlayer = new Player(red, random(40,45), random(0.5,1), random(20,50), random(2,3));
    red.allPlayers[i] = redPlayer;
    red.addPlayer(red.allPlayers[i]); //adds player to playersIn list
    
    Player bluePlayer = new Player(blue, random(40, 45), random(0.5,1), random(20,50), random(2,3));
    blue.allPlayers[i] = bluePlayer;
    blue.addPlayer(blue.allPlayers[i]);
    
    
  }  
  
  //initial positions of players
    
    for (int i=0; i<numPlayersPerTeam; i++) {

      int yGap = (height-50)/(numPlayersPerTeam+1);
      int xGap = 50;
      red.allPlayers[i].pos = new PVector(width-xGap, 50+yGap+yGap*i);
     
      blue.allPlayers[i].pos = new PVector(xGap, 50+yGap+yGap*i);
  

    }
  
  for (int i=0; i<numBallsPerTeam; i++) {  //creating dodge balls

    //Ball(size, maxSpeed, color)
    Ball redsBall = new Ball(random(15, 18), random(5,7), color( random(255), random(255), random(255)), red);
    int randomPlayer = round(random(numPlayersPerTeam-1));
    while (red.allPlayers[randomPlayer].ballBeingHeld != null) { //while the random person picked already has a ball
      randomPlayer = round(random(numPlayersPerTeam-1));
    }
    red.allPlayers[randomPlayer].ballBeingHeld = redsBall; //gives the ball we just created to a random player on the red team.
    balls[i] = redsBall;
    balls[i].ballGrabbed(red.allPlayers[randomPlayer]);
  }
  
    //same with blue team
  for (int i=0; i<numBallsPerTeam; i++) {  //creating dodge balls
   
    Ball bluesBall = new Ball(random(15, 18), random(5,7), color( random(255), random(255), random(255)), blue);
    int randomPlayer2 = round(random(numPlayersPerTeam-1));
    while (blue.allPlayers[randomPlayer2].ballBeingHeld != null) { 
      randomPlayer2 = round(random(numPlayersPerTeam-1));
    }
    blue.allPlayers[randomPlayer2].ballBeingHeld = bluesBall; 
    balls[i+numBallsPerTeam] = bluesBall;
    balls[i+numBallsPerTeam].ballGrabbed(blue.allPlayers[randomPlayer2]);
    
  }
 
}

void draw() {
  background(211, 182, 156);
  for (Player p : red.allPlayers) {
    p.drawMe();
    p.move();
  }
  for (Player p : blue.allPlayers) {
   p.drawMe();
   p.move();
  }
  for (Ball b : balls) {
   b.drawMe(); 
   b.move();
  }
  red.printPlayersOut();
  blue.printPlayersOut();
  
  time += 1;
  if (time % 500 ==0 ){//used to increase radiusMultiplier as the game goes on so that it doesn't take forever for the players to find a ball.
    radiusMultiplier += 1;
  }
  if (red.playersIn.size() ==0 || blue.playersIn.size() ==0) {
    println("a team has won!");
    noLoop();
  }
    

  
  
  stroke(255);
  line(0,50, width, 50);//top line
  line(width/2, 50, width/2, height); //middle line
 
}
