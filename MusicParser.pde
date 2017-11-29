import ddf.minim.analysis.*;
import ddf.minim.*;

class MusicParser {
  AudioPlayer music;
  FFT fft;
  int frame = 0;

  int n = 0;
  // value of each histogram
  float[] hist = new float[1];
  float[][] colors = new float[1][3];
  //boolean isPlaying = false;
  float rate;
  
  String FilePath = FolderName + FileName;
  
  int interval = 12;
  
  MusicParser() {
    music = minim.loadFile(FilePath);
    rate = music.sampleRate();
    fft = new FFT(music.bufferSize(), music.sampleRate());
    fft.window(FFT.GAUSS);
    setN(1);
    n = 0;
  }
  
  void setN(int newN) {
    //println(newN);
    n = newN;
    hist = new float[n];
    colors = new float[n][3];
    for (int i = 0; i < n; ++i) {
      hist[i] = 0;
      for (int j = 0; j < 3; j++) {
        colors[i][j] = 0;
      }
      colors[i][0] = 255;
    }
  }
  
  void play() {
    music.play();
    animating = true;
    frame = 0;
  }
  
  void stopPlaying() {
    animating = false;
    music.pause();
  }
  
  // update every "interval" frame
  void update() {
    if (!animating) return;
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
          colors[i][j%3] += amp;
          tmp *= 2;
        }
        
        f *= pow(2, 1.0/n);
        hist[i] *= 0.1f;
        hist[i] = min(hist[i], 5.0f);
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
  
  void draw() {
    if (!animating) return;
    float boxW = 150;
    float w = boxW / n;
    for (int i = 0; i < n; ++i) {
    noStroke();
    fill(colors[i][0], colors[i][1], colors[i][2]);
    rect(width-boxW+i*w, height, w, -parser.hist[i]*20);
    noFill();
  }
  }
}