class Obstacle
{
  PVector position;
  int rwidth;
  int rheight;
  
  Obstacle(PVector pos, int w, int h)
  {
    position = new PVector(pos.x, pos.y);
    rwidth = w;
    rheight = h;
  }
  
  void show()
  {
    fill(100, 100, 100);
    stroke(100, 100, 100);
    rect(position.x, position.y, rwidth, rheight);
  }
}
