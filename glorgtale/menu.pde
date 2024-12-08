void drawMenu(){
  background(0);
  image(home, width/2, height/2, 1200, 1200);
}

void displayScore (float x, float y){
  fill(255);
  String s = "level:" + lvl + "  score:" + score;
  text (s, x, y);
}

void displayHighScore (){
  fill(255);
  String s = "High Score:" + highScore;
  text (s, width/2, height/24 * 23.7);
}
