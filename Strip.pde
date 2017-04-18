final int nOfLED = 50;

class Strip {
  int id;
  float angle;
  float xpos;
  float ypos;
  float length = 300;

  TimeLine dimTimer;


  // temperary
  float alpha = 255;
  float targetAlpha;
  float initialAlpha;
  boolean dimming = false;

  Strip(int _id, float _a) {
    id = _id;
    angle = _a;
    dimTimer = new TimeLine(300);
    xpos = width / 2 - length / 2;
    ypos = height / 2;
  }

  void update() {
    if (dimming) {
      alpha = initialAlpha +
        (targetAlpha - initialAlpha) * dimTimer.liner();
      if (abs(alpha - targetAlpha) < 1) {
        alpha = targetAlpha;
        dimming = false;
      }
    }
  }

  void render() {
    pushMatrix();
    translate(xpos, ypos);

    for (int i = 0; i < nOfLED; i++) {
      float x = length * i / nOfLED;
      println(x);
      noStroke();
      fill(255, alpha);
      ellipse(x, 0, 5, 5);
    }

    popMatrix();
  }

  void turnOn() {
    dimming = false;
    alpha = 255;
    initialAlpha = 255;
    targetAlpha = 255;
  }

  void turnOn(int time) {
    dimming = true;
    dimTimer.limit = time;
    dimTimer.startTimer();
    initialAlpha = alpha;
    targetAlpha = 255;
  }

  void turnOff() {
    dimming = false;
    alpha = 0;
    initialAlpha = 0;
    targetAlpha = 0;
  }

  void turnOff(int time) {
    dimming = true;
    dimTimer.limit = time;
    dimTimer.startTimer();
    initialAlpha = alpha;
    targetAlpha = 0;
  }

  void turnOnFor(int time) {

  }

  void setLimit(int ll) {
    dimTimer.limit = ll;
  }

}

class Light {
  int alpha;

  Light() {
    alpha = 0;
  }

  void update() {

  }

  void render() {

  }

}
