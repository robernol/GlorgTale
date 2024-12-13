//to detect collision between slimeballs and rocks
boolean shootRock (Slimeball s, Rock r){
  float distX = s.Pos.x - r.Pos.x;
  float distY = s.Pos.y - r.Pos.y;
  float distance = sqrt((distX*distX) + (distY*distY));
  
  if (distance <= s.radius + r.radius){
    return true;
  }
  
  return false;
}
//collision between slimeballs and spidahs
boolean shootSpidah (Slimeball s, Spidah r){
  float distX = s.Pos.x - r.Pos.x;
  float distY = s.Pos.y - r.Pos.y;
  float distance = sqrt((distX*distX) + (distY*distY));
  
  if (distance <= s.radius + r.radius){
    //multiplies the spidahs velocity by -2
    r.Vel.x *= -2;
    r.Vel.y *= -2;
    return true;
  }
  
  return false;
}


//collision between player and rocks
boolean reachRock (PVector p, ArrayList<Rock> r){
  for (int i = 0; i < r.size(); i++){
    float distX = p.x - r.get(i).Pos.x;
    float distY = p.y - r.get(i).Pos.y;
    float distance = sqrt((distX*distX) + (distY*distY));
  
    if (distance <= 40 + r.get(i).radius){
      //reverses velocity
      glorgVel.x *= -1;
      glorgVel.y *= -1;
      return true;
    }
  }
  
  return false;
}
//player and spidahs
boolean reachSpidah (PVector p, ArrayList<Spidah> s){
  for (int i = 0; i < s.size(); i++){
    float distX = p.x - s.get(i).Pos.x;
    float distY = p.y - s.get(i).Pos.y;
    float distance = sqrt((distX*distX) + (distY*distY));
    
    if (distance <= 40 + s.get(i).radius){
      //adds 5 times the spidahs velocity to the player's
      glorgVel.x += s.get(i).Vel.x * 5;
      glorgVel.y += s.get(i).Vel.y * 5;
      return true;
    }
  }
  
  return false;
}


//spidahs and rocks
boolean spidahRock (Spidah s, ArrayList<Rock> r){
  for (int i = 0; i < r.size(); i++){
    float distX = s.Pos.x - r.get(i).Pos.x;
    float distY = s.Pos.y - r.get(i).Pos.y;
    float distance = sqrt((distX*distX) + (distY*distY));
  
    if (distance <= 40 + r.get(i).radius){
      //reverses velocity
      s.Vel.x *= -1;
      s.Vel.y *= -1;
      return true;
    }
  }
  
  return false;
}
