class Obstacle
{
  PVector position;
  int rwidth;
  int rheight;
  PVector center;
  
  int rwall;
  int bwall;
  int lwall;
  int twall;
  
  Obstacle(PVector pos, int w, int h)
  {
    position = new PVector(pos.x, pos.y);
    rwidth = w;
    rheight = h;
    center = new PVector(position.x + ((int)rwidth/2), position.y + ((int)rheight/2));
    rwall = (int)(position.x + rwidth);
    lwall = (int)position.x;
    bwall = (int)(position.y + rheight);
    twall = (int)position.y;
  }
  
  void show()
  {
    fill(100, 100, 100);
    stroke(100, 100, 100);
    rect(position.x, position.y, rwidth, rheight);
  }
}
