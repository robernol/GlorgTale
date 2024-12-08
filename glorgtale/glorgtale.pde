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
boolean anim = false;
int ballSpeed = 10;
int cooldown = 0;
int shootTime = 5;

boolean menu = true;
boolean dead = false;
boolean countdown = false;
int count = 0;
int lvl = 1;
int score = 0;
int highScore = 0;
PrintWriter HS;
boolean lvlComplete = false;

int iFrames = 0;
boolean invincibility = false;

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
  
  glorgUp = loadImage("glorg-up.png");
  glorgLeft = loadImage("glorg-left.png");
  glorgRight = loadImage("glorg-right.png");
  glorgDown = loadImage("glorg-down.png");
  
  glorgWalk = glorgDown;
  
  reticle = loadImage("reticle.png");
  
  if (!(loadStrings("highscore.txt") == null)){
    String[] read = (loadStrings("highscore.txt"));
    highScore = int(read[0]);
  }
  
  glorgShoot = new Gif(this, "slimeball.gif");
  glorgShoot.play();
  
  spidah = new Gif(this, "spidah.gif");
  spidah.play();
  
  glorgPos = new PVector(width/2, height*0.85);
  glorgVel = new PVector(0, 0);
  
  balls = new ArrayList<Slimeball>();
  rocks = new ArrayList<Rock>();
  spidahs = new ArrayList<Spidah>();
  
  home = loadImage("menu.png");
  death = loadImage("death.png");
  
  rock = loadImage("rock.png");
  
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
  
  lvlSetup(lvl);
}

void draw(){
  if (menu == true){
    if (!(mainMenu.isPlaying())){
      mainMenu.loop();
      mainMenu.amp(0.2);
    }
    drawMenu();
    displayHighScore();
  }
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
    if (!(mainTheme.isPlaying())){
      mainTheme.loop();
      mainTheme.amp(0.2);
    }
    
    background(0);
    
    int uX = width/24;
    int uY = height/24;
    
    fill(154, 176, 148);
    rect(uX*2, uY*2, uX*20, uY*20);
    fill(116, 128, 111);
    quad(0, 0, width, 0, uX*22, uY*2, uX*2, uY*2);
    fill(85, 92, 83);
    quad(0, height, width, height, uX*22, uY*22, uX*2, uY*22);
    fill(101, 110, 98);
    quad(0, 0, 0, height, uX*2, uY*22, uX*2, uY*2);
    quad(width, 0, width, height, uX*22, uY*22, uX*22, uY*2);
    
    fill(0);
    quad(uX*10, 0, uX*14, 0, uX*13, uY*2, uX*11, uY*2);
    
    if (!lvlComplete){
      fill(102, 101, 99);
      quad(uX*12+3, 0, uX*14-10, 0, uX*13-5, uY*2, uX*12+2, uY*2);
      quad(uX*10+10, 0, uX*12-3, 0, uX*12-2, uY*2, uX*11+5, uY*2);
    }
    else{
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
    
    drawBalls();
    
    if (invincibility == false){
      image(glorgWalk, glorgPos.x, glorgPos.y, 100, 100, sheetX(animFrame), sheetY(animFrame), sheetX(animFrame)+1600, sheetY(animFrame)+1600);
    }
    else{
      tint(255, 100, 100);
      if (((frameCount - iFrames >= 0) && (frameCount - iFrames <= 4)) || ((frameCount - iFrames >= 10) && (frameCount - iFrames <= 14)) || ((frameCount - iFrames >= 20) && (frameCount - iFrames <= 24)) || 
      ((frameCount - iFrames >= 30) && (frameCount - iFrames <= 34)) || ((frameCount - iFrames >= 40) && (frameCount - iFrames <= 44)) || ((frameCount - iFrames >= 50) && (frameCount - iFrames <= 54)) || 
      ((frameCount - iFrames >= 60) && (frameCount - iFrames <= 64)) || ((frameCount - iFrames >= 70) && (frameCount - iFrames <= 74)) || ((frameCount - iFrames >= 80) && (frameCount - iFrames <= 84))){
        image(glorgWalk, glorgPos.x, glorgPos.y, 100, 100, sheetX(animFrame), sheetY(animFrame), sheetX(animFrame)+1600, sheetY(animFrame)+1600);
      }
      if (frameCount - iFrames > 90){
        invincibility = false;
      }
    }
    if (anim == true){
      if (frameCount%10 == 0){
        animFrame++;
      }
      if (frameCount%20 == 0){
        walk.play();
        walk.amp(0.3);
      }
      if (animFrame>4){
        animFrame = 1;
      }
    }
    
    noTint();
    
    glorgVel.y *= 0.9;
    glorgVel.x *= 0.9;
    
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
    
    
    if (reachSpidah (glorgPos, spidahs)){
      if (invincibility == false){
        glorgHealth--;
        hurt.play();
      }
      if ((glorgHealth > 0) && (invincibility == false)){
        iFrames = frameCount;
        invincibility  = true;
      }
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
    
    if (reachRock (glorgPos, rocks)){
      walk.play();
    }
    
    for (int i = 0; i < rocks.size(); i++){
      image(rock, rocks.get(i).Pos.x, rocks.get(i).Pos.y, 100, 100);
    }
    
    
    for (int i = 0; i < spidahs.size(); i++){
      image(spidah, spidahs.get(i).Pos.x, spidahs.get(i).Pos.y, 100, 100);
    }
    
    glorgPos.y += glorgVel.y;
    glorgPos.x += glorgVel.x;
    
    if (!countdown){
      for (int i = 0; i < spidahs.size(); i++){
        spidahFollow(spidahs.get(i), glorgPos);
        spidahRock(spidahs.get(i), rocks);
        
        
        spidahs.get(i).Pos.x += spidahs.get(i).Vel.x;
        spidahs.get(i).Pos.y += spidahs.get(i).Vel.y;
      }
    }
    
    if ((spidahs.size() <= 0) && (lvlComplete == false)){
      door.play();
      door.amp(0.3);
      lvlComplete = true;
    }
    
    image(reticle, mouseX, mouseY, 50, 50);
    
    displayScore(width/5*4, height/24 * 1.7);
    
    //draw health bar
    fill(200);
    rect(0, 0, width/3, height/15); 
    fill(150);
    rect(10, 10, width/3 - 20, height/15 - 20);
    fill(255-(glorgHealth*glorgHealth*4), 0+(glorgHealth*glorgHealth*25), 0+(glorgHealth*10));
    rect(10, 10, ((width/3 - 20)/10)*glorgHealth, height/15 - 20);
  
  }
  
  
  if (countdown == true){
    if (frameCount - count < 20){
      image(three, width/2, height/2);
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
      countdown = false;
    }
  }
  
  
  
  
}


int sheetX (int f){
  if ((f == 1) || (f == 3)){
    return 0;
  }
  else{
    return 1600;
  }
}

int sheetY (int f){
  if ((f == 1) || (f == 2)){
    return 0;
  }
  else{
    return 1600;
  }
}

void keyPressed(){
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
