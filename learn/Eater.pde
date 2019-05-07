class Eater
{
  PVector pos;
  PVector vel;
  PVector acc;
  int lifespan;
  int life = 0;
  int dotSize = 20;
  color col = color(0);
  int colSize = (int)dotSize / 2;

  Eater(PVector coords)
  {
    pos = new PVector(coords.x, coords.y);
    vel =  PVector.random2D();
    acc = new PVector(vel.x, vel.y);
    lifespan = 300 + ((int)random(500));
  }
  
  void update()
  {
    vel.add(acc);
    vel.limit(maxEaterVelocity);
    PVector testPos = new PVector(pos.x, pos.y).add(vel);
    for (int i=0;i<obstacles.length;i++)
    {
      if (didCollide(testPos, colSize, obstacles[i]))
      {
        bounce(testPos, obstacles[i]);
        break;
      }
    }
    pos.add(vel);
    life++;
  }
  
  void bounce(PVector p, Obstacle o)
  {
    if (((o.rwall < pos.x) && (o.rwall > p.x))
      || ((o.lwall > pos.x) && (o.lwall < p.x)))
    {
      vel.x = -vel.x;
      acc.x = -acc.x;
    }
    if (((o.bwall < pos.y) && (o.bwall > p.y))
      || ((o.twall > pos.y) && (o.twall < p.y)))
    {
      vel.y = -vel.y;
      acc.y = -acc.y;
    }
   
  }
  
  void show()
  {
    fill(col);
    ellipse(pos.x, pos.y, dotSize, dotSize);
  }
  
  void eat(Dot dot)
  {
    lifespan += 100 + (int)(lifespan * dot.fitness);
    acc = new PVector(dot.vel.x, dot.vel.y);
    acc.rotate(PI);
  }

}
