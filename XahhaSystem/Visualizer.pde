/*
  This class is a mother module of the FFT analysis.
  This will helps users to make their own visual effect.
*/
class Visualizer
{
  public Visualizer()
  {
    createStar();
  }
  
  public final void v_main()
  {
    // If the audio player is loaded (=also loaded fft)
    if(minim_audioPlayer != null)
    {
      userBehaviour();
    }
  }
  
  /*
    You can use minim family without check for null pointer
  */
  ArrayList <EnvelopeFollower> query = new ArrayList <EnvelopeFollower> (256);
  ArrayList <Integer> queryF         = new ArrayList <Integer> (256);
  public void userBehaviour()
  {
    // Find for peak point of spectrum (freq dimension)
    query.clear();
    queryF.clear();
    
    int f_max = minim_fft[0].specSize();

    for(int f = 1; f < f_max - 1; ++f)
    {
      // Target Investigation for explosion
      // To enhance eye-candy quality, lower bands are always considered as peak.
      if(f <= f_max/16 ||
         minim_env[0][f].getCurrent() - minim_env[0][f-1].getCurrent() > 0.0f &&
         minim_env[0][f].getCurrent() - minim_env[0][f+1].getCurrent() > 0.0f)
      {
        query.add(minim_env[0][f]);
        queryF.add(f);
      }
      
      // Draw Line
      float x = map(log(f), 0, log(f_max), 300, 980);
      float y = AUDIO_BUF_SIZE * minim_env[0][f].getCurrent() * 0.0001; //exp((-f_max + f)*0.005)
      
      stroke(colorScheme1(f));
      line(x, height/2 - y, x, height/2 + y);
    }
    
    // Check whether it's attack or not
    EnvelopeFollower ef;
    int fpos;
    float freq;
    for(int i = 0; i < query.size(); ++i)
    {
      ef   = query.get(i);
      fpos = queryF.get(i);
      freq = minim_fft[0].indexToFreq(fpos);

      // If it's transient is big enough, do explosion
      // When total music volume is big, threshold will slightly decrease.
      if(ef.tRate() > 0.68f - 0.1f * minim_mst_env[0].getCurrent() + 0.32 * fpos / f_max)
      {
        createExplosion
        (
          map(log(fpos), 0, log(f_max), 300, 980),
          height/2,
          ef.getCurrent()/150.0f * pow(fpos, 0.5), int(30 / log(2 + fpos)),
          colorScheme1(fpos)
        );
      }
    }
    
    // Generate Cloud
    // If reverb side is big enough, do it.
    // To prevent low performance, clouds are generated only
    // once as 10 frame period.
    if((cloud_count = (cloud_count + 1) % 10) == 0)
    {
      float temp;
      for(int f = 1; f < minim_fft[0].specSize(); f += f + (int)random(2))
      {
        temp = abs(minim_env[0][f].getCurrent() - minim_env[1][f].getCurrent());
        
        if(temp > 10.0f)
        {
          createCloud(width, map(log(f + 1), 0, log(f_max), height - 150, 0), 2*temp, color(0.7f, 0.01f, 1.0f));
        }
      }
    }
    
    // Generate Star
  }
  
  int cloud_count = 0;
}

/*
  Rainbow Scheme
*/
color colorScheme1(int f_pos)
{
  return color(map(log(f_pos), 0, log(minim_fft[0].specSize()), 0, 1), 1, 1);
}

color colorScheme2(int f_pos)
{
  float t = map(log(f_pos), 0, log(minim_fft[0].specSize()), 0, 1);
  return color(0, 1 - t, 1);
}

float curveFunction(float x)
{
  return 4 * x * (1 - x);
}