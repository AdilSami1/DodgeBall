package com.github.adilsami1;

import java.util.ArrayList;

public class Team {
    
  String name;
  int numPlayers;
  int teamColor;
  Player[] allPlayers;
  ArrayList <Player> playersIn;
  ArrayList <Player> playersOut;
  private MySketch sketch;
  
  Team (MySketch sketch, String n, int numP, int c) {
    this.sketch=sketch;
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
     sketch.fill(255);
     sketch.textSize(40);
     sketch.text( this.playersOut.size(), sketch.width/2, 0);
   }
   else {
     sketch.fill(255);
     sketch.textSize(40);
     sketch.text(this.playersOut.size(), 0, 0);
   }
  }
  
}
