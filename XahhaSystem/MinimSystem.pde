/*
  Initialization about minim is located
  in this file. To enhance performance
  I didn't create additional class.
*/
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

// Global Resource
Minim         minim;
AudioPlayer   minim_audioPlayer;
AudioMetaData minim_meta;
FFT[]         minim_fft;
final int     AUDIO_BUF_SIZE = 2048;
EnvelopeFollower[][] minim_env;
EnvelopeFollower[] minim_mst_env; // LR

/*
  Initialize sound library minim.
  Please use in setup() function.
*/
void init_Minim()
{
  println("[Init] Minim initialization start");
  
  minim             = new Minim(this);
  minim_audioPlayer = null;
  minim_env         = null;
  
  // Error Check
  if(minim == null)
  {
    println("[Error] Minim initialization failed!!");
    exit();
  }
  
  println("[Init] Minim initialization done");
}

/*
  Load mp3 file to the current minim audio player.
*/
void loadMusicFile()
{
  File audioFile = loadFile("mp3");
  
  // Check whether input is valid or not.
  if(audioFile != null)
  {
    // Load music
    minim_audioPlayer = minim.loadFile(audioFile.getAbsolutePath(), AUDIO_BUF_SIZE);
    minim_meta        = minim_audioPlayer.getMetaData();
    
    minim_mst_env = new EnvelopeFollower[2];
    minim_mst_env[0] = new EnvelopeFollower(0.0f, 0.95f);
    minim_mst_env[1] = new EnvelopeFollower(0.0f, 0.95f);
    
    // Load FFT analyzer
    minim_fft = new FFT[2];
    minim_fft[0] = new FFT(AUDIO_BUF_SIZE, minim_audioPlayer.sampleRate());
    minim_fft[1] = new FFT(AUDIO_BUF_SIZE, minim_audioPlayer.sampleRate());
    
    // Initialize FFT Envelope Follower
    minim_env = new EnvelopeFollower[2][minim_fft[0].specSize()];
    for(int c = 0; c < 2; ++c)
    {
      for(int i = 0; i < minim_fft[0].specSize(); ++i)
      {
        // Second parameter reduce hi frequency's
        // over-generating behavior.
        // Since high-frequency components change too much
        // frequently, particles will be genearted
        // more than comfortable numbers.
        minim_env[c][i] = new EnvelopeFollower(0.0f, exp((-1.0f + 0.9f*(float)i/(minim_fft[0].specSize())) * 0.1f));
      }
    }
  }
  else
  {
    // Flush as null
    minim_audioPlayer = null;
    minim_fft         = null;
  }
}

/*
  Main computation of sound algorithm
*/
void loop_Minim()
{
  // Calculate Envelope Follower
  if(minim_audioPlayer != null)
  {
    // Assign Master Env
    for(int c = 0; c < 2; ++c)
    {
      float sum = 0;
      for(int f = 0; f < minim_fft[c].specSize()/8; ++f)
      {
        sum += minim_env[c][f].getCurrent();
      }
      sum *= 0.75f / AUDIO_BUF_SIZE;
      minim_mst_env[c].feed(sum);
    }
    
    // Adjust Particle Decay via sound amplitude
    P_DECAY = 0.999 - 0.099*(minim_mst_env[0].getCurrent() + minim_mst_env[1].getCurrent())*0.5;
    
    // Do FFT with current audio output
    minim_fft[0].forward(minim_audioPlayer.left);
    minim_fft[1].forward(minim_audioPlayer.right);
    
    // Assign spectrum value to envelope follower
    for(int c = 0; c < 2; ++c)
    {
      for(int i = 0; i < minim_fft[c].specSize(); ++i)
      {
        minim_env[c][i].feed(minim_fft[c].getBand(i));
      }
    }
  }
}

void playMusic()
{
  if(minim_audioPlayer != null)
  {
    minim_audioPlayer.play();
  }
}

int frame_count = 0;
void recordStart()
{
  if(minim_audioPlayer != null)
  { 
    // 
    minim_audioPlayer.rewind();
    minim_audioPlayer.play();
    frame_count = 0;
  }
}

void recordLoop()
{
  if(minim_audioPlayer != null && minim_audioPlayer.isPlaying())
  {
    saveFrame("frame2/" + nf(frame_count, 4) + ".tif");
    ++frame_count;
  }
}