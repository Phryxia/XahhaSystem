import java.util.LinkedList;
import java.util.ListIterator;

ParticleFactory particleFactory;

/*
  Use this method to setup()
*/
void init_Particle()
{
  println("[Init] Particle initialization start");
  
  particleFactory = new ParticleFactory();
  
  println("[Init] Particle initialization done");
}

/*
  Use this method to loop() after drawBackground();
*/
void loop_Particle()
{
  particleFactory.draw();
}

/*
  Automatic management of particle
*/
class ParticleFactory
{
  private UnorderedList <Particle> particles;
  private float threshold = 0.1f;
  
  // Stores indexs to remove (when particle needs destroying)
  ArrayList <Integer> killList;
  
  /*
    Cosntructor
  */
  public ParticleFactory()
  {
    particles = new UnorderedList <Particle> ();
    
    killList = new ArrayList <Integer> (16);
  }
  
  /*
    Assign element
  */
  public void addParticle(Particle p)
  {
    particles.add(p);
  }
  
  /*
    Compute and draw included every particles
  */
  public void draw()
  {
    // Initialize the killing queue
    killList.clear();
    
    // Compute the particles
    Particle p;
    for(int i = 0; i < particles.size(); ++i)
    {
      p = particles.get(i);
      p.compute();
      p.draw();
      
      // If this particle doesn't have enough energy,
      // assign to killing queue.
      if(p.energy() < threshold)
      {
        killList.add(i);
      }
    }
    
    // Erase with killing queue
    particles.remove(killList);
  }
  
  public void setThreshold(float t)
  {
    threshold = t;
  }
}
