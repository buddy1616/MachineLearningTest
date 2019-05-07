class Dot implements Comparable
{
  Species species;
  PVector pos;
  PVector vel;
  PVector acc;
  Brain brain;
  boolean dead = false;
  boolean eaten = false;
  boolean hitWall = false;
  int reachedGoal = 0;
  boolean safe = false;
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
    acc = new PVector(0, 0);
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
    if (dead)
    {
      if (eaten) { fill(255, 0, 0); }
      else { fill(0); }
    }
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
      if (inSafeZone(pos)) { safe = true; }
      dead = true;
    }
  }

  void update()
  {
    if (!dead)
    {
      move();
      if (dist(pos.x, pos.y, goal.x, goal.y) < 6)
      {
        reachedGoal++;
      }
      for (int i=0;i<obstacles.length;i++)
      {
        if (didCollide(pos, colSize, obstacles[i]))
        {
          dead = true;
          hitWall = true;
          break;
        }
      }
      for (int i=0;i<eaters.length;i++)
      {
        if (dist(pos.x, pos.y, eaters[i].pos.x, eaters[i].pos.y) < (dotSize / 2) + (eaters[i].dotSize / 2))
        {
          dead = true;
          eaten = true;
          eaters[i].eat(this);
          break;
        }
      }
    }
    else
    {
      calculateFitness();
    }
  }

  void calculateFitness()
  {
    float dotDist = dist(pos.x, pos.y, goal.x, goal.y);
    fitness = 1.0 - ((float)dotDist / (float)maxDist);
    fitness += 1 * reachedGoal; 

    if (safe) { fitness *= 1.5; }
    else if (eaten) { fitness /= 3; }
    else if (hitWall) { fitness /= 2; }
    
  }
 
}
