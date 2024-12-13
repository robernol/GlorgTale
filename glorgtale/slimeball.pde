class Slimeball {
  //takes the position of the player and the mouse position, and creates a normalized vector pointing in that direction.
  float speed = 5;
  float radius = 30;
  PVector Pos, Vel;
  Slimeball (float x, float y, float x2, float y2) {
    Pos = new PVector(0,0);
    Vel = new PVector(0,0);
    
    Pos.x = x;
    Pos.y = y;
    Vel.x = (x2-x);
    Vel.y = (y2-y);
    
    Vel.normalize();
  }

}

void shiftBalls(){
  //only 10 slimeballs can be on the screen at once
  if (balls.size()>10){
    balls.remove(0);
  }
}

void drawBalls(){
  //draws the slimeballs
  for (int i=0; i<balls.size(); i++){
    image(glorgShoot, balls.get(i).Pos.x, balls.get(i).Pos.y, 60, 60);
    balls.get(i).Pos.x += (balls.get(i).Vel.x)*ballSpeed;
    balls.get(i).Pos.y += (balls.get(i).Vel.y)*ballSpeed;
    
    
    ArrayList<Rock> r = getRock();
    ArrayList<Spidah> s = getSpidah();
    
    if (!(balls.size() <= i)){
      for (int j = 0; j < r.size(); j++){
        //for every rock, checks if a slimeball has collided, and removes it if so
        if (shootRock(balls.get(i), r.get(j))){
          balls.remove(i);
          enemyShot.play();
          break;
        }
      }
    }
    if (!(balls.size() <= i)){
      for (int j = 0; j < s.size(); j++){
        //for every spidah, checks if a slimeball has collided, and removes it if so
        if (shootSpidah(balls.get(i), s.get(j))){
          balls.remove(i);
          enemyShot.play();
          s.get(j).health--;
          //checks to see if it has died
          spidahDed(s, j);
          break;
        }
      }
    }
    if (!(balls.size() <= i)){
      //if the balls hit the walls, they will be removed
      if ((balls.get(i).Pos.x < width/24) || (balls.get(i).Pos.x > (width/24)*23) || (balls.get(i).Pos.y < height/24) || (balls.get(i).Pos.y > (height/24)*23)){
        balls.remove(i);
        enemyShot.play();
        enemyShot.amp(0.3);
        break;
      }
    }
  }
}
