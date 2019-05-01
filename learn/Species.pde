class Species
{
  int brainSize;
  float mutationRate;
  float atrophy;
  float fittestMinBreedRate;
  
  float averageFitness;
  float averageFitnessLastGen;
  
  int brainSizeLastGen;
  float mutationRateLastGen;
  float atrophyLastGen;
  float fittestMinBreedRateLastGen;

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

    saveGenetics();
  }
  
  void saveGenetics()
  {
    brainSizeLastGen = brainSize;
    mutationRateLastGen = mutationRate;
    atrophyLastGen = atrophy;
    fittestMinBreedRateLastGen = fittestMinBreedRate;
    averageFitnessLastGen = averageFitness;
  }
}
