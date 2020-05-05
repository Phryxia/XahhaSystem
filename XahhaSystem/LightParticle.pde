class LightParticle extends Particle
{
  private boolean colorMode = true;
  private color c;
  private int t;
  private float freq;
  private float phase;
  public LightParticle(float x, float y, float r, float e, float theta)
  {
    super(x, y, r, e, theta);
    
    if(colorMode)
    {
      c = color(random(1), random(1), 1);
    }
    else
    {
      c = color(0, 0, 1);
    }
    
    freq = random(0.5, 2);
    phase = random(0, PI);
  }
  
  public void changeColor(color c)
  {
    this.c = c;
  }
  
  public void draw()
  {
    float riffle = sin(TWO_PI * freq * (t++) / frameRate + phase);
    noStroke();
    fill(hue(c), saturation(c) * (0.8 - 0.2 * riffle), 0.9 + 0.1 * riffle, energy());
    ellipse(x(), y(), size(), size());
  }
}

void createExplosion(float x, float y, float intensity, int count, color c)
{
  LightParticle temp;
  for(int i=0; i<count; ++i)
  {
    temp = new LightParticle(x, y, random(5, 15), 3.0f * randomGaussian() * intensity, random(0, TWO_PI));
    temp.changeColor(c);
    particleFactory.addParticle(temp);
  }
}