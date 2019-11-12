import neurosky.*;
import java.net.*;
import org.json.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;    

ThinkGearSocket neuroSocket;

int attention = 0;
int meditation = 0;
int state = 0;

void setup() 
{
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  println(Serial.list());
  
  // fullscreen
  size(displayWidth, displayHeight);
  
  ThinkGearSocket neuroSocket = new ThinkGearSocket(this);
  try 
  {
    neuroSocket.start();
  } 
  catch (ConnectException e) {
    e.printStackTrace();
  }
}

void draw() 
{
    if (state == 0) {
    // initialisation screen - game will start when connection signal < 50
    fill(255);
    noStroke();
    rect(displayWidth/2-400, displayHeight/2-100, 800, 160);
    fill(0);
    textAlign(CENTER);
    text("Initialising your brain...", displayWidth/2, displayHeight/2);
  }
 
  else if (state == 1) {
  background(0);
  
  fill(255, 255, 0);
  text("Attention: "+attention, 100, 150);
  fill(255, 255, 0, 160);
  rect(200, 130, attention*3, 40);
  fill(255, 255, 0);
  text("Meditation: "+meditation, 100, 250);
  fill(255, 255, 0, 160);
  rect(200, 230, meditation*3, 40);
  
  if (attention > 70) {
    myPort.write('H');
  }
  else {
    myPort.write('L');
  }
}
}

void poorSignalEvent(int sig) {  
  // waits for when connection signal to the headset is good
  if (sig < 50 && state == 0) {
    state = 1;
  }
  
  else if (sig > 50 && state == 1) {
    state = 0;
  }
    println("SignalEvent "+sig);
}
 
void attentionEvent(int attentionLevel) 
{
  attention = attentionLevel;
}
 
void meditationEvent(int meditationLevel) 
{
  meditation = meditationLevel;
}
 
void stop() {
  neuroSocket.stop();
  super.stop();
}
