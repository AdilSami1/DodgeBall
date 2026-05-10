# Dodgeball Simulation
An autonomous 2D simulation built with Java 22 and Processing 4. The program simulates a match of dodgeball between two teams where each player moves and interacts based on custom logic, including pathfinding for ball retrieval and team revival mechanics. This project was created by me in 2023 entirely in Processing. I converted it into Java to easily execute the program once again.
<p align="center">
<img width="413" height="304" alt="Dodgeball-sim-gif-24" src="https://github.com/user-attachments/assets/f7c024b4-dfce-453e-901e-ccd91b31e106" />
</p>

## 🔵 Simulation Logic 🔴
#### **Match Rules**
  - **Teams:** 2 Teams of 5 starting with 3 balls each
  - **Elimination:** After getting **hit** by a ball, a player turns **grey** and moves to the sidelines
  - **Revival:** Upon **catching** a ball a player turns **green** and one sidelined teammate is **revived** into play
#### **Player Behaviour**
- **Movement:** Players move in random directions, bouncing off of borders
- **Searching:** If not holding a ball, players will search for balls within their **sight radius** (starts at 5x the player's radius, increasing as the game goes on)
- **Throwing:** Players will hold a ball for a set period, then will throw it at the position of a randomly select a player from the opposing team
  - If hit while holding a ball, the player will throw the held ball before moving to the sideline

## 🚀 Try it out!
**Prerequisites:** 
- Java Runtime Environment (JRE) 22 or later.
- Maven (if building from source code)

**Running the Application:**
1. Download ```dodgeball-simulation-1.0.jar``` from the **Releases** section.
2. Run ```java -jar dodgeball-simulation-1.0.jar``` in the appropriate directory, or simply double-click the file.

**Development & Build:**

To build the jar file yourself:
1. Clone the repository: ```git clone https://github.com/AdilSami1/DodgeBall.git```
2. Build the jar file: ```mvn clean package```

## 🪲 Known Issues
- Players may fail to redirect themselves upon colliding with a border, resulting in them going offscreen or getting stuck on the border
- Balls may get stuck on a border and become inaccessable to players
