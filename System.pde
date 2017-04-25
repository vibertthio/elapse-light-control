class System {
  Strip[] strips;
  int nOfStrips = 12;

  System() {
    strips = new Strip[nOfStrips];
    for (int i = 0; i < nOfStrips; i++) {
      if (i < 4) {
        strips[i] = new Strip(i, 0, width / 2, 100 + 50 * i);
      } else if (i < 8) {
        strips[i] = new Strip((i - 4), 0, 400, 300 + 50 * (i - 4));
      } else { // i < 12
        strips[i] = new Strip((i - 8), 0, 1000, 300 + 50 * (i - 8));
      }
    }
  }

  void render() {
    canvas.beginDraw();
    canvas.background(0);

    for (int i = 0; i < nOfStrips; i++) {
      strips[i].update();
      strips[i].render();
    }

    image(canvas, 0, 0);
    canvas.endDraw();
    server.sendImage(canvas);
  }

  void turnOn() {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].turnOn();
    }
  }

  void turnOn(int time) {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].turnOn(time);
    }
  }

  void turnOff() {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].turnOff();
    }
  }

  void turnOff(int time) {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].turnOff(time);
    }
  }

  void dimRepeat(int time, int ll) {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].dimRepeat(time, ll);
    }
  }

  void blink() {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].blink();
    }
  }

  void elapseTrigger() {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].elapseTrigger();
    }
  }



}
