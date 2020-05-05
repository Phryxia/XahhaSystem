class Cloud extends Particle
{
  public color c;
  
  public Cloud(float x, float y, float r, float e, float theta)
  {
    super(x, y, r, e, theta);
    
    t = random(100);
  }
  
  private float op = 0.0f;
  private float t;
  
  public void compute()
  {
    position.add(PVector.mult(direction, 10.0f*energy));
    position.y += size * 0.005 * sin(TWO_PI * t * 0.01f);
    
    if(position.x < -size || position.x > width+size || position.y < -size || position.y > height + size)
    {
      energy = 0.0f;
    }
    
    op_max = 0.1 + random(-0.05f, 0.13f);
    
    t += 0.1f;
    if(t > 100)
    {
      t = 0.0f;
    }
  }
  
  float op_max;
  public void draw()
  {
    noStroke();
    fill(hue(c), saturation(c), brightness(c), op);
    ellipse(x(), y(), size(), size());
    
    if(position.x > 200)
    {
      if(op < op_max)
      {
        op += 0.005;
      }
    }
    else
    {
      op -= 0.001;
    }
  }
}

void createCloud(float x, float y, float size, color c)
{
  Cloud temp;
  int amount = (int)random(1, 5);
  float energy = random(0.08, 0.14);
  for(int i=0; i<amount; ++i)
  {
    temp = new Cloud(x + random(-size, size), y + random(-size, size), size * random(1), energy + random(-0.01, 0.01), PI);
    temp.c = c;
    particleFactory.addParticle(temp);
  }
}
