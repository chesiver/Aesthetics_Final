import ddf.minim.analysis.*;
import ddf.minim.*;

class MusicParser {
  AudioPlayer music;
  FFT fft;
  int frame = 0;

  int n = 10;
  // value of each histogram
  float[] hist = new float[n];
  float[][] colors = new float[n][3];
  
  boolean isPlaying = false;
  float rate;
  
  String FolderName = "data/";
  String FileName = "5566.mp3";
  String FilePath = FolderName + FileName;
  
  int interval = 8;
  
  MusicParser() {
    music = minim.loadFile(FilePath);
    rate = music.sampleRate();
    fft = new FFT(music.bufferSize(), music.sampleRate());
    fft.window(FFT.GAUSS);
  }
  
  void setN(int newN) {
    n = newN;
    hist = new float[n];
    colors = new float[n][3];
  }
  
  void play() {
    music.play();
    isPlaying = true;
    frame = 0;
  }
  
  void stopPlaying() {
    music.pause();
    isPlaying = false;
  }
  
  // update every "interval" frame
  void update() {
    if (!isPlaying) return;
    frame++;
    if (frame % interval == 0) {
      fft.forward( music.mix );
      float f = 55;
      for (int i = 0; i < n; ++i) {
        hist[i] = 0;
        for (int j = 0; j < 3; j++) colors[i][j] = 0;
        float tmp = f;
        int count = 9;
        for (int j = 0; j < count; ++j) {
          float amp = fft.getFreq(tmp);
          hist[i] = max(hist[i], amp);
          //hist[i] += amp;
          colors[i][j/3] += amp;
          tmp *= 2;
        }
        
        f *= pow(2, 1.0/n);
        //print(hist[i]+" ");
      }
      
      float minV = 10000;
      float maxV = 0;
      for (int i = 0; i < n; ++i) 
        for (int j = 0; j < 3; ++j){
          minV = min(colors[i][j], minV);
          maxV = max(colors[i][j], maxV);
        }
      
      if (maxV > 0) {
        for (int i = 0; i < n; ++i) 
          for (int j = 0; j < 3; ++j) {
            colors[i][j] = 255*(colors[i][j] - minV) / (maxV - minV);
          }
      }
      //println();
    }
  }
}