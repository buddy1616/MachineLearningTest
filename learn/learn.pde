PVector[] startingPositions = new PVector[4];
color[] colors = new color[4];
Species[] species = new Species[4];
PVector goal;

Obstacle[] obstacles = new Obstacle[8];
int obstacleWidth = 25;

Population[] pops;

int frame = 0;
int populationSize = 1000;
/*
int baseBrainSize = 400;
float baseMutationRate = .01;
float baseAtrophy = .5;
float baseFitMinBreedrate = .25;
*/

int baseBrainSize = 379;
float baseMutationRate = .0099;
float baseAtrophy = .45;
float baseFitMinBreedrate = .271;


float maxSpeciesDeviation = .25;

float maxDist;
float maxVelocity = 5;

void setup()
{
  size(800,800);
  startingPositions[0] = new PVector(((int)width / 8), ((int)height / 8));
  startingPositions[1] = new PVector(width - ((int)width / 8), ((int)height / 8));
  startingPositions[2] = new PVector(((int)width / 8), height - ((int)height / 8));
  startingPositions[3] = new PVector(width - ((int)width / 8), height - ((int)height / 8));
  
  colors[0] = color(255, 0, 0);
  colors[1] = color(0, 0, 255);
  colors[2] = color(255, 0, 255);
  colors[3] = color(0, 255, 255);
  
  for (int i=0;i<species.length;i++)
  {
    species[i] = new Species(baseBrainSize, baseMutationRate, baseAtrophy, baseFitMinBreedrate);
  }
  
  goal = new PVector(width / 2, height / 2);
  
  maxDist = dist(goal.x, goal.y, width, height);
  //red team
  pops = new Population[4];
  for (int i=0;i<pops.length;i++)
  {
    int popSize = (int)(populationSize / pops.length);
    if (popSize < 1) { popSize = 1; }
    pops[i] = new Population(popSize, species[i], colors[i], startingPositions[i]);
  }
  
  int obstacleXLength = (int)(width/4 - (obstacleWidth * 2));
  int obstacleYLength = (int)(height/4 - (obstacleWidth * 2));

  //upper left corner
  obstacles[0] = new Obstacle(new PVector((int)width/4, height/4), obstacleXLength, obstacleWidth);
  obstacles[1] = new Obstacle(new PVector((int)width/4, height/4), obstacleWidth, obstacleYLength);

  //upper right corner
  obstacles[2] = new Obstacle(new PVector((int)width/4*3 - obstacleXLength, height/4), obstacleXLength, obstacleWidth);
  obstacles[3] = new Obstacle(new PVector((int)width/4*3 - obstacleWidth, height/4), obstacleWidth, obstacleYLength);

  //lower left corner
  obstacles[4] = new Obstacle(new PVector((int)width/4, height/4*3 - obstacleWidth), obstacleXLength, obstacleWidth);
  obstacles[5] = new Obstacle(new PVector((int)width/4, height/4*3 - obstacleYLength), obstacleWidth, obstacleYLength);

  //lower right corner
  obstacles[6] = new Obstacle(new PVector((int)width/4*3 - obstacleXLength, height/4*3 - obstacleWidth), obstacleXLength, obstacleWidth);
  obstacles[7] = new Obstacle(new PVector((int)width/4*3 - obstacleWidth, height/4*3 - obstacleYLength), obstacleWidth, obstacleYLength);

}


void draw()
{
  background(255);
  fill(255, 255, 0);
  ellipse(goal.x, goal.y, 10, 10);

  for (int i=0;i<obstacles.length;i++)
  {
      obstacles[i].show();
  }

  for (int i=0;i<pops.length;i++)
  {
    if (pops[i].allDotsDead())
    {
      pops[i].naturalSelection();
      pops[i].mutate();
    }

    pops[i].update();
    pops[i].show();
    textSize(14);
    fill(pops[i].col);
    text("Gen " + pops[i].generation, pops[i].startingCoords.x - ((int)width * .1), pops[i].startingCoords.y);
    text("Fit " + pops[i].species.averageFitness, pops[i].startingCoords.x - ((int)width * .1), pops[i].startingCoords.y + 14);
    text("Brain " + pops[i].species.brainSize, pops[i].startingCoords.x - ((int)width * .1), pops[i].startingCoords.y + 28);
    text("Mutate " + pops[i].species.mutationRate, pops[i].startingCoords.x - ((int)width * .1), pops[i].startingCoords.y + 42);
    text("Atrophy " + pops[i].species.atrophy, pops[i].startingCoords.x - ((int)width * .1), pops[i].startingCoords.y + 56);
    text("MinBreed " + pops[i].species.fittestMinBreedRate, pops[i].startingCoords.x - ((int)width * .1), pops[i].startingCoords.y + 70);
  }
  
  //saveFrame("frames/" + frame + ".tif");
  frame++;
 
}
