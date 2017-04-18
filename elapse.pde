// add
Strip strip;

void setup() {
  size(1000, 500);
  background(0);
  strip = new Strip(0, 20);
}

void draw() {
  background(0);

  strip.update();
  strip.render();
}

void keyPressed() {
  if (key == '1') {
    strip.turnOn();
  }
  if (key == '2') {
    strip.turnOff();
  }
  if (key == '3') {
    strip.turnOn(2000);
  }
  if (key == '4') {
    strip.turnOff(2000);
  }

  if (key == '5') {
    strip.setLimit(1000);
  }
}

void mousePressed() {

}
