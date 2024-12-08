void lvlSetup (int lvl){
  glorgPos = new PVector(width/2, height*0.85);
  glorgVel = new PVector(0, 0);
  for (int i = 0; i < lvl; i++){
    spidahs.add(new Spidah (random(2, 22) * width/24, (random(2, 18) * height/24)));
  }
  for (int i = 0; i < (lvl/2); i++){
    rocks.add(new Rock(random(2, 22) * width/24, (random(3, 18) * height/24)));
  }
  
}

void reset(){
  up = false;
  left = false;
  down = false;
  right = false;
  glorgHealth = 10;
  animFrame = 1;
  anim = false;
  menu = true;
  dead = false;
  countdown = false;
  count = 0;
  lvl = 1;
  score = 0;
  lvlComplete = false;
  iFrames = 0;
  invincibility = false;
  
  glorgWalk = glorgDown;
  glorgPos = new PVector(width/2, height*0.85);
  glorgVel = new PVector(0, 0);
  balls = new ArrayList<Slimeball>();
  rocks = new ArrayList<Rock>();
  spidahs = new ArrayList<Spidah>();
  lvlSetup(lvl);
}
