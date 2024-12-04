PImage glorgWalk;

int x = 1;

void setup(){
  size(400,400);
  background(255);
  noStroke();
  imageMode(CENTER);
  glorgWalk = loadImage("glorg-down.png");
}

void draw(){
  rect(0, 0, 400, 400);
  image(glorgWalk, width/2, height/2, 100, 100, sheetX(x), sheetY(x), sheetX(x)+1600, sheetY(x)+1600);
  if (frameCount%10 == 0){
    x++;
  }
  if (x>4){
    x = 1;
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
  if (key == 'w'){
    glorgWalk = loadImage("glorg-up.png");
  }
  else if (key == 'a'){
    glorgWalk = loadImage("glorg-left.png");
  }
  else if (key == 's'){
    glorgWalk = loadImage("glorg-down.png");
  }
  else if (key == 'd'){
    glorgWalk = loadImage("glorg-right.png");
  }
}
