//spidah has a position and velocity vector, as well as 3 health
class Spidah {
  float radius = 25;
  float health = 3;
  PVector Pos, Vel;
  Spidah (float x, float y){
    Pos = new PVector(x, y);
    Vel = new PVector(0, 0);
  }
}

void spidahDed(ArrayList<Spidah> s, int i){
  //if the spidah loses all it's health, it is removed and +250 score is added
  if (s.get(i).health <= 0){
    s.remove(i);
    score += 250;
    enemyDead.play();
    enemyDead.amp(0.4);
    enemyDead.rate(random(0.5, 2));
  }
}

void spidahFollow(Spidah s, PVector p){
  //calculates distance between a spidah and the player, normalizes this vector, and updates the velocity to make them follow the player
  
  PVector v = new PVector (0, 0);
  
  v.x = (p.x - s.Pos.x);
  v.y = (p.y - s.Pos.y);
  
  v.normalize();
  
  s.Vel.x += v.x/2;
  s.Vel.y += v.y/2;
  
  s.Vel.x *= 0.9;
  s.Vel.y *= 0.9;
    
}
