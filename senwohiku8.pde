import processing.video.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

ten[] others;
ten center = new ten(0, 0);
sen[] waku;
ten[] spot;

Minim minim;
AudioPlayer player;
FFT fft;

Movie myMovie;

int yoko = 16;
int tate = 9;

void setup() {
  
  noSmooth();

  size(1280, 720);

  minim = new Minim(this);
  player = minim.loadFile("hisui.mp3"); 

  fft = new FFT(player.bufferSize(), player.sampleRate());

  myMovie = new Movie(this, "hisui.flv");

  others = new ten[tate*yoko];
  {
    float f = 15;
    for (int i = 0; i < others.length; i++) {
      others[i] = new ten(
        (0.5+i/tate)*(width /yoko)+random(-f, f), 
        (0.5+i%tate)*(height/tate)+random(-f, f));
    }
  }

  sen[] _waku = {
    new sen(1, 0, 0), 
    new sen(0, 1, 0), 
    new sen(1, 0, width-1), 
    new sen(0, 1, height-1)
  };
  waku = _waku;

  ten[] hoge = new ten[others.length-1];

  for (int j = 0; j<others.length; j++) {
    int counter = 0;
    for (int i = 0; i < others.length; i++) {
      if (i == j) {
        center = others[i];
      } else {
        hoge[counter] = others[i];
        counter++;
      }
    }

    center.bnkt = bunkatsu(center, hoge);
  }

  int _tate = height/10;
  int _yoko = width/10;

  spot = new ten[_yoko*_tate];

  for (int i = 0; i < spot.length; i++) {
    spot[i] = new ten(
      (i/_tate)*(width /_yoko), 
      (i%_tate)*(height/_tate)
      );
    float nearestdist = 1145141919;
    ten nearpoint = new ten(0, 0);
    for (ten taisho : others) {

      float sans = distsq(spot[i], taisho);

      if (sans < nearestdist) {
        nearestdist = sans;
        nearpoint = taisho;
      }
    }
    int ichigo = nearpoint.spot.length;
    ten[] hisui = new ten[ichigo+1];
    for (int j=0; j<ichigo; j++) {
      hisui[j] = nearpoint.spot[j];
    }
    hisui[ichigo] = spot[i];
    nearpoint.spot = hisui;
  }
  
  int gosa = 703;

  player.play();
  int time = millis();

  myMovie.play();
  myMovie.volume(0);
  while (millis() - time < gosa);
  myMovie.jump(float(player.position()-gosa)/1000);
}

void draw() {

  fft.forward(player.mix);

  int specSize = fft.specSize();
  int[] oozappa = new int[yoko];

  {
    int hoge = specSize/4;
    for (int j = 0; j <yoko; j++) {
      for (int i = 0; i < hoge/yoko; i++)
      {
        oozappa[j] += fft.getBand(j*hoge/yoko+i) * 3;
      }
      oozappa[j] = constrain(oozappa[j], 0, height)/(height/tate);
    }
  }

  if (myMovie.available()) {
    myMovie.read();
  }
  
  image(myMovie, 0, 0, width, height);

  loadPixels();

  for (int j = 0; j < others.length; j++) if (tate-oozappa[j/tate] <= j%tate) {
    ten lion = others[j];
    float[] avrcol={0, 0, 0};
    for (ten rabbit : lion.spot) {
      color hoge = pixels[int(width*rabbit.y+rabbit.x)];
      for (int i=0; i<3; i++)
        avrcol[i]+=float(hoge>>(i*8)&0xFF)/lion.spot.length;
    }

    color nyon = color(avrcol[2], avrcol[1], avrcol[0]);
    fill(nyon);
    stroke(255-brightness(nyon));

    beginShape();
    for (ten rabbit : lion.bnkt) {
      vertex(rabbit.x, rabbit.y);
    }
    endShape(CLOSE);
  }

  println(frameRate);
}