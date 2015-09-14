//////////////////////////////////////////////////////////////////////////////
// Think happy thoughts - Show
// 2013, Accademia di belle Arti di Urbino - Campivisivi
// pietrospagnolo.it
// ---------------------------------------------------------------------------
// with the invaluable assistance of Giovanni Bedetti - giovannibedetti.com
//////////////////////////////////////////////////////////////////////////////

import oscP5.*;
// num faces found
int found;
PFont font;
import processing.opengl.*;

OscP5 oscP5;

// pose
float poseScale;
PVector posePosition = new PVector();
PVector poseOrientation = new PVector();

// gesture
float mouthHeight;
float mouthWidth;
float eyeLeft;
float eyeRight;
float eyebrowLeft;
float eyebrowRight;
float jaw;
float nostrils;

// image
PImage img, img0, img1, img2;

void setup(){
  size(displayWidth, displayHeight, OPENGL);
  font = loadFont("Novecentowide.vlw");
  imageMode(CENTER);
  smooth(); 
  
  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "poseScale", "/pose/scale");
  oscP5.plug(this, "posePosition", "/pose/position");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");
  oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
  oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
  oscP5.plug(this, "eyeLeftReceived", "/gesture/eye/left");
  oscP5.plug(this, "eyeRightReceived", "/gesture/eye/right");
  oscP5.plug(this, "eyebrowLeftReceived", "/gesture/eyebrow/left");
  oscP5.plug(this, "eyebrowRightReceived", "/gesture/eyebrow/right");
  oscP5.plug(this, "jawReceived", "/gesture/jaw");
  oscP5.plug(this, "nostrilsReceived", "/gesture/nostrils");
  loadPixels();

// load image 
  img0 = loadImage("0.png");
  img1 = loadImage("1.png");
  img2 = loadImage("2.png");
}


void draw(){
  background(241, 178, 54);
  text("*Potrei avere dei problemi nel riconoscerti se porti la barba, un folto ciuffo sul viso o degli occhiali", width/2, 1000, 0);
  textFont(font, 12);
  textAlign(CENTER, CENTER);
  fill(74, 79, 79);

// given the faceosc parameters
  if(found > 0){
     float scaleDim = map(poseScale, 0.0, 3.0, width/10, height/5*3);
     float p5x = map(posePosition.x, 0, 160, width, 0);
     float p5y =  map(posePosition.y, 0, 120, 0, height);
     translate(p5x, p5y);

    if(is0())
      img = img0;
    else if(is1())
      img = img1;
    else
      img = img2;
      
    scale(poseScale);
    image(img, 0, 0);
  }
  
}

boolean isGrinning(){
  if(mouthWidth > 15)
    return true;
    return false;
}

boolean areEyebrowsRaised(){
  if(eyebrowLeft > 7.5 && eyebrowRight > 7.5)
    return true;
    return false;
}

boolean isSmiling(){
  if(mouthWidth > 13.5)
    return true;
    return false;
}

// face profiles
boolean is0(){
  if(isGrinning())
    return true;
    return false;
}

boolean is1(){
  if(areEyebrowsRaised() && isSmiling())
   return true; 
    return false;
}


// osc callback functions
public void found(int i) {
  println("found: " + i);
  found = i;
}

public void poseScale(float s) {
  println("scale: " + s);
  poseScale = s;
}

public void posePosition(float x, float y) {
  println("pose position\tX: " + x + " Y: " + y );
  posePosition.set(x, y, 0);
}

public void poseOrientation(float x, float y, float z) {
  println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
  poseOrientation.set(x, y, z);
}

public void mouthWidthReceived(float w) {
  println("mouth Width: " + w);
  mouthWidth = w;
}

public void mouthHeightReceived(float h) {
  println("mouth height: " + h);
  mouthHeight = h;
}

public void eyeLeftReceived(float f) {
  println("eye left: " + f);
  eyeLeft = f;
}

public void eyeRightReceived(float f) {
  println("eye right: " + f);
  eyeRight = f;
}

public void eyebrowLeftReceived(float f) {
  println("eyebrow left: " + f);
  eyebrowLeft = f;
}

public void eyebrowRightReceived(float f) {
  println("eyebrow right: " + f);
  eyebrowRight = f;
}

public void jawReceived(float f) {
  println("jaw: " + f);
  jaw = f;
}

public void nostrilsReceived(float f) {
  println("nostrils: " + f);
  nostrils = f;
}

// all other osc messages end up here
void oscEvent(OscMessage m) {
  if(m.isPlugged() == false) {
    println("UNPLUGGED: " + m);
  }
}
