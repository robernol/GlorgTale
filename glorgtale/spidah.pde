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
  if (s.get(i).health <= 0){
    s.remove(i);
  }
}

void spidahFollow(Spidah s, PVector p){
  
  PVector v = new PVector (0, 0);
  
  v.x = (p.x - s.Pos.x);
  v.y = (p.y - s.Pos.y);
  
  v.normalize();
  
  s.Vel.x += v.x/2;
  s.Vel.y += v.y/2;
  
  s.Vel.x *= 0.9;
  s.Vel.y *= 0.9;
    
}
