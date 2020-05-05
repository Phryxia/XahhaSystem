/*
  This will follow input streme smoothly.
  Useful when you want to make envelope
  follower.
*/
class EnvelopeFollower
{
  private float rate;
  private float[] record;
  
  /*
    Constructor.
    Valid rate : 0 < rate < 1
  */
  public EnvelopeFollower(float init_value, float rate)
  { 
    record = new float[4];
    record[0] = abs(init_value);
    this.rate = rate;
  }
  
  /*
    Add next value to this follower.
    Result is equivalent to getcurrent()
  */
  public float feed(float data)
  {
    // Shift to prev memory variable
    shift();
    
    // Damping
    data = abs(data);
    if(data >= record[0])
    {
      record[0] = data;
    }
    else
    {
      record[0] *= rate;
    }
    
    return record[0];
  }
  
  private void shift()
  {
    for(int i=2; i>=0; --i)
    {
      record[i+1] = record[i];
    }
  }
  
  public float getCurrent()
  {
    return record[0];
  }
  
  public float getPrev()
  {
    return record[1];
  }
  
  public float getDifference()
  {
    return record[0] - record[1];
  }
  
  public boolean isPeak()
  {
    return record[1] - record[0] > 0.0f && record[1] - record[2] > 0.0f;
  }
  
  public String toString()
  {
    String result = "";
    for(int i=0; i<4; ++i)
    {
      result += record[i] + " ";
    }
    return result;
  }
  
  /*
    Transient Rate is defined as rate of delta to absolute value.
  */
  public float tRate()
  {
    return (record[1] - 0.5f*(record[2] + record[3]))/record[1];
  }
}
