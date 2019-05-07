PVector[] startingPositions = new PVector[4];
color[] colors = new color[4];
Species[] species = new Species[4];
PVector goal;

Obstacle[] obstacles = new Obstacle[12];
int obstacleWidth = 25;
int boundaryWidth = 10;

Eater[] eaters = new Eater[4];
PVector[] eaterStartingPositions = new PVector[4]; 

Population[] pops;
float stagnationRate = .05;
float evolutionRate = .1;

int frame = 0;
int populationSize = 1000;

int baseBrainSize = 400;
float baseMutationRate = .01;
float baseAtrophy = .5;
float baseFitMinBreedrate = .25;


float maxSpeciesDeviation = .25;

float maxDist;
float maxVelocity = 6;
float maxEaterVelocity = 1;

PVector safeZonePos;
int safeZoneWidth;
int safeZoneHeight;


void setup()
{
  size(800,800);
  startingPositions[0] = new PVector(((int)width / 8), ((int)height / 8));
  startingPositions[1] = new PVector(width - ((int)width / 8), ((int)height / 8));
  startingPositions[2] = new PVector(((int)width / 8), height - ((int)height / 8));
  startingPositions[3] = new PVector(width - ((int)width / 8), height - ((int)height / 8));
  
  eaterStartingPositions[0] = new PVector(startingPositions[0].x + width / 4, startingPositions[0].y);
  eaterStartingPositions[1] = new PVector(startingPositions[1].x, startingPositions[1].y + height / 4);
  eaterStartingPositions[2] = new PVector(startingPositions[2].x, startingPositions[2].y - height / 4);
  eaterStartingPositions[3] = new PVector(startingPositions[3].x - width / 4, startingPositions[3].y);
  
  colors[0] = color(252, 157, 25);
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
  
  for (int i=0;i<eaters.length;i++)
  {
    eaters[i] = new Eater(eaterStartingPositions[i]);
  }
  
  
  int obstacleXLength = (int)(width/4 - (obstacleWidth * 2));
  int obstacleYLength = (int)(height/4 - (obstacleWidth * 2));

  //boundaries
  obstacles[0] = new Obstacle(new PVector(-boundaryWidth, -boundaryWidth), width + (boundaryWidth * 2), boundaryWidth);
  obstacles[1] = new Obstacle(new PVector(-boundaryWidth, -boundaryWidth), boundaryWidth, height + (boundaryWidth * 2));
  obstacles[2] = new Obstacle(new PVector(-boundaryWidth, height), width + (boundaryWidth * 2), boundaryWidth);
  obstacles[3] = new Obstacle(new PVector(width, -boundaryWidth), boundaryWidth, height + (boundaryWidth * 2));

  //upper left corner
  obstacles[4] = new Obstacle(new PVector((int)width/4, height/4), obstacleXLength, obstacleWidth);
  obstacles[5] = new Obstacle(new PVector((int)width/4, height/4), obstacleWidth, obstacleYLength);

  //upper right corner
  obstacles[6] = new Obstacle(new PVector((int)width/4*3 - obstacleXLength, height/4), obstacleXLength, obstacleWidth);
  obstacles[7] = new Obstacle(new PVector((int)width/4*3 - obstacleWidth, height/4), obstacleWidth, obstacleYLength);

  //lower left corner
  obstacles[8] = new Obstacle(new PVector((int)width/4, height/4*3 - obstacleWidth), obstacleXLength, obstacleWidth);
  obstacles[9] = new Obstacle(new PVector((int)width/4, height/4*3 - obstacleYLength), obstacleWidth, obstacleYLength);

  //lower right corner
  obstacles[10] = new Obstacle(new PVector((int)width/4*3 - obstacleXLength, height/4*3 - obstacleWidth), obstacleXLength, obstacleWidth);
  obstacles[11] = new Obstacle(new PVector((int)width/4*3 - obstacleWidth, height/4*3 - obstacleYLength), obstacleWidth, obstacleYLength);

  safeZonePos = new PVector(obstacles[4].position.x + obstacleWidth, obstacles[4].position.y + obstacleWidth);
  safeZoneWidth = (int)(obstacles[7].position.x + obstacleWidth - safeZonePos.x) - obstacleWidth;
  safeZoneHeight = (int)(obstacles[10].position.y + obstacleWidth - safeZonePos.y) - obstacleWidth;
}


void draw()
{
  background(255);
  
  fill(214, 255, 229);
  stroke(150, 181, 162);
  rect(safeZonePos.x, safeZonePos.y, safeZoneWidth, safeZoneHeight);

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
    
    for (int e=0;e<eaters.length;e++)
    {
      if ((eaters[e].life > eaters[e].lifespan)
        || inSafeZone(eaters[e].pos))
      {
        eaters[e] = new Eater(eaterStartingPositions[e]);
      }

      eaters[e].update();
      eaters[e].show();
    }
    
    
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

boolean didCollide(PVector pos, int colSize, Obstacle o)
{
  if ((pos.x + colSize > o.position.x) && (pos.y + colSize > o.position.y)
      && (pos.x - colSize < o.position.x + o.rwidth) && (pos.y - colSize < o.position.y + o.rheight))
  {
    return true;
  }
  return false;
}

boolean inSafeZone(PVector pos)
{
    if ((pos.x < safeZonePos.x + safeZoneWidth)
        && (pos.x > safeZonePos.x)
        && (pos.y < safeZonePos.y + safeZoneHeight)
        && (pos.y > safeZonePos.y))
    {
      return true;
    }
    return false;
}
