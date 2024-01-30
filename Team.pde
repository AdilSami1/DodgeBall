
class Team {
  String name;
  int numPlayers;
  color teamColor;
  Player[] allPlayers;
  ArrayList <Player> playersIn;
  ArrayList <Player> playersOut;
  
  Team ( String n, int numP, color c) {
    this.name = n;
    this.numPlayers = numP;
    this.allPlayers = new Player [numP];
    this.teamColor = c;
    this.playersIn = new ArrayList<Player>(numP); 
    this.playersOut = new ArrayList<Player>(numP); 

  }
  
  void addPlayer(Player p) {
   this.playersIn.add(p);
    
  }
  
  void printPlayersOut() { //displays number of players out for each team
   if (this.name.equals("red team")) {
     fill(255);
     textSize(40);
     text( this.playersOut.size(), width/2, 0);
   }
   else {
     fill(255);
     textSize(40);
     text(this.playersOut.size(), 0, 0);
   }
  }
  
  
}
