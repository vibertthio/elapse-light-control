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
    strip.dimRepeat(1, 1000);
  }
  if (key == '6') {
    strip.dimRepeat(3, 1000);
  }
  if (key == '7') {
    strip.blink();
  }
  if (key == '8') {
    strip.elapseTrigger();
  }
}

void mousePressed() {

}
