//rocks do not move, only require a position vector
class Rock {
  float radius = 40;
  PVector Pos;
  Rock (float x, float y){
    Pos = new PVector(x, y);
  }
}
