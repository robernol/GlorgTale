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
