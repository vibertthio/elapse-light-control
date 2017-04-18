final int nOfLED = 50;

class Strip {
  int id;
  float angle;
  float xpos;
  float ypos;
  float length = 300;

  TimeLine dimTimer;
  Light[] lights;

  // state
  boolean independentControl = false;
  boolean repeatBreathing = false;

  // temperary
  boolean dimming = false;
  float alpha = 255;
  float targetAlpha;
  float initialAlpha;

  // blink function
  boolean blink = false;
  TimeLine turnOnTimer;

  // elapse
  boolean elaspsing = true;
  int elapseIndex = 0;
  int elapseLength = 10;
  int elapseEdge = 500;

  Strip(int _id, float _a, float _x, float _y) {
    id = _id;
    angle = _a;
    // xpos = width / 2 - length / 2;
    // ypos = height / 2;
    xpos = _x;
    ypos = _y;
    initLights();

    // Timers
    dimTimer = new TimeLine(300);
    turnOnTimer = new TimeLine(50);
  }

  void initLights() {
    lights = new Light[nOfLED];
    for (int i = 0; i < nOfLED; i++) {
      lights[i] = new Light(xpos + length * i / nOfLED, ypos);
    }
  }

  void update() {
    if (independentControl) {
      if (elaspsing) {
        println("elapseIndex : " + elapseIndex);
        lights[elapseIndex].turnOn(elapseEdge);
        int last = ((elapseIndex - elapseLength) + nOfLED) % nOfLED;
        println("last : " + last);
        lights[last].turnOff(elapseEdge);
        elapseIndex = (elapseIndex + 1) % nOfLED;
      }
      for (int i = 0; i < nOfLED; i++) {
        lights[i].update();
      }
    } else {
      if (dimming) {
        float ratio = 0;
        if (repeatBreathing) {
          ratio = dimTimer.repeatBreathMovement();
        } else {
          ratio = dimTimer.liner();
        }

        alpha = initialAlpha +
          (targetAlpha - initialAlpha) * ratio;

        if (!dimTimer.state) {
          // alpha = targetAlpha;
          dimming = false;
          repeatBreathing = false;
        }
      } else if (blink) {
        println("blink check!!");
        if (turnOnTimer.liner() == 1) {
          turnOff();
          blink = false;
        }
      }
    }
  }

  void render() {
    if (independentControl) {
      for (int i = 0; i < nOfLED; i++) {
        lights[i].render();
      }
    } else {
      pushMatrix();

      translate(xpos, ypos);

      for (int i = 0; i < nOfLED; i++) {
        float x = length * i / nOfLED;
        noStroke();
        fill(255, alpha);
        ellipse(x, 0, 5, 5);
      }

      popMatrix();
    }

  }

  void turnOn() {
    repeatBreathing = false;
    independentControl = false;
    dimming = false;
    alpha = 255;
    initialAlpha = 255;
    targetAlpha = 255;
  }

  void turnOn(int time) {
    repeatBreathing = false;
    independentControl = false;
    dimming = true;
    dimTimer.limit = time;
    dimTimer.startTimer();
    initialAlpha = alpha;
    targetAlpha = 255;
  }

  void turnOff() {
    repeatBreathing = false;
    independentControl = false;
    dimming = false;
    alpha = 0;
    initialAlpha = 0;
    targetAlpha = 0;
  }

  void turnOff(int time) {
    repeatBreathing = false;
    independentControl = false;
    dimming = true;
    dimTimer.limit = time;
    dimTimer.startTimer();
    initialAlpha = alpha;
    targetAlpha = 0;
  }

  void turnOnFor(int time) {
    repeatBreathing = false;
    blink = true;
    turnOn();
    turnOnTimer.limit = time;
    turnOnTimer.startTimer();
  }

  void blink() {
    turnOnFor(20);
  }

  void setLimit(int ll) {
    dimTimer.limit = ll;
  }

  void switchIndeMode() {
    independentControl = !independentControl;
  }

  void elapseTrigger() {
    independentControl = !independentControl;
    for (int i = 0; i < nOfLED; i++) {
      lights[i].turnOff();
    }
  }

  // dim 3 times
  void dimRepeat(int time, int ll) {
    alpha = 0;
    independentControl = false;
    repeatBreathing = true;
    dimming = true;
    initialAlpha = 0;
    targetAlpha = 255;
    dimTimer.limit = ll;
    dimTimer.repeatTime = time;
    dimTimer.breathState = false;
    dimTimer.startTimer();
  }
  void dimRepeatInverse(int time, int ll) {
    alpha = 255;
    independentControl = false;
    repeatBreathing = true;
    dimming = true;
    initialAlpha = 255;
    targetAlpha = 0;
    dimTimer.limit = ll;
    dimTimer.repeatTime = time;
    dimTimer.breathState = false;
    dimTimer.startTimer();
  }

}

class Light {
  // temperary
  float xpos;
  float ypos;

  float alpha = 255;
  float targetAlpha = 255;
  float initialAlpha = 255;
  boolean dimming = false;

  TimeLine dimTimer;


  Light(float _x, float _y) {
    xpos = _x;
    ypos = _y;
    dimTimer = new TimeLine(300);
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
    noStroke();
    fill(255, alpha);
    ellipse(0, 0, 5, 5);

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

  void setLimit(int ll) {
    dimTimer.limit = ll;
  }
}
