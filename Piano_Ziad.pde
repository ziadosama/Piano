import ddf.minim.*;
import ddf.minim.ugens.*;

//declarations:
//The array whiteKeys and blackKeys is the name of the notes piano white and black keys
String [] whiteKeys={"C3", "D3", "E3", "F3", "G3", "A3", "B3","C4"};
String [] blackKeys={" ","Db3", "Eb3", "", "Gb3", "Ab3", "Bb3"};
//The width and the height of the white and black piano key
float whiteWidth=80;
float whiteHeight=300;
float blackWidth=50;
float blackHeight=200;
//declaring the piano keys
rectangle [] whiter=new rectangle[8];
rectangle [] blackr=new rectangle[7];
//a boolean array to check if the black keys are hovered
boolean[] isHoverOnBlack = {false,false,false,false,false,false,false};

/*
  The rectangle class is used to add more functionalities to rect in processing
  and to gain control over each key after being drawn
*/
class rectangle {
  // The x, y are the position in the sketch
 //The sizeX and sizeY are the sizes of rectangle
  float x, y, sizeX, sizeY;
  //The note that the key is going to play
  String pitch;
  //Minim library
  Minim minim;
  AudioOutput out;
  boolean isBlack;
  
  //constructor
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

  //checking if white key or black key and filling the color+drawing
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
    //check if a key is hovered
    if(isBlack){
      if (mouseY>0&&mouseY<sizeY && mouseX>(x-sizeX/2)&&mouseX<(x+sizeX-sizeX/2))
        return true; 
    }else{
      if (mouseY>0&&mouseY<sizeY && mouseX>x&&mouseX<x+sizeX)
        return true; 
    }
     return false;
  }
  //play the note
  void play()
  {
      out.playNote(pitch);
  }
}


//initial begin
void setup() 
{
  size(800, 400);
  background(255);
  smooth();
  //declaring the white and black keys
  for (int i=0; i<whiter.length; i++)
    whiter[i]=new rectangle(whiteWidth*i,0,false,whiteKeys[i]);
  for (int i=0; i<blackr.length; i++)
    if(i != 0)
      blackr[i]=new rectangle(whiteWidth*i,blackHeight/2,true,blackKeys[i]);
}

//drawing the keys
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

//checking if black key is hovered
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

//on mouse press check hover and play
void mousePressed(){
   for(int i = 1; i<blackr.length; i++)
     if(i!=3)  
       if(blackr[i].hover())  blackr[i].play();
  for(int i = 0; i<whiter.length; i++)
    if(whiter[i].hover() && !hoverOnBlack())
      whiter[i].play();
}
