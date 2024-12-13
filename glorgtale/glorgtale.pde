//Music from Death Road to Canada
//SFX from Binding of Isaac and OpenGameArt.org
//Art assets by yours truly :]

import processing.sound.*;
import gifAnimation.*;
//import Sound and gifAnimation under Manage Libraries otherwise this will not run :P

//keeps track of which buttons are being held to determine velocity
boolean up = false;
boolean left = false;
boolean down = false;
boolean right = false;

//various images and gifs
PImage three;
PImage two;
PImage one;
PImage go;

PImage glorgWalk;

PImage glorgUp;
PImage glorgLeft;
PImage glorgRight;
PImage glorgDown;

PImage rock;

PImage reticle;

Gif glorgShoot;

Gif spidah;

//main menu and death screens
PImage home;
PImage death;

//music
SoundFile mainMenu;
SoundFile mainTheme;
SoundFile gameOver;

//sfx
SoundFile walk;
SoundFile start;
SoundFile door;
SoundFile shoot;
SoundFile enemyShot;
SoundFile enemyDead;
SoundFile hurt;

//the best font I could find
PFont pixel;

//Position and Velocity Vectors for Glorg
PVector glorgPos;
PVector glorgVel;
//Glorg's health
int glorgHealth = 10;

//variable storing which way Glorg should be facing
char direction;
//determines which frame of Glorg's animation to play, from 1-4
int animFrame = 1;
//determines wether the animation should be playing
boolean anim = false;
//speed of the slimeballs
int ballSpeed = 10;
//for calculating time between last shot
int cooldown = 0;
int shootTime = 5;

//game state variables
boolean menu = true;
boolean dead = false;
boolean countdown = false;
int count = 0;
int lvl = 1;
int score = 0;
int highScore = 0;
//highscore is written to and recieved from a txt file
PrintWriter HS;
boolean lvlComplete = false;

//for use in iframes after getting hit
int iFrames = 0;
boolean invincibility = false;

//the arraylists of the objects in the game
ArrayList<Slimeball> balls;
ArrayList<Rock> rocks;
ArrayList<Spidah> spidahs;


void setup(){
  noCursor();
  textSize(80);
  textAlign(CENTER);
  imageMode(CENTER);
  fullScreen();
  background(255);
  noStroke();
  imageMode(CENTER);
  
  pixel = loadFont("OCRAExtended-80.vlw");
  textFont (pixel, 60);
  
  //different spritesheets for the different directions
  glorgUp = loadImage("glorg-up.png");
  glorgLeft = loadImage("glorg-left.png");
  glorgRight = loadImage("glorg-right.png");
  glorgDown = loadImage("glorg-down.png");
  
  //start facing down
  glorgWalk = glorgDown;
  
  reticle = loadImage("reticle.png");
  
  //if possible, reads from the highscore txt file 
  if (!(loadStrings("highscore.txt") == null)){
    String[] read = (loadStrings("highscore.txt"));
    highScore = int(read[0]);
  }
  
  glorgShoot = new Gif(this, "slimeball.gif");
  glorgShoot.play();
  
  spidah = new Gif(this, "spidah.gif");
  spidah.play();
  
  //sets position and velocity vectors
  glorgPos = new PVector(width/2, height*0.85);
  glorgVel = new PVector(0, 0);
  
  balls = new ArrayList<Slimeball>();
  rocks = new ArrayList<Rock>();
  spidahs = new ArrayList<Spidah>();
  
  home = loadImage("menu.png");
  death = loadImage("death.png");
  
  rock = loadImage("rock.png");
  
  //countdown images
  three = loadImage("3.png");
  two = loadImage("2.png");
  one = loadImage("1.png");
  go = loadImage("glorg!.png");
  
  mainMenu = new SoundFile(this, "MainMenu.mp3");
  mainTheme = new SoundFile(this, "MainTheme.mp3");
  gameOver = new SoundFile(this, "GameOver.mp3");

  walk = new SoundFile(this, "GlorgStep.mp3");
  start = new SoundFile(this, "GLORG!.mp3");
  door = new SoundFile(this, "DoorOpen.mp3");
  shoot = new SoundFile(this, "GlorgShoot.mp3");
  enemyShot = new SoundFile(this, "EnemyHit.mp3");
  enemyDead = new SoundFile(this, "EnemyKill.wav");
  hurt = new SoundFile(this, "GlorgHurt.mp3");
  
  //sets up the level based on the level number, +1 spidah each level and +1 rock every 2 levels
  lvlSetup(lvl);
}

void draw(){
  //if the menu state is true, displays the main menu
  if (menu == true){
    if (!(mainMenu.isPlaying())){
      mainMenu.loop();
      mainMenu.amp(0.2);
    }
    drawMenu();
    displayHighScore();
  }
  //otherwise if the dead state is true, displays death screen and writes highscore to file if it is higher
  else if (dead == true){
    if (score >= highScore){
      highScore = score;
      HS = createWriter("highscore.txt");
      HS.println(highScore);
      HS.flush();
      HS.close();
    }
    background(0);
    image(death, width/2, height/2, 1500, 1000);
    displayScore(width/2, height/24 * 23.7);
  }
  else{
    //draws the game
    if (!(mainTheme.isPlaying())){
      mainTheme.loop();
      mainTheme.amp(0.2);
    }
    
    background(0);
    
    //to make things a bit easier
    int uX = width/24;
    int uY = height/24;
    
    //draw the floor and walls
    //game is fullscreen so it should work fairly well on a variety of monitors
    fill(154, 176, 148);
    rect(uX*2, uY*2, uX*20, uY*20);
    fill(116, 128, 111);
    quad(0, 0, width, 0, uX*22, uY*2, uX*2, uY*2);
    fill(85, 92, 83);
    quad(0, height, width, height, uX*22, uY*22, uX*2, uY*22);
    fill(101, 110, 98);
    quad(0, 0, 0, height, uX*2, uY*22, uX*2, uY*2);
    quad(width, 0, width, height, uX*22, uY*22, uX*22, uY*2);
    
    //exit door
    fill(0);
    quad(uX*10, 0, uX*14, 0, uX*13, uY*2, uX*11, uY*2);
    
    //doors are closed if level is not complete
    if (!lvlComplete){
      fill(102, 101, 99);
      quad(uX*12+3, 0, uX*14-10, 0, uX*13-5, uY*2, uX*12+2, uY*2);
      quad(uX*10+10, 0, uX*12-3, 0, uX*12-2, uY*2, uX*11+5, uY*2);
    }
    else{
      //if level is complete, draws an "E" button when at the exit door signifying how to move to next level
      if ((glorgPos.x > (width/24)*9) && (glorgPos.x < (width/24)*14) && (glorgPos.y > (height/24)*1) && (glorgPos.y < (height/24)*6)){
        
        fill(200);
        rect((width/2)-120, (height/2)-100, 240, 240, 20);
        fill(130, 255, 180);
        rect((width/2)-100, (height/2)-100, 200, 200, 20);
        fill(255);
        
        rect((width/2) - 50, (height/2) - 70, 30, 140, 5);
        rect((width/2) - 50, (height/2) - 70, 100, 30, 5);
        rect((width/2) - 50, (height/2) - 15, 100, 30, 5);
        rect((width/2) - 50, (height/2) + 40, 100, 30, 5);
        
        rect((width/2) - 20, (height/2) - 300, 40, 100);
        triangle((width/2) - 50, (height/2) - 300, (width/2) + 50, (height/2) - 300, (width/2), (height/2) - 350); 
      }
    }
   
    //if one or more of these variables are true, velocity is increased in that direction by one every frame
    if (up == true){
      glorgVel.y -= 1;
    }
    if (down == true){
      glorgVel.y += 1;
    }
    if (left == true){
      glorgVel.x -= 1;
    }
    if (right == true){
      glorgVel.x += 1;
    }
    
    //draws the slimeballs and checks their collision
    drawBalls();
    
    //normal drawing of glorg
    if (invincibility == false){
      image(glorgWalk, glorgPos.x, glorgPos.y, 100, 100, sheetX(animFrame), sheetY(animFrame), sheetX(animFrame)+1600, sheetY(animFrame)+1600);
    }
    else{
      //if hurt, draws glorg with a red tint flashing every 5 frames
      tint(255, 100, 100);
      if (((frameCount - iFrames >= 0) && (frameCount - iFrames <= 4)) || ((frameCount - iFrames >= 10) && (frameCount - iFrames <= 14)) || ((frameCount - iFrames >= 20) && (frameCount - iFrames <= 24)) || 
      ((frameCount - iFrames >= 30) && (frameCount - iFrames <= 34)) || ((frameCount - iFrames >= 40) && (frameCount - iFrames <= 44)) || ((frameCount - iFrames >= 50) && (frameCount - iFrames <= 54)) || 
      ((frameCount - iFrames >= 60) && (frameCount - iFrames <= 64)) || ((frameCount - iFrames >= 70) && (frameCount - iFrames <= 74)) || ((frameCount - iFrames >= 80) && (frameCount - iFrames <= 84))){
        image(glorgWalk, glorgPos.x, glorgPos.y, 100, 100, sheetX(animFrame), sheetY(animFrame), sheetX(animFrame)+1600, sheetY(animFrame)+1600);
      }
      //after 90 frames invincibility stops
      if (frameCount - iFrames > 90){
        invincibility = false;
      }
    }
    //if the animation should be playing, goes to next animation frame every 10 frames
    if (anim == true){
      if (frameCount%10 == 0){
        animFrame++;
      }
      //every 20 frames of the animation plays a walking sound
      if (frameCount%20 == 0){
        walk.play();
        walk.amp(0.3);
      }
      //if the animation frame goes over 4, gets reset back to 1.
      if (animFrame>4){
        animFrame = 1;
      }
    }
    
    noTint();
    //slightly decreases velocity each frame
    glorgVel.y *= 0.9;
    glorgVel.x *= 0.9;
    
    //wall collision, sets the appropriate velocity to 0 and brings glorg back in bounds
    if (glorgPos.x < (width/24)*2){
      glorgVel.x = 0;
      glorgPos.x = (width/24)*2;
    }
    else if (glorgPos.x > (width/24)*22){
      glorgVel.x = 0;
      glorgPos.x = (width/24)*22;
    }
    
    if (glorgPos.y < (height/24)*2){
      glorgVel.y = 0;
      glorgPos.y = (height/24)*2;
    }
    else if (glorgPos.y > (height/24)*21.3){
      glorgVel.y = 0;
      glorgPos.y = (height/24)*21.3;
    }
    
    //checks if the player has collided with a spidah, if so reduces health by one as long as the player is not already in iframes, and begins iframes
    if (reachSpidah (glorgPos, spidahs)){
      if (invincibility == false){
        glorgHealth--;
        hurt.play();
      }
      if ((glorgHealth > 0) && (invincibility == false)){
        iFrames = frameCount;
        invincibility  = true;
      }
      //if glorg has died, game ends
      if (glorgHealth <= 0){
        mainTheme.stop();
        start.play();
        if (!(gameOver.isPlaying())){
          gameOver.loop();
          gameOver.amp(0.2);
        }
        dead = true; 
      }
    }
    
    //checks if the player has collided with a rock
    if (reachRock (glorgPos, rocks)){
      walk.play();
    }
    
    //drawing all the rocks in the arraylist
    for (int i = 0; i < rocks.size(); i++){
      image(rock, rocks.get(i).Pos.x, rocks.get(i).Pos.y, 100, 100);
    }
    
    //drawing all the spidahs
    for (int i = 0; i < spidahs.size(); i++){
      image(spidah, spidahs.get(i).Pos.x, spidahs.get(i).Pos.y, 100, 100);
    }
    
    //glorg's velocity is added to his position each frame
    glorgPos.y += glorgVel.y;
    glorgPos.x += glorgVel.x;
    
    //if the countdown at the start of each level is not active, updates the spidahs position each frame
    if (!countdown){
      for (int i = 0; i < spidahs.size(); i++){
        spidahFollow(spidahs.get(i), glorgPos);
        spidahRock(spidahs.get(i), rocks);
        
        
        spidahs.get(i).Pos.x += spidahs.get(i).Vel.x;
        spidahs.get(i).Pos.y += spidahs.get(i).Vel.y;
      }
    }
    
    //when all spidahs n a level are completed, the door opens and you can progress to the next level
    if ((spidahs.size() <= 0) && (lvlComplete == false)){
      door.play();
      door.amp(0.3);
      lvlComplete = true;
    }
    
    //slime reticle
    image(reticle, mouseX, mouseY, 50, 50);
    
    //prints level and score on the top right during gameplay
    displayScore(width/5*4, height/24 * 1.7);
    
    //draw health bar
    fill(200);
    rect(0, 0, width/3, height/15); 
    fill(150);
    rect(10, 10, width/3 - 20, height/15 - 20);
    //finally figured out how to make this bit look good
    fill(255-(glorgHealth*glorgHealth*4), 0+(glorgHealth*glorgHealth*25), 0+(glorgHealth*10));
    rect(10, 10, ((width/3 - 20)/10)*glorgHealth, height/15 - 20);
  
  }
  
  //if countdoun is true, displays 3, 2, 1, GLORG! for 20 frames each
  if (countdown == true){
    if (frameCount - count < 20){
      image(three, width/2, height/2);
      //also plays a sound effect when each image appears
      if (frameCount - count == 1){
        walk.play();
      }
    }
    else if (frameCount - count < 40){
      image(two, width/2, height/2);
      if (frameCount - count == 21){
        walk.play();
      }
    }
    else if (frameCount - count < 60){
      image(one, width/2, height/2);
      if (frameCount - count == 41){
        walk.play();
      }
    }
    else if (frameCount - count < 80){
      if (frameCount - count == 61){
        enemyShot.play();
      }
      image(go, width/2, height/2, 1195, 337);
    }
    else{
      //after 80 frames countdown ends
      countdown = false;
    }
  }
  
  
  
  
}

//returns the start of the pixel range on the x axis for each frame of the animation
int sheetX (int f){
  if ((f == 1) || (f == 3)){
    return 0;
  }
  else{
    return 1600;
  }
}

//same with the y axis
int sheetY (int f){
  if ((f == 1) || (f == 2)){
    return 0;
  }
  else{
    return 1600;
  }
}

void keyPressed(){
  //pressing a directional input makes you face that direction, begins increasing velocity in that direction, and plays the walk animation if not already active
  if (((key == 'w') || (key == 'W')) && (menu == false) && (countdown == false)){
    up = true;
    glorgDirection(key);
    direction = 'w';
    anim = true;
  }
  if (((key == 'a') || (key == 'A')) && (menu == false) && (countdown == false)){
    left = true;
    glorgDirection(key);
    direction = 'a';
    anim = true;
  }
  if (((key == 's') || (key == 'S')) && (menu == false) && (countdown == false)){
    down = true;
    glorgDirection(key);
    direction = 's';
    anim = true;
  }
  if (((key == 'd') || (key == 'D')) && (menu == false) && (countdown == false)){
    right = true;
    glorgDirection(key);
    direction = 'd';
    anim = true;
  }
  //navigates from the main menu to begin gameplay, or from the death screen to the main menu theme
  if (key == ' ') {
    if (menu == true){
      mainMenu.stop();
      menu = false;
      countdown = true;
      count = frameCount;
    }
    else if (dead == true){
      gameOver.stop();
      dead = false;
      reset();
      menu = true;
    }
  }
  //when e is pressed and the conditions are correct, goes to next level. Array of rocks is reset to be populated by new ones, and the level is set up again.
  if ((key == 'e') || (key == 'E')){
    if ((glorgPos.x > (width/24)*9) && (glorgPos.x < (width/24)*15) && (glorgPos.y > (height/24)*1) && (glorgPos.y < (height/24)*6) && (lvlComplete = true)){
      lvl++;
      rocks = new ArrayList<Rock>();
      lvlSetup(lvl);
      countdown = true;
      count = frameCount;
      left = false;
      up = false;
      right = false;
      down = false;
      anim = false;
      lvlComplete = false;
    }
  }
}


//lets the game know when to stop increasing velocity, and if no other direction is held, to stop playing the walk animation
void keyReleased(){
  if (key == 'w'){
    up = false;
    if(noDirectionHeld()){
      anim = false;
    }
  }
  else if (key == 'a'){
    left = false;
    if(noDirectionHeld()){
      anim = false;
    }
  }
  else if (key == 's'){
    down = false;
    if(noDirectionHeld()){
      anim = false;
    }
  }
  else if (key == 'd'){
    right = false;
    if(noDirectionHeld()){
      anim = false;
    }
  }
}

//determines if there are any other directions being held, not very well might I add
boolean noDirectionHeld (){
  if (keyPressed == false){ 
    return true;
  }
  else{
    if ((key == 'w') || (key == 'a') || (key == 's') || (key == 'd')){
      return false;
    }
    else{
      return true;
    }
  }
}

//changes which spritesheet to use based on the direction glorg should be facing.
void glorgDirection(char d){
  if ((d == 'w') && (!(direction == 'w'))){
    glorgWalk = glorgUp;
  }
  else if ((d == 'a') && (!(direction == 'a'))){
    glorgWalk = glorgLeft;
  }
  else if ((d == 's') && (!(direction == 's'))){
    glorgWalk = glorgDown;
  }
  else if ((d == 'd') && (!(direction == 'd'))){
    glorgWalk = glorgRight;
  }
}

//when the mouse is pressed, creates a slimeball with trajectory based on the mouse position
void mousePressed(){
  if  ((menu == false) && (countdown == false)){
    if ((frameCount - cooldown) > shootTime){
      shoot.play();
      shiftBalls();
      balls.add(new Slimeball (glorgPos.x, glorgPos.y, mouseX, mouseY));
      cooldown = frameCount;
    }
  }
}

ArrayList<Rock> getRock(){
  return rocks;
}
ArrayList<Spidah> getSpidah(){
  return spidahs;
}
