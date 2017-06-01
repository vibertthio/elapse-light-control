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


  public void render() {
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

    if (complexSequenceActivate) {
      turnComplexSequence();
    }

    if (asyncSequenceActivate) {
      turnAsyncSequence();
    }

    if (complexAsyncSequenceActivate) {
      turnComplexAsyncSequence();
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

  void turnMultipleOnFor(int time, int ll, int number) {
    final int NUM = number;
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
  boolean bangSequence = false;
  int turnSequenceTime = 100;
  int turnSequenceIndex = 0;
  int turnSequenceCount = 0;
  int turnSequenceCountLimit = 2;
  int[][] sequenceSet = {
    { 0, 7, 8 }, // 0
    { 3, 4, 11 },
    { 0, 3, 4, 7, 8, 11 },
    { 0, 4, 8, 1, 5, 9, 2, 6, 10, 3, 7, 11 },
    { 0, 11, 4, 8 },
    { 9, 2, 1, 10 }, // 5
    { 0, 4, 8, 1, 5, 9, 2, 6, 10, 3, 7, 11 },
    { 8, 4, 0, 9, 5, 1, 10, 6, 2, 11, 7, 3 },
    { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
    { 8, 9, 10, 11, 4, 5, 6, 7, 0, 1, 2, 3 },
    { 0, 0, 0, 0}, // 10
    { 0, 0, 0, 0},
    { 0, 0, 0, 0}, // 12
  };
  int[] sequence;

  void triggerSequence() {
    turnSequenceActivate = !turnSequenceActivate;
    turnSequenceCount = 0;
  }
  void triggerSequence(int index) {
    turnOff();
    turnSequenceActivate = !turnSequenceActivate;
    sequence = sequenceSet[index%sequenceSet.length];
    turnSequenceIndex = 0;
    turnSequenceCount = 0;
  }
  void triggerSequence(int index, int time) {
    turnOff();
    turnSequenceActivate = !turnSequenceActivate;
    turnSequenceTime = time;
    sequence = sequenceSet[index%sequenceSet.length];
    turnSequenceIndex = 0;
    turnSequenceCount = 0;
  }
  void bangSequence(int index, int time) {
    triggerSequence(index, time);
    bangSequence = true;
  }
  void turnSequence() {
    turnSequenceCount++;
    if (turnSequenceCount > turnSequenceCountLimit) {
      // int prev = (turnSequenceIndex > 0)? (turnSequenceIndex - 1) : (sequence.length - 1);
      // turnOneOn(sequence[turnSequenceIndex], turnSequenceTime);
      // turnOneOff(sequence[prev], turnSequenceTime);
      turnOneOnFor(sequence[turnSequenceIndex], turnSequenceTime, 20);
      turnSequenceIndex = (turnSequenceIndex + 1) % sequence.length;
      turnSequenceCount = 0;

      if (bangSequence && turnSequenceIndex == 0) {
        triggerSequence();
        bangSequence = false;
      }
    }
  }

  // complex sequence
  boolean complexSequenceActivate = false;
  boolean bangComplexSequence = false;
  int complexSequenceTime = 20;
  int complexSequenceDur = 50;
  int complexSequenceIndex = 0;
  int complexSequenceCount = 0;
  int complexSequenceCountLimit = 5;
  int[][][] complexSequenceSet = {
    {
      {0, 1, 2, 3},
      {4, 5, 6, 7},
      {8, 9, 10, 11},
    },
    {
      {8, 9, 10, 11},
      {4, 5, 6, 7},
      {0, 1, 2, 3},
    },
    {
      {0, 4, 8},
      {1, 5, 9},
      {2, 6, 10},
      {3, 7, 11},
    },
  };
  int[][] complexSequence;
  void triggerComplexSequence() {
    complexSequenceActivate = !complexSequenceActivate;
    complexSequenceCount = 0;
  }
  void triggerComplexSequence(int index) {
    complexSequenceActivate = !complexSequenceActivate;
    complexSequence = complexSequenceSet[index%complexSequenceSet.length];
    complexSequenceIndex = 0;
    complexSequenceCount = 0;
  }
  void bangComplexSequence(int index) {
    triggerComplexSequence(index);
    bangComplexSequence = true;
  }
  void turnComplexSequence() {
    complexSequenceCount++;
    if (complexSequenceCount > complexSequenceCountLimit) {
      for (int i = 0, n = complexSequence[complexSequenceIndex].length; i < n; i++) {
        turnOneOnFor(complexSequence[complexSequenceIndex][i], complexSequenceDur, complexSequenceTime);
      }
      complexSequenceIndex = (complexSequenceIndex + 1) % complexSequence.length;
      complexSequenceCount = 0;

      if (bangComplexSequence && complexSequenceIndex == 0) {
        triggerComplexSequence();
        bangComplexSequence = false;
      }
    }
  }


  // position 4
  final int RANDSEQUENCE = 8;
  void turnFourRandSequence(int time) {
    final int NUM = 4;
    final IntList nums = new IntList(NUM);

    for (int rnd, i = 0; i <= NUM; nums.append(rnd), ++i)
    do {
      rnd = (int) random(nOfStrips);
    } while (nums.hasValue(rnd));

    for (int i = 0; i < NUM; i++) {
      sequenceSet[RANDSEQUENCE][i] = nums.get(i);
    }
    triggerSequence(RANDSEQUENCE, time);
  }
  void bangFourRandSequence(int time) {
    final int NUM = 4;
    final IntList nums = new IntList(NUM);

    for (int rnd, i = 0; i <= NUM; nums.append(rnd), ++i)
    do {
      rnd = (int) random(nOfStrips);
    } while (nums.hasValue(rnd));

    for (int i = 0; i < NUM; i++) {
      sequenceSet[RANDSEQUENCE][i] = nums.get(i);
    }
    bangSequence(RANDSEQUENCE, time);
  }



  // rand on off
  int randomDimOnOffTime = 100;
  void turnRandOneOn() {
    int rnd;
    do {
      rnd = (int) random(nOfStrips);
    }  while (strips[rnd].alpha > 0);
    turnOneOn(rnd, randomDimOnOffTime);
  }
  void turnRandOneOff() {
    int rnd;
    do {
      rnd = (int) random(nOfStrips);
    }  while (strips[rnd].alpha < 100);
    turnOneOff(rnd, randomDimOnOffTime);
  }

  // asynce sequence
  boolean asyncSequenceActivate = false;
  boolean bangAsyncSequence = false;
  int asyncSequenceTime = 50;
  int asyncSequenceIndex = 0;
  int asyncSequenceCount = 0;
  int asyncSequenceCountLimit = 5;
  int[][] asyncSequenceSet = {
    { 0, 1, 2, 3, 3, 2, 1, 0 },
    { 4, 5, 6, 7, 7, 6, 5, 4 },
    { 8, 9, 10, 11, 11, 10, 9, 8 },

    { 3, 2, 1, 0, 0, 1, 2, 3 },
    { 7, 6, 5, 4, 4, 5, 6, 7 },
    { 11, 10, 9, 8, 8, 9, 10, 11 },
  };
  boolean[] asyncRecord = {
    false, false, false, false,
    false, false, false, false,
    false, false, false, false,
  };
  int[] asyncSequence;

  void triggerAsyncSequence() {
    asyncSequenceActivate = !asyncSequenceActivate;
    asyncSequenceCount = 0;
  }
  void triggerAsyncSequence(int index) {
    for (int i = 0, n = nOfStrips; i < n; i++) {
      asyncRecord[i] = false;
    }
    turnOff();
    asyncSequenceActivate = !asyncSequenceActivate;
    asyncSequence = asyncSequenceSet[index%asyncSequenceSet.length];
    asyncSequenceIndex = 0;
    asyncSequenceCount = 0;
  }
  void bangAsyncSequence(int index) {
    triggerAsyncSequence(index);
    bangAsyncSequence = true;
  }
  void turnAsyncSequence() {
    asyncSequenceCount++;
    if (asyncSequenceCount > asyncSequenceCountLimit) {
      println(asyncSequenceIndex);

      if (asyncRecord[asyncSequence[asyncSequenceIndex]]) {
        turnOneOff(asyncSequence[asyncSequenceIndex], asyncSequenceTime);
      } else {
        turnOneOn(asyncSequence[asyncSequenceIndex], asyncSequenceTime);
      }
      asyncRecord[asyncSequence[asyncSequenceIndex]] = !asyncRecord[asyncSequence[asyncSequenceIndex]];
      asyncSequenceIndex = (asyncSequenceIndex + 1) % asyncSequence.length;
      asyncSequenceCount = 0;

      if (bangAsyncSequence && asyncSequenceIndex == 0) {
        triggerAsyncSequence();
        bangAsyncSequence = false;
      }
    }
  }

  // complex async sequence
  boolean complexAsyncSequenceActivate = false;
  boolean bangComplexAsyncSequence = false;
  int complexAsyncSequenceTime = 50;
  int complexAsyncSequenceIndex = 0;
  int complexAsyncSequenceCount = 0;
  int complexAsyncSequenceCountLimit = 5;
  int[][][] complexAsyncSequenceSet = {
    {
      { 0, 4, 8 },
      { 1, 5, 9 },
      { 2, 6, 10 },
      { 3, 7, 11 },
      { 3, 7, 11 },
      { 2, 6, 10 },
      { 1, 5, 9 },
      { 0, 4, 8 },
    },
  };
  boolean[] complexAsyncRecord = {
    false, false, false, false,
    false, false, false, false,
    false, false, false, false,
  };
  int[][] complexAsyncSequence;

  void triggerComplexAsyncSequence() {
    complexAsyncSequenceActivate = !complexAsyncSequenceActivate;
    complexAsyncSequenceCount = 0;
  }
  void triggerComplexAsyncSequence(int index) {
    for (int i = 0, n = nOfStrips; i < n; i++) {
      complexAsyncRecord[i] = false;
    }
    turnOff();
    complexAsyncSequenceActivate = !complexAsyncSequenceActivate;
    complexAsyncSequence = complexAsyncSequenceSet[index%complexAsyncSequenceSet.length];
    complexAsyncSequenceIndex = 0;
    complexAsyncSequenceCount = 0;
  }
  void bangComplexAsyncSequence(int index) {
    triggerComplexAsyncSequence(index);
    bangComplexAsyncSequence = true;
  }
  void turnComplexAsyncSequence() {
    complexAsyncSequenceCount++;
    if (complexAsyncSequenceCount > complexAsyncSequenceCountLimit) {
      println(complexAsyncSequenceIndex);

      int[] cas = complexAsyncSequence[complexAsyncSequenceIndex];
      for (int i = 0, n = cas.length; i < n; i++) {
        if (complexAsyncRecord[cas[i]]) {
          turnOneOff(cas[i], complexAsyncSequenceTime);
        } else {
          turnOneOn(cas[i], complexAsyncSequenceTime);
        }
        complexAsyncRecord[cas[i]] = !complexAsyncRecord[cas[i]];
      }
      complexAsyncSequenceIndex = (complexAsyncSequenceIndex + 1) % complexAsyncSequence.length;
      complexAsyncSequenceCount = 0;

      if (bangComplexAsyncSequence && complexAsyncSequenceIndex == 0) {
        triggerComplexAsyncSequence();
        bangComplexAsyncSequence = false;
      }
    }
  }




}
