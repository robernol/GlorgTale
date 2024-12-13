void drawMenu(){
  background(0);
  image(home, width/2, height/2, 1200, 1200);
}
//text instance #1
void displayScore (float x, float y){
  //displays the level and score at the given coordinates
  fill(255);
  String s = "level:" + lvl + "  score:" + score;
  text (s, x, y);
}
//text instance #2
void displayHighScore (){
  //displays the high score on the start menu screen
  fill(255);
  String s = "High Score:" + highScore;
  text (s, width/2, height/24 * 23.7);
}
