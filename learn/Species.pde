class Species
{
  int brainSize;
  float mutationRate;
  float atrophy;
  float fittestMinBreedRate;
  
  float averageFitness;
  float averageFitnessLastGen;

  Species(int brain, float mutate, float atr, float fitMinBreed)
  {
    brainSize = brain;
    mutationRate = mutate;
    atrophy = atr;
    fittestMinBreedRate = fitMinBreed;
    averageFitness = 0;
    mutate();
  }
  
  void mutate()
  {
    brainSize = max(1, brainSize + ((int)((brainSize * random(maxSpeciesDeviation)) * (random(2.0) - 1.0))));
    mutationRate = max(.005, mutationRate + (((mutationRate * random(maxSpeciesDeviation)) * (random(2.0) - 1.0))));
    atrophy = max(.1, atrophy + (((atrophy * random(maxSpeciesDeviation)) * (random(2.0) - 1.0))));
    fittestMinBreedRate = max(.1, fittestMinBreedRate + (((fittestMinBreedRate * random(maxSpeciesDeviation)) * (random(2.0) - 1.0))));
  }
  
  void updateFitness(float fit)
  {
    averageFitnessLastGen = averageFitness;
    averageFitness = fit;
    if (averageFitness - averageFitnessLastGen < averageFitnessLastGen + stagnationRate)
    {
      evolve();
    }
  }
  
  void evolve()
  {
    Species bestSpec = this;
    for (int i=0;i<species.length;i++)
    {
      if (species[i].averageFitness > bestSpec.averageFitness)
      {
        bestSpec = species[i];
      }
    }
    
    if (bestSpec != this)
    {
      int trait = (int)random(4);
      switch(trait)
      {
        case 0: brainSize += max(1, (bestSpec.brainSize - brainSize) * evolutionRate); break;
        case 1: mutationRate += (bestSpec.mutationRate - mutationRate) * evolutionRate; break;
        case 2: atrophy += (bestSpec.atrophy - atrophy) * evolutionRate; break;
        case 3: fittestMinBreedRate += (bestSpec.fittestMinBreedRate - fittestMinBreedRate) * evolutionRate; break;
      }
    }
  }
}
