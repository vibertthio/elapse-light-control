final int nOfLED = 40;

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
  int dimTime = 0;

  // blink function
  boolean blink = false;
  TimeLine turnOnTimer;



  // easing
  boolean easing = false;
  boolean easingBlink = false;
  float easeRatio;
  float dimOnEaseRatio = 8;
  float dimOffEaseRatio = 0.2;


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
    elapses = new ArrayList<Elapse>();
    lights = new Light[nOfLED];
    for (int i = 0; i < nOfLED; i++) {
      lights[i] = new Light(xpos + length * i / nOfLED, ypos);
    }
  }

  void update() {
    if (independentControl) {
      lightsUpdate();
    } else {
      if (dimming) {
        float ratio = 0;
        if (repeatBreathing) {
          ratio = dimTimer.repeatBreathMovement();
        } else if (easing) {
          ratio = dimTimer.getPowIn(easeRatio);
        } else {
          ratio = dimTimer.liner();
        }

        alpha = initialAlpha +
          (targetAlpha - initialAlpha) * ratio;

        if (!dimTimer.state) {
          // alpha = targetAlpha;
          easing = false;
          dimming = false;
          repeatBreathing = false;
        }
      // } else if (blink) {
      }
      if (blink) {
        // println("blink check!!");
        if (turnOnTimer.liner() == 1) {
          if (easingBlink) {
            turnOffEasing(dimTime / 2);
            easingBlink = false;
          } else {
            turnOff(dimTime);
          }
          blink = false;
        }
      }
    }
  }

  void lightsUpdate() {
    // if (elapsing) {
    //   elapseCount++;
    //   if (elapseCount > elapseCountLimit) {
    //     elapseCount = 0;
    //     lights[elapseIndex].turnOnFor(5, elapseEdge);
    //     int dif = (elapseDirection) ? 1 : (-1);
    //     elapseIndex = (elapseIndex + dif) % nOfLED;
    //     if (elapseIndex == elapseEndIndex) {
    //       elapsing = false;
    //     }
    //   }
    // }
    // elapse.update();

    for (int i = 0, n = elapses.size(); i < n; i++) {
      elapses.get(i).update();
    }

    for (int i = 0; i < nOfLED; i++) {
      lights[i].update();
    }
  }

  void render() {
    if (independentControl) {
      for (int i = 0; i < nOfLED; i++) {
        lights[i].render();
      }
    } else {
      canvas.pushMatrix();

      canvas.translate(xpos, ypos);

      for (int i = 0; i < nOfLED; i++) {
        float x = length * i / nOfLED;
        canvas.noStroke();
        canvas.fill(255, alpha);
        canvas.ellipse(x, 0, 5, 5);
      }

      canvas.popMatrix();
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

  void turnOnEasing(int time) {
    turnOn(time);
    easeRatio = dimOnEaseRatio;
    easing = true;
  }

  void turnOnEasing(int time, int ratio) {
    dimOnEaseRatio = ratio;
    turnOnEasing(time);
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

  void turnOffEasing(int time) {
    turnOff(time);
    easeRatio = dimOffEaseRatio;
    easing = true;
  }

  void turnOffEasing(int time, int ratio) {
    dimOffEaseRatio = ratio;
    turnOffEasing(time);
  }

  void turnOnFor(int time) {
    repeatBreathing = false;
    blink = true;
    dimTime = 0;
    turnOn();
    turnOnTimer.limit = time;
    turnOnTimer.startTimer();
  }

  void turnOnFor(int time, int ll) {
    repeatBreathing = false;
    blink = true;
    dimTime = ll;
    turnOn(dimTime);
    turnOnTimer.limit = time;
    turnOnTimer.startTimer();
  }

  // only one param here,
  // because the length of dimming and opening
  // must match at usual cases
  void turnOnEasingFor(int time) {
    repeatBreathing = false;
    blink = true;
    easingBlink = true;
    dimTime = time;
    turnOnEasing(time);
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


  void triggerIndependentControl() {
    independentControl = !independentControl;
  }
  void setIndependentControl(boolean s) {
    independentControl = s;
  }

  // elapse
  ArrayList<Elapse> elapses;
  // boolean elapsing = false;
  // int elapseStartIndex;
  // int elapseEndIndex;
  // boolean elapseDirection = true; // true for right, false for left
  // int elapseIndex = 0;
  // int elapseEdge = 500;
  // int elapseCount = 0;
  // int elapseCountLimit = 0;
  //
  // void bangElapse(int st, int en, boolean dir) {
  //   elapsing = true;
  //   elapseStartIndex = constrain(st, 0, nOfLED - 1);
  //   elapseEndIndex = constrain(en, 0, nOfLED - 1);
  //   elapseDirection = dir;
  //   elapseIndex = constrain(st, 0, nOfLED - 1);
  //   elapseCount = 0;
  // }
  void bangElapse(int st, int en, boolean dir) {
    for (int i = 0, n = elapses.size(); i < n; i++) {
      Elapse e = elapses.get(i);
      if (!e.elapsing) {
        e.bang(st, en, dir);
        return;
      }
    }
    Elapse e = new Elapse(this);
    elapses.add(e);
    e.bang(st, en, dir);
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

class Elapse {
  Strip strip;

  boolean elapsing = false;
  int elapseStartIndex;
  int elapseEndIndex;
  boolean elapseDirection = true; // true for right, false for left
  int elapseIndex = 0;
  int elapseEdge = 500;
  int elapseCount = 0;
  int elapseCountLimit = 0;

  Elapse(Strip _s) { strip = _s; }

  void bang(int st, int en, boolean dir) {
    elapsing = true;
    elapseStartIndex = constrain(st, 0, nOfLED - 1);
    elapseEndIndex = constrain(en, 0, nOfLED - 1);
    elapseDirection = dir;
    elapseIndex = constrain(st, 0, nOfLED - 1);
    elapseCount = 0;
  }

  void update() {
    if (elapsing) {
      elapseCount++;
      if (elapseCount > elapseCountLimit) {
        elapseCount = 0;
        strip.lights[elapseIndex].turnOnFor(5, elapseEdge);
        int dif = (elapseDirection) ? 1 : (-1);
        elapseIndex = (elapseIndex + dif) % nOfLED;
        if (elapseIndex == elapseEndIndex) {
          elapsing = false;
        }
      }
    }
  }
}

class Light {
  // temperary
  float xpos;
  float ypos;

  float alpha = 0;
  float targetAlpha = 0;
  float initialAlpha = 0;
  boolean dimming = false;

  int dimTime;
  TimeLine dimTimer;

  boolean autoOff = false;
  TimeLine turnOnTimer;

  Light(float _x, float _y) {
    xpos = _x;
    ypos = _y;
    dimTimer = new TimeLine(300);
    turnOnTimer = new TimeLine(50);
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
    if (autoOff) {
      if (!turnOnTimer.state) {
        if (dimTimer.liner() == 1) {
          turnOnTimer.startTimer();
        }
      } else if (turnOnTimer.liner() == 1) {
        autoOff = false;
        turnOff(dimTime);
        autoOff = false;
      }
    }
  }

  void render() {
    canvas.pushMatrix();

    canvas.translate(xpos, ypos);
    canvas.noStroke();
    canvas.fill(255, alpha);
    canvas.ellipse(0, 0, 5, 5);

    canvas.popMatrix();
  }

  void turnOn() {
    dimming = false;
    alpha = 255;
    initialAlpha = 255;
    targetAlpha = 255;
  }

  void turnOn(int time) {
    dimming = true;
    dimTime = time;
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
    dimTime = time;
    dimTimer.limit = time;
    dimTimer.startTimer();
    initialAlpha = alpha;
    targetAlpha = 0;
  }

  void turnOnFor(int time, int ll) {
    autoOff = true;
    turnOnTimer.limit = time;
    dimTime = ll;
    turnOn(ll);
  }

  void setLimit(int ll) {
    dimTime = ll;
    dimTimer.limit = ll;
  }
}
