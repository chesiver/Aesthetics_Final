import ddf.minim.analysis.*;
import ddf.minim.*;

class MusicParser {
  AudioPlayer music;
  FFT fft;
  int frame = 0;

  int n = 5;
  // value of each histogram
  float[] hist = new float[n];
  
  boolean isPlaying = false;
  float rate;
  
  String FolderName = "data/";
  String FileName = "5566.mp3";
  String FilePath = FolderName + FileName;
  
  int interval = 4;
  
  MusicParser() {
    music = minim.loadFile(FilePath);
    rate = music.sampleRate();
    fft = new FFT(music.bufferSize(), music.sampleRate());
    fft.window(FFT.GAUSS);
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
        float tmp = f;
        while (tmp < rate/2) {
          float amp = fft.getFreq(tmp);
          hist[i] = max(hist[i], amp);
          tmp *= 2;
        }
        
        f *= pow(2, 1.0/n);
        print(hist[i]+", ");
      }
      println();
    }
  }
}