/*
  Initialization about processing sketch.
*/
PImage backgroundImage;
PImage DEFAULT_BG;
PFont  font_small;
PFont  font_midle;
PFont  font_large;
void init_Screen()
{
  println("[Init] Screen initialization start");
  colorMode(HSB, 1.0f);
  
  backgroundImage = null;
  DEFAULT_BG = loadImage("DefaultBG.png");
  
  font_small = createFont("HCR Dotum Bold", 12);
  font_midle = createFont("HCR Dotum Bold", 30);
  font_large = createFont("HCR Dotum Bold", 48);
  
  println("[Init] Screen initialization done");
}

/*
  Draw the most deepest layer of the system.
  
  It will draw loaded proper background image.
  If there is no such image, just draw default
  background image.
*/
void drawBackground()
{
  // Paint back as black
  background(0);
  
  // Use if the background image hasn't been loaded.
  if(backgroundImage != null)
  {
    image(backgroundImage, width/2 - backgroundImage.width/2, height/2 - backgroundImage.height/2);
  }
  else if(DEFAULT_BG != null)
  {
    image(DEFAULT_BG, width/2 - DEFAULT_BG.width/2, height/2 - DEFAULT_BG.height/2);
  }
  
  // Paint some text
  fill(1);
  textFont(font_small);
  text("Powered by XahhaSystem", width-150, height - 20);
  
  drawInfo();
}

void drawInfo()
{
  fill(1);
  
  // Draw MP3 Tag
  if(minim_audioPlayer != null)
  {
    // Title
    textFont(font_midle);
    String temp = "";
    String[] pat;
    if(minim_meta.author().equals(""))
    {
      // Search for last \ character
      int index = minim_meta.fileName().length() - 4; // Skip for .mp3
      while(index >= 0 && minim_meta.fileName().charAt(index) != '\\')
      {
        --index;
      }
      
      temp = minim_meta.fileName().substring(index + 1, minim_meta.fileName().length() - 4);
      
      text(temp, 30, height - 34);
    }
    else
    {
      text("by " + minim_meta.author(), 30, height - 34);
    }
    
    // Artist
    textFont(font_large);
    text(minim_meta.title(), 30, height - 82);
  }
}

/*
  To implement fade-in & fade-out.
  
  When music starts to play, screen will be fade in.
  At 10 seconds before music ends, fade-out would start.
*/
float mask = 0; // represented as alpha value, 0 ~ 1
void drawMask()
{
  // Only works when music is loaded
  if(minim_audioPlayer != null)
  {
    if(minim_audioPlayer.isPlaying() && minim_audioPlayer.length() - minim_audioPlayer.position() > 10000)
    {
      mask = min(mask + 0.01f, 1);
    }
    else
    {
      mask = max(mask - 0.0015f, 0);
    }
  }
  
  // Draw the mask
  noStroke();
  fill(0, 0, 0, 1 - mask);
  rect(0, 0, width, height);
}