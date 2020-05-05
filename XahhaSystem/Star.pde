class Star extends Particle
{
  private color c;
  private float distance;
  
  public Star(float x, float y, float r, float e, float theta)
  {
    super(x, y, r, e, theta);
    
    c = color(0, 0, 1);
    distance = random(0, 1);
  }
  
  public void compute()
  {
    position.add(PVector.mult(direction, 0.1 * pow(P_DECAY, -10) * (1-distance)));
    
    if(position.x < -size)
    {
      position.x = width + size;
    }
    else if(position.x > width + size)
    {
      position.x = -size;
    }
  }
  
  public void draw()
  {
    noStroke();
    fill(hue(c), saturation(c), brightness(c), 1 - 0.8*distance);
    ellipse(x(), y(), size(), size());
  }
}

void createStar()
{
  Star temp;
  int amount = 200;
  for(int i = 0; i < amount; ++i)
  {
    temp = new Star(random(0, width), random(0, height), random(1, 2), 1, 0);
    particleFactory.addParticle(temp);
  }
}