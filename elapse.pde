import codeanticode.syphon.*;
import controlP5.*;

// controlP5
ControlP5 cp5;
Accordion accordion;

// Syphon
SyphonServer server;
PGraphics canvas;

color c = color(0, 160, 100);
Strip[] strips1;
Strip[] strips2;
Strip[] strips3;
int nOfStrips_1= 4;
int nOfStrips_2 = 4;
int nOfStrips_3 = 4;

void settings() {
  size(1400, 800, P3D);
  PJOGL.profile=1;
}

void setup() {
  background(0);

  strips1 = new Strip[nOfStrips_1];
  for (int i = 0; i < nOfStrips_1; i++) {
    strips1[i] = new Strip(i, 0, width / 2, 100 + 50 * i);
  }

  strips2 = new Strip[nOfStrips_2];
  for (int j = 0; j < nOfStrips_2; j++) {
    strips2[j] = new Strip(j, 0, 400, 300 + 50 * j);
  }

  strips3 = new Strip[nOfStrips_2];
  for (int k = 0; k < nOfStrips_2; k++) {
    strips3[k] = new Strip(k, 0, 1000, 300 + 50 * k);
  }

  gui();
  canvas = createGraphics(width, height, P3D);
  server = new SyphonServer(this, "Processing Syphon");

}

void draw() {
  background(0);

  canvas.beginDraw();
  canvas.background(0);


  for (int i = 0; i < nOfStrips_1; i++) {
    strips1[i].update();
    strips1[i].render();
  }

  for (int j = 0; j < nOfStrips_2; j++) {
    strips2[j].update();
    strips2[j].render();
  }

  for (int k = 0; k < nOfStrips_3; k++) {
    strips3[k].update();
    strips3[k].render();
  }

  image(canvas, 0, 0);
  canvas.endDraw();
  server.sendImage(canvas);
}

void keyPressed() {

  if (key == '1') {
    for (int i = 0; i < nOfStrips_1; i++) {
      strips1[i].turnOn();
    }
    for (int j = 0; j < nOfStrips_2; j++) {
      strips2[j].turnOn();
    }
    for (int k = 0; k < nOfStrips_3; k++) {
      strips3[k].turnOn();
    }
    //myPort.write(0);
  }
  if (key == '2') {
    for (int i = 0; i < nOfStrips_1; i++) {
      strips1[i].turnOff();
    }
    for (int j = 0; j < nOfStrips_2; j++) {
      strips2[j].turnOff();
    }
    for (int k = 0; k < nOfStrips_3; k++) {
      strips3[k].turnOff();
    }
    //myPort.write(1);
  }
  if (key == '3') {
    for (int i = 0; i < nOfStrips_1; i++) {
      strips1[i].turnOn(300);
    }
    for (int j = 0; j < nOfStrips_2; j++) {
      strips2[j].turnOn(300);
    }
    for (int k = 0; k < nOfStrips_3; k++) {
      strips3[k].turnOn(300);
    }
    //myPort.write(2);
  }
  if (key == '4') {
    for (int i = 0; i < nOfStrips_1; i++) {
      strips1[i].turnOff(300);
    }
    for (int j = 0; j < nOfStrips_2; j++) {
      strips2[j].turnOff(300);
    }
    for (int k = 0; k < nOfStrips_3; k++) {
      strips3[k].turnOff(300);
    }
    //myPort.write(3);
  }
  if (key == '5') {
    for (int i = 0; i < nOfStrips_1; i++) {
      strips1[i].dimRepeat(1,50);
    }
    for (int j = 0; j < nOfStrips_2; j++) {
      strips2[j].dimRepeat(1,50);
    }
    for (int k = 0; k < nOfStrips_3; k++) {
      strips3[k].dimRepeat(1,50);
    }
    //myPort.write(4);
  }
  if (key == '6') {
    for (int i = 0; i < nOfStrips_1; i++) {
      strips1[i].dimRepeat(3, 30);
    }
    for (int j = 0; j < nOfStrips_2; j++) {
      strips2[j].dimRepeat(3, 30);
    }
    for (int k = 0; k < nOfStrips_3; k++) {
      strips3[k].dimRepeat(3, 30);
    }
    //myPort.write(5);
  }
  if (key == '7') {
    for (int i = 0; i < nOfStrips_1; i++) {
      strips1[i].blink();
    }
    for (int j = 0; j < nOfStrips_2; j++) {
      strips2[j].blink();
    }
    for (int k = 0; k < nOfStrips_3; k++) {
      strips3[k].blink();
    }
    //myPort.write(6);
  }
  if (key == '8') {
    for (int i = 0; i < nOfStrips_1; i++) {
      strips1[i].elapseTrigger();
    }
    for (int j = 0; j < nOfStrips_2; j++) {
      strips2[j].elapseTrigger();
    }
    for (int k = 0; k < nOfStrips_3; k++) {
      strips3[k].elapseTrigger();
    }
    //myPort.write(7);
  }
}

void mousePressed() {

}


void gui() {

  cp5 = new ControlP5(this);

  // group number 1, contains 2 bangs
  Group g1 = cp5.addGroup("myGroup1")
                .setBackgroundColor(color(0, 64))
                .setBackgroundHeight(150)
                ;

  cp5.addBang("bang")
     .setPosition(10,20)
     .setSize(30,30)
     .moveTo(g1)
     .plugTo(this,"shuffle");
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

  accordion.open(0,1,2);

  // use Accordion.MULTI to allow multiple group
  // to be open at a time.
  accordion.setCollapseMode(Accordion.MULTI);

  // when in SINGLE mode, only 1 accordion
  // group can be open at a time.
  // accordion.setCollapseMode(Accordion.SINGLE);
}

void radio(int theC) {
  switch(theC) {
    case(0):
      for (int i = 0; i < nOfStrips_1; i++) {
        strips1[i].turnOn(300);
      }
      for (int j = 0; j < nOfStrips_2; j++) {
        strips2[j].turnOn(300);
      }
      for (int k = 0; k < nOfStrips_3; k++) {
        strips3[k].turnOn(300);
      }
      break;
    case(1):
      for (int i = 0; i < nOfStrips_1; i++) {
        strips1[i].turnOff(300);
      }
      for (int j = 0; j < nOfStrips_2; j++) {
        strips2[j].turnOff(300);
      }
      for (int k = 0; k < nOfStrips_3; k++) {
        strips3[k].turnOff(300);
      }
      break;
    case(2):
      for (int i = 0; i < nOfStrips_1; i++) {
        strips1[i].dimRepeat(1, 30);
      }
      for (int j = 0; j < nOfStrips_2; j++) {
        strips2[j].dimRepeat(1, 30);
      }
      for (int k = 0; k < nOfStrips_3; k++) {
        strips3[k].dimRepeat(1, 30);
      }
      break;
    case(3):
      for (int i = 0; i < nOfStrips_1; i++) {
        strips1[i].dimRepeat(3, 30);
      }
      for (int j = 0; j < nOfStrips_2; j++) {
        strips2[j].dimRepeat(3, 30);
      }
      for (int k = 0; k < nOfStrips_3; k++) {
        strips3[k].dimRepeat(3, 30);
      }
      break;
    case(4):
      for (int i = 0; i < nOfStrips_1; i++) {
        strips1[i].elapseTrigger();
      }
      for (int j = 0; j < nOfStrips_2; j++) {
        strips2[j].elapseTrigger();
      }
      for (int k = 0; k < nOfStrips_3; k++) {
        strips3[k].elapseTrigger();
      }
      break;
  }
}
