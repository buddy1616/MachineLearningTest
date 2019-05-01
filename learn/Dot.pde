class Dot implements Comparable
{
  Species species;
  PVector pos;
  PVector vel;
  PVector acc;
  Brain brain;
  boolean dead = false;
  boolean reachedGoal = false;
  color col = color(0);
  int dotSize = 4;
  int colSize = (int)dotSize / 2;

  float fitness;

  Dot(Species spec, color c, PVector coords)
  {
    species = spec;
    col = c;
    brain = new Brain(species.brainSize);
    pos = new PVector(coords.x, coords.y);
    vel = new PVector(0, 0);
    acc = vel;
  }
  
  int compareTo(Object o)
  {
    Dot dot = (Dot)o;
    if (fitness < dot.fitness) { return 1; }
    else if (fitness > dot.fitness) { return -1; }
    return 0;
  }

  void show()
  {
    fill(col);
    ellipse(pos.x, pos.y, dotSize, dotSize);
  }
  
  void move()
  {
    if (brain.step < brain.directions.length)
    {
      acc = brain.directions[brain.step];
      brain.step++;
      vel.add(acc);
      vel.limit(maxVelocity);
      pos.add(vel);
    }
    else
    {
      dead = true;
    }
  }

  void update()
  {
    if ((!dead) && (!reachedGoal))
    {
      move();
      if (pos.x < colSize || pos.y < colSize || pos.x > width - colSize || pos.y > height - colSize)
      {
        col = color(0, 0, 0);
        dead = true;
      }
      else if (dist(pos.x, pos.y, goal.x, goal.y) < 6)
      {
        col = color(0, 255, 0);
        reachedGoal = true;
      }
      for (int i=0;i<obstacles.length;i++)
      {
        if (didCollide(obstacles[i])) { dead = true; break; }
      }
    }
    else
    {
      calculateFitness();
    }
  }

  void calculateFitness()
  {
    if (reachedGoal) { fitness = 2.0 - ((float)brain.step / (float)species.brainSize); }
    else
    {
      float dotDist = dist(pos.x, pos.y, goal.x, goal.y);
      fitness = 1.0 - ((float)dotDist / (float)maxDist);
    }
  }
  
  boolean didCollide(Obstacle o)
  {
    if ((pos.x + colSize > o.position.x) && (pos.y + colSize > o.position.y)
        && (pos.x - colSize < o.position.x + o.rwidth) && (pos.y - colSize < o.position.y + o.rheight))
    {
      return true;
    }
    return false;
  }
}
