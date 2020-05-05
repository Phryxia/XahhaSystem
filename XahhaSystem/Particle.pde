/*
  Particle is an abstract concept of object
  like powder, molecur or something small.
  
  It has own energy and can move using them.
*/
float P_DECAY = 0.99f; // Global parameter to control particles speed
abstract class Particle
{
  protected float   size;
  protected float   energy;
  protected PVector position;
  public    PVector direction;
  
  public Particle(float x, float y, float r, float e, float theta)
  {
    position = new PVector(x, y);
    size     = r;
    energy   = e;
    direction = PVector.fromAngle(theta);
    
    // Assign to factory
    if(particleFactory != null)
    {
      particleFactory.addParticle(this);
    }
    else
    {
      println("[Warning] There is no instantiated particle factory. You must exectue init_Particle first.");
    }
  }
  
  public void setDirection(float theta)
  {
    direction.rotate(theta);
  }
  
  public float size()
  {
    return size;
  }
  
  public float x()
  {
    return position.x;
  }
  
  public float y()
  {
    return position.y;
  }
  
  public float energy()
  {
    return energy;
  }
  
  public abstract void draw();
  
  /*
    Compute the particle's movement
  */
  public void compute()
  {
    position.add(PVector.mult(direction, 10.0f*energy/size));
    energy *= P_DECAY;
    
    if(position.x < 0 || position.x > width || position.y < 0 || position.y > height)
    {
      energy = 0.0f;
    }
  }
}


