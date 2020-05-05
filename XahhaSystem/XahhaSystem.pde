/*
  Xahha System is an integrated complex
  visualizing system which able to record
  these frame into png or something else.
  
  Xahha System is an unique for artist :
  Phryxia.
*/

Visualizer vis;
void settings()
{
  size(1280, 720, P2D);
}
void setup()
{
  // Do NOT TOUCH HERE
  init_Screen();
  init_Minim();
  init_Particle();
  init_KeySystem();
  
  loadMusicFile();
  
  vis = new Visualizer();
  
  particleFactory.setThreshold(0.1f);
  
  frameRate(60);
}

void draw()
{
  loop_Minim();
  drawBackground();
  
  vis.v_main();
  
  loop_Particle();
  
  drawMask();
}