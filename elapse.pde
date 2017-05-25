import codeanticode.syphon.*;
import controlP5.*;
import themidibus.*;
import processing.serial.*;


// controlP5
ControlP5 cp5;
Accordion accordion;

// Syphon
SyphonServer server;
PGraphics canvas;

// MIDI
MidiBus midi;

// Arduino
Serial myPort;

System system;

color c = color(0, 160, 100);

void settings() {
  size(1400, 800, P3D);
  PJOGL.profile=1;
}

void setup() {
  background(0);
  canvas = createGraphics(width, height, P3D);
  system = new System();

  // controlP5
  gui();

  // Syphon
  server = new SyphonServer(this, "Processing Syphon");

  // midi
  midi = new MidiBus(this, "Akai APC20", -1);

  // Arduino
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 9600);
}

void draw() {
  background(0);
  system.render();
}

/*void keyPressed() {

  if (key == '1') {
    system.turnOn();
  }
  if (key == '2') {
    system.turnOff();
  }
  if (key == '3') {
    system.turnOn(300);
  }
  if (key == '4') {
    system.turnOff(300);
  }
  if (key == '5') {
    system.dimRepeat(1, 50);
  }
  if (key == '6') {
    system.dimRepeat(3, 30);
  }
  if (key == '7') {
    system.blink();
  }
  if (key == '8') {
    system.elapseTrigger();
  }
}
*/

void gui() {

  cp5 = new ControlP5(this);

  // group number 1, contains 2 bangs
  Group g1 = cp5.addGroup("myGroup1")
                .setBackgroundColor(color(0, 64))
                .setBackgroundHeight(200)
                ;

  cp5.addBang("dim_on")
     .setPosition(10,20)
     .setSize(30,30)
     .moveTo(g1)
     .setId(0)
     ;
  cp5.addBang("dim_off")
     .setPosition(10,70)
     .setSize(30,30)
     .moveTo(g1)
     .setId(1)
     ;
  cp5.addBang("Repeat3")
     .setPosition(10,120)
     .setSize(30,30)
     .moveTo(g1)
     .setId(2)
     ;
  cp5.addBang("blink")
     .setPosition(50,20)
     .setSize(30,30)
     .moveTo(g1)
     .setId(3)
     ;
  cp5.addBang("elapse")
     .setPosition(50,70)
     .setSize(30,30)
     .moveTo(g1)
     .setId(4)
     ;
  cp5.addBang("S1")
     .setPosition(50,120)
     .setSize(30,30)
     .moveTo(g1)
     .setId(5)
     ;
  cp5.addBang("S2")
     .setPosition(90,20)
     .setSize(30,30)
     .moveTo(g1)
     .setId(6)
     ;
  cp5.addBang("S3")
     .setPosition(90,70)
     .setSize(30,30)
     .moveTo(g1)
     .setId(7)
     ;
  cp5.addBang("S4")
     .setPosition(90,120)
     .setSize(30,30)
     .moveTo(g1)
     .setId(8)
     ;

  // group number 2, contains a radiobutton
  Group g2 = cp5.addGroup("myGroup2")
                .setBackgroundColor(color(0, 64))
                .setBackgroundHeight(150)
                ;

  cp5.addRadioButton("radio")
     .setPosition(10,20)
     .setItemWidth(20)
     .setItemHeight(20)
     .addItem("dim in", 0)
     .addItem("dim out", 1)
     .addItem("dim 1 repeat", 2)
     .addItem("dim 3 repeat", 3)
     .addItem("flowing", 4)
     .setColorLabel(color(255))
     .activate(2)
     .moveTo(g2)
     ;

  // group number 3, contains a bang and a slider
  Group g3 = cp5.addGroup("myGroup3")
                .setBackgroundColor(color(0, 64))
                .setBackgroundHeight(150)
                ;

  cp5.addBang("shuffle")
     .setPosition(10,20)
     .setSize(40,50)
     .moveTo(g3)
     ;

  cp5.addSlider("hello")
     .setPosition(60,20)
     .setSize(100,20)
     .setRange(100,500)
     .setValue(100)
     .moveTo(g3)
     ;

  cp5.addSlider("world")
     .setPosition(60,50)
     .setSize(100,20)
     .setRange(100,500)
     .setValue(200)
     .moveTo(g3)
     ;

  // create a new accordion
  // add g1, g2, and g3 to the accordion.
  accordion = cp5.addAccordion("acc")
                 .setPosition(40,40)
                 .setWidth(200)
                 .addItem(g1)
                 .addItem(g2)
                 .addItem(g3)
                 ;

  cp5.mapKeyFor(new ControlKey() {public void keyEvent() {accordion.open(0,1,2);}}, 'o');
  cp5.mapKeyFor(new ControlKey() {public void keyEvent() {accordion.close(0,1,2);}}, 'c');
  //  cp5.mapKeyFor(new ControlKey() {public void keyEvent() {accordion.setWidth(300);}}, '1');
  //  cp5.mapKeyFor(new ControlKey() {public void keyEvent() {accordion.setPosition(0,0);accordion.setItemHeight(190);}}, '2');
  cp5.mapKeyFor(new ControlKey() {public void keyEvent() {accordion.setCollapseMode(ControlP5.ALL);}}, '3');
  cp5.mapKeyFor(new ControlKey() {public void keyEvent() {accordion.setCollapseMode(ControlP5.SINGLE);}}, '4');
  cp5.mapKeyFor(new ControlKey() {public void keyEvent() {cp5.remove("myGroup1");}}, '0');

  accordion.open(0);

  // use Accordion.MULTI to allow multiple group
  // to be open at a time.
  accordion.setCollapseMode(Accordion.MULTI);

  // when in SINGLE mode, only 1 accordion
  // group can be open at a time.
  // accordion.setCollapseMode(Accordion.SINGLE);
}

public void controlEvent(ControlEvent theEvent) {
  // println(
  // "## controlEvent / id:"+theEvent.controller().getId()+
  //   " / name:"+theEvent.controller().getName()+
  //   " / value:"+theEvent.controller().getValue()
  //   );
  switch(theEvent.controller().getId()) {
    case(0):
      system.turnOn(300);
      break;
    case(1):
      system.turnOff(300);
      break;
    case(2):
      system.dimRepeat(3, 50);
      break;
    case(3):
      system.blink();
      break;
    case(4):
      system.elapseTrigger();
      break;
    case(5):
      system.triggerSequence(0, 100);
      break;
    case(6):
      system.triggerSequence(1, 100);
      break;
    case(7):
      system.triggerSequence(2, 100);
      break;
    case(8):
      system.triggerSequence(3, 100);
      break;
  }
}

// midi
void noteOn(int channel, int pitch, int velocity) { //piano //CC是有區間,連續變化的
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
  println("****************************");

//Bang effects
  if (pitch == 53) {
    if (channel == 0) {
      system.dimRepeat(1,80);
    } else if(channel == 2) {
      system.dimRepeat(3,50);
    } else if(channel == 6) {
      system.turnOn(300);
    } else if(channel == 7) {
      // system.turnOff(300);
      system.turnFourRandSequence(50);
    }
  }

  if (pitch == 52) {
    if (channel == 0) {
      system.elapseTrigger();
    }
  }
}
//Processing to Arduino (for tube control)
void keyPressed()
{
  if(key == 'q')
  {
    myPort.write(1);
  }
  if(key == 'w')
  {
    myPort.write(2);
  }
  if(key == 'e')
  {
    myPort.write(3);
  }
  if(key == 'r')
  {
    myPort.write(4);
  }
  if(key == 't')
  {
    myPort.write(5);
  }
  if(key == 'y')
  {
    myPort.write(6);
  }

  if(key == 'a')
  {
    myPort.write(7);
  }
  if(key == 's')
  {
    myPort.write(8);
  }

}

//Auto effects
  /*if (pitch == 50) {
    if (channel == 0){
      system.
    }
  */
