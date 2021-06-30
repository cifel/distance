import processing.pdf.*;

import processing.serial.*;  //import the serial library

Serial myPort;  //create object from Serial class

// use for saving GIF frames 
//int x = 0;
int intVal;

int close = 50; //distance data value via TFmini
int inbetween = 150; //distance data value via TFmini
int far = 250; //distance data value via TFmini

PVector loc; //current location
float orientation; //current orientation

void setup() {  
  size(1750, 800);
  loc = new PVector(0, height/2); //starting position: left side, centered in height
  orientation = radians(0); //starting orientation is at 0 degrees (left to right)
  stroke(0);
  frameRate(6); //speed of drawing

beginRecord(PDF, "virtual.pdf");


  // List all the available serial ports
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 9600); //change the 0 to a 1 or 2 etc. to match your port
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {

    // trim off any whitespace:
    inString = trim(inString);

    // convert to an int and map to the screen height:
    intVal = int(inString);

    println(intVal); //print the distance data out in the console
  }
}

void drawingOne() {  
  strokeWeight(7);  //the thickest one
  forward(5); //go forward 50 pixels
  left(radians(random(-90,90))); //
  forward(10); //go forward 100 pixels
  right(2);
  forward(25); //go forward 150 pixels
  left(1);
  forward(30); //go forward 200 pixels
  left(radians(random(-90,90))); //
  forward(15); //go forward 250 pixels
  right(2);
  forward(20); //go forward 300 pixels
  left(1);
  forward(5); //go forward 400 pixels
  left(radians(random(-90,90))); //
}

void drawingTwo() {
  strokeWeight(3);  //thicker
  forward(random(300)); //go forward y pixels
  forward(250); //go forward x pixels
  right(radians(random(-300))); //rotation of the lines
}

void drawingThree() {
  strokeWeight(0);  
  forward(50); //go forward 500 pixels
  right(1/4); //turn right 90º
}

// Below are utility functions to calculate new positions and orientations 
// when moving forward or turning. You don't need to change these.

void forward(float pixels)//calculate positions when moving forward
{
  PVector start = loc;
  PVector end = PVector.add(loc, polar(pixels, orientation));
  line(start, end);
  loc = end;
}

void left(float theta) //calculate new orientation
{
  orientation += theta;
}

void right(float theta)  //calculate new orientation
{
  orientation -= theta;
}

void jumpTo(int x, int y) //jump directly to a specific position
{
  loc = new PVector(x, y);
}

void line(PVector a, PVector b) //new line function with PVectors. used by forward function
{
  line(a.x, a.y, b.x, b.y);
}

PVector polar(float r, float theta) //converts an angle and radius into a vector
{
  return new PVector(r*cos(theta),r*sin(-theta)); // negate y for left handed coordinate system
}

void draw() { 
  if (intVal < close) {
  drawingOne();
  } 
  else if ((intVal >= close) && (intVal < inbetween)) {
    
  drawingTwo();
  } 
  else if ((intVal >= inbetween ) && (intVal < far)) {
  drawingThree();
  } 
  else {
  }

  
//the functions below keeps the drawing inside the active window area continuously
 
    if (loc.x > width) {
      loc.x = 0;
    } else if (loc.x < 0) {
      loc.x = width;
    }

    if (loc.y > height) {
      loc.y = 0;
    } else if (loc.y < 0) {
      loc.y = height;
    }


}

 void keyPressed() {
  if (key == 'n') {
    endRecord();
    exit();
  }
 }

 
