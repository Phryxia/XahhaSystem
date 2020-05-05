/*
  Handling loading file morme easily.
*/
boolean file_isLoaded;
File file_loadedFile;

/*
  Load file and return it. If it fail to load, reutrn
  null.
*/
File loadFile(String extension)
{
  // Block Main Thread
  file_isLoaded = false;
  
  // Load File using selectInput
  selectInput("Please select " + extension + " file.", "_loadFile");
  
  // Wait until loading is done
  while(!file_isLoaded)
  {
    print();
  }
  
  // Check extension
  if(extension != null && !extension.equals(""))
  {
    // If the file has right extension, just return it.
    if(file_loadedFile != null && match(file_loadedFile.getAbsolutePath(), "(.)*\\." + extension) != null)
    {
      return file_loadedFile;
    }
    else
    {
      return null;
    }
  }
  else
  {
    // No file extension filter.
    return file_loadedFile;
  }
}

void _loadFile(File file)
{
  file_loadedFile = file;
  
  // Release the thread
  file_isLoaded = true;
}
