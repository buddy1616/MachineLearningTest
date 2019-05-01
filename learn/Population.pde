import java.util.Arrays;

class Population
{
  int generation;
  int popSize;
  Species species;
  color col = color(0, 0, 0);
  PVector startingCoords = new PVector(0, 0);
  Dot[] dots;

  float totalFitness = 0;
  Dot[] breedingPool = new Dot[0];
  Dot mostFit;

  Population(int size, Species spec, color c, PVector coords)
  {
    this.popSize = size;
    this.species = spec;
    this.col = c;
    this.startingCoords = new PVector(coords.x, coords.y);
    this.dots = new Dot[popSize];
    for (int i=0;i<popSize;i++)
    {
      this.dots[i] = new Dot(species, col, startingCoords);
    }
    this.mostFit = new Dot(species, col, startingCoords);
  }

  void show()
  {
    for (int i=0;i<this.dots.length;i++)
    {
      this.dots[i].show();
    }
  }

  void update()
  {
    for (int i=0;i<this.dots.length;i++)
    {
      this.dots[i].update();
    }
  }

  void mutate()
  {
    for (int i=0;i<this.dots.length;i++)
    {
      this.dots[i].brain.mutate(this.species.mutationRate);
    }
  }

  boolean allDotsDead()
  {
    for (int i=0;i<this.dots.length;i++)
    {
      if ((!this.dots[i].dead) && (!this.dots[i].reachedGoal))
      {
        return false;
      }
    }
    return true;
  }

  void naturalSelection()
  {
    for (int i=0;i<this.dots.length;i++)
    {
      this.dots[i].calculateFitness();
      if (this.dots[i].fitness > this.mostFit.fitness)
      {
        this.mostFit = dots[i];
      }
    }
    this.getBreedingPool();
    this.species.averageFitness = this.totalFitness / this.popSize;
    Dot[] newDots = new Dot[popSize];
    for (int i=0;i<newDots.length;i++)
    {
      newDots[i] = new Dot(this.species, this.col, this.startingCoords);
      newDots[i].brain.directions = this.selectParentDirections();
    }
    this.dots = newDots;
    this.species.saveGenetics();
    this.generation++;
  }

  void getBreedingPool()
  {
    int size = this.dots.length - (int)(this.dots.length * this.species.atrophy);
    if (size == 0) { size++; }
    
    Arrays.sort(this.dots);
    this.totalFitness = 0;
    
    ArrayList<Dot> r = new ArrayList<Dot>();
    for (int i=0;i<size;i++)
    {
      r.add(this.dots[i]);
      this.totalFitness += this.dots[i].fitness;
    }
    this.breedingPool = r.toArray(new Dot[size]);
  }

  PVector[] selectParentDirections()
  {
    PVector[] parentDirs = new PVector[0];
    if (random(1) < this.species.fittestMinBreedRate)
    {
      parentDirs = this.mostFit.brain.directions;
    }
    else
    {
      parentDirs = this.getRandomFitParent().brain.directions;
    }

    PVector[] dirs = new PVector[parentDirs.length];
    for (int i=0;i<parentDirs.length;i++)
    {
      dirs[i] = new PVector(parentDirs[i].x, parentDirs[i].y);
    }
    
    return dirs;
  }
  
  Dot getRandomFitParent()
  {
    float rand = random(this.totalFitness);
    float runningSum = 0;
    for (int i=0;i<this.breedingPool.length;i++)
    {
      runningSum += this.breedingPool[i].fitness;
      if (runningSum >= rand)
      {
        return this.breedingPool[i];
      }
    }
    return this.mostFit;
  }

}
