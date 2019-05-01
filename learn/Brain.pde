class Brain
{
  PVector[] directions;
  int step = 0;
  
  Brain(int size)
  {
   directions = new PVector[size];
   randomize();
  }
  
  void randomize()
  {
    for (int i=0;i<directions.length;i++)
    {
      directions[i] = getRandomDirection();
    }
  }
  
  void mutate(float mutationRate)
  {
    step = 0;
    for (int i=0;i<directions.length;i++)
    {
      if (random(1) < mutationRate)
      {
        directions[i] = getRandomDirection();
      }
    }
  }
  
  PVector getRandomDirection()
  {
    return PVector.fromAngle(random(2*PI));
  }
  
}
