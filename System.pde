class System {
  Strip[] strips;
  int nOfStrips = 12;

  System() {
    strips = new Strip[nOfStrips];
    for (int i = 0; i < nOfStrips; i++) {
      if (i < 4) {
        strips[i] = new Strip(i, 0, 400, 300 + 50 * i);
      } else if (i < 8) {
        strips[i] = new Strip(i, 0, width / 2, 100 + 50 * (i - 4));
      } else { // i < 12
        strips[i] = new Strip(i, 0, 1000, 300 + 50 * (i - 8));
      }
    }
  }

  void render() {
    canvas.beginDraw();
    canvas.background(0);

    // turnEachOn
    if (turnEachOnActivate) {
      turnEachOn();
    }

    // turnSequence
    if (turnSequenceActivate) {
      turnSequence();
    }

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

  void turnOnFor(int time, int ll) {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].turnOnFor(time, ll);
    }
  }

  void turnOneOn(int id) {
    strips[id].turnOn();
  }

  void turnOneOn(int id, int time) {
    strips[id].turnOn(time);
  }

  void turnOneOnFor(int id, int time, int ll) {
    strips[id].turnOnFor(time, ll);
  }

  void turnRandOneOnFor(int time, int ll) {
    turnOneOnFor(int(random(nOfStrips)),time, ll);
  }

  void turnRandMultipleOnFor(int time, int ll) {
    final int NUM = int(random(nOfStrips));
    final IntList nums = new IntList(NUM);

    for (int rnd, i = 0; i != NUM; nums.append(rnd), ++i)
    do {
      rnd = (int) random(nOfStrips);
    } while (nums.hasValue(rnd));

    for (int i = 0; i < NUM; i++) {
      turnOneOnFor(nums.get(i), time, ll);
    }
  }

  boolean turnEachOnActivate = false;
  int turnEachOnTime = 0;
  int turnEachOnIndex = 0;
  int turnEachOnCount = 0;
  int turnEachOnCountLimit = 5;

  void triggerTurnEachOn(int time) {
    turnEachOnActivate = !turnEachOnActivate;
    turnEachOnTime = time;
  }

  void turnEachOn() {
    turnEachOnCount++;
    if (turnEachOnCount > turnEachOnCountLimit) {
      int prev = (turnEachOnIndex > 0)? (turnEachOnIndex - 1) : (nOfStrips - 1);
      turnOneOn(turnEachOnIndex, turnEachOnTime);
      turnOneOff(prev, turnEachOnTime);
      turnEachOnIndex = (turnEachOnIndex + 1) % nOfStrips;
      turnEachOnCount = 0;
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

  void turnOneOff(int id) {
    strips[id].turnOff();
  }

  void turnOneOff(int id, int time) {
    strips[id].turnOff(time);
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

  boolean turnSequenceActivate = false;
  int turnSequenceTime = 0;
  int turnSequenceIndex = 0;
  int turnSequenceCount = 0;
  int turnSequenceCountLimit = 2;
  int[][] sequenceSet = {
    { 0, 2, 5, 7, 8, 10 },
    { 0, 4, 8 },
    { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},
    { 0, 4, 8, 1, 5, 9, 2, 6, 10, 3, 7, 11 },
    { 0, 0, 0, 0},
  };
  int[] sequence;

  void triggerSequence(int index, int time) {
    turnOff();
    turnSequenceActivate = !turnSequenceActivate;
    turnSequenceTime = time;
    sequence = sequenceSet[index%sequenceSet.length];
    turnSequenceIndex = 0;
    turnSequenceCount = 0;
  }

  void turnSequence() {
    turnSequenceCount++;
    if (turnSequenceCount > turnSequenceCountLimit) {
      println(turnSequenceIndex);
      int prev = (turnSequenceIndex > 0)? (turnSequenceIndex - 1) : (sequence.length - 1);
      turnOneOn(sequence[turnSequenceIndex], turnSequenceTime);
      turnOneOff(sequence[prev], turnSequenceTime);
      turnSequenceIndex = (turnSequenceIndex + 1) % sequence.length;
      turnSequenceCount = 0;
    }
  }

  // position 4
  final int RANDSEQUENCE = 4;
  void turnFourRandSequence(int time) {
    final int NUM = 4;
    final IntList nums = new IntList(NUM);

    for (int rnd, i = 0; i != NUM; nums.append(rnd), ++i)
    do {
      rnd = (int) random(nOfStrips);
    } while (nums.hasValue(rnd));

    for (int i = 0; i < NUM; i++) {
      sequenceSet[RANDSEQUENCE][i] = nums.get(i);
    }
    triggerSequence(RANDSEQUENCE, time);
  }

}
