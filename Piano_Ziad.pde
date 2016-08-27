import ddf.minim.*;
import ddf.minim.ugens.*;

//declarations
String [] whiteKeys={"C3", "D3", "E3", "F3", "G3", "A3", "B3","C4"};
String [] blackKeys={" ","Db3", "Eb3", "", "Gb3", "Ab3", "Bb3"};
float whiteWidth=80;
float whiteHeight=300;
float blackWidth=50;
float blackHeight=200;
rectangle [] whiter=new rectangle[8];
rectangle [] blackr=new rectangle[7];
boolean[] isHoverOnBlack = {false,false,false,false,false,false,false};


class rectangle {
  float x, y, sizeX, sizeY;
  String pitch;
  Minim minim;
  AudioOutput out;
  boolean isBlack;
  
  rectangle(float _x, float _y, boolean _black, String _pitch)
  {
    x=_x;
    y=_y;
    isBlack = _black;
    sizeX= isBlack ? blackWidth:whiteWidth;
    sizeY= isBlack ? blackHeight:whiteHeight;
    pitch=_pitch;
    minim=new Minim(this);
    out= minim.getLineOut();
    out.setTempo(100);
  }
  
  void stopa()
  {
    out.close();
    minim.stop();
  }

  void display()
  {
    if(!isBlack){ fill(255, 255, 255, 20); rectMode(CORNER);}
    else{ rectMode(CENTER); fill(0);};
    if(hover()) {
      if(!isBlack && !hoverOnBlack()) fill(200,50,100);
      else if(isBlack) fill(150,50,200);
    }
    rect(x, y, sizeX, sizeY);
  }
  
  boolean hover()
  {
    //check if key is hovered
    if(isBlack){
      if (mouseY>0&&mouseY<sizeY && mouseX>(x-sizeX/2)&&mouseX<(x+sizeX-sizeX/2))
        return true; 
    }else{
      if (mouseY>0&&mouseY<sizeY && mouseX>x&&mouseX<x+sizeX)
        return true; 
    }
     return false;
  }
  
  void play()
  {
    //check if key is played
      out.playNote(pitch);
  }
}


//initial begin
void setup() 
{
  size(800, 400);
  background(255);
  smooth();
  for (int i=0; i<whiter.length; i++)
    whiter[i]=new rectangle(whiteWidth*i,0,false,whiteKeys[i]);
  for (int i=0; i<blackr.length; i++)
    if(i != 0)
      blackr[i]=new rectangle(whiteWidth*i,blackHeight/2,true,blackKeys[i]);
}


//checking hovers and playing
void draw(){
  background(255);
  strokeWeight(5);
  stroke(0);
  
  for(int i = 0; i<whiter.length; i++)
    whiter[i].display();
    
 for(int i = 1; i<blackr.length; i++){
     if(i!=3) blackr[i].display();
     if(blackr[i].hover()) isHoverOnBlack[i] = true;
     else isHoverOnBlack[i] = false;
 }
}

boolean hoverOnBlack(){
   for(int i = 0; i<isHoverOnBlack.length; i++)
     if(isHoverOnBlack[i]) return true;
   return false;
}

void stop()
{
  for (int i=0; i<whiter.length; i++)
  {
    whiter[i].stopa();
    blackr[i].stopa();
  }
}

void mousePressed(){
   for(int i = 1; i<blackr.length; i++)
     if(i!=3)  
       if(blackr[i].hover())  blackr[i].play();
  for(int i = 0; i<whiter.length; i++)
    if(whiter[i].hover() && !hoverOnBlack())
      whiter[i].play();
}