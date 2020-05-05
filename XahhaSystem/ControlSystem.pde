boolean[] keyTable;

final int PLAY_MUSIC = 0;

void init_KeySystem()
{
  keyTable = new boolean[4];
}

void keyPressed()
{
  if(keyTable != null)
  {
    switch(key)
    {
      case 'p':
        keyTable[PLAY_MUSIC] = true;
        break;
    }
  }
}

void keyReleased()
{
  if(keyTable != null)
  {
    switch(key)
    {
      case 'p':
        keyTable[PLAY_MUSIC] = false;
        
        playMusic();
        
        break;
    }
  }
}
