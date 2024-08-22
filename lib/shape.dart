import 'dart:math';

import 'package:flutter/material.dart';

class Shape {
  int colLenght = 15;
  int rowLength = 23;
  int _score = 0;
  List<int> shapeLoc = [0, 0, 0, 0];
  int rotateCycle = 0;
  int randomShape = 0;
  List shapes = ['i', 'j', 'l', 'o', 's', 'z', 't'];
  List<List<int>> boardList =
      List.generate(15, (i) => List.generate(23, (j) => -1));

  List<Color> shapeColor = [
    const Color(0xffffa500),
    const Color(0xff008000),
    const Color(0xffff0000),
    const Color(0xffffff00),
    const Color.fromARGB(255, 0, 102, 255),
    const Color.fromARGB(255, 242, 0, 255),
    const Color.fromARGB(255, 144, 0, 255),
  ];

  Color getCurrentColor() {
    return shapeColor[randomShape];
  }

  void nextShape() {
    shapeLoc = [0, 0, 0, 0];
    rotateCycle = 0;
    randomShape = Random().nextInt(shapes.length);
  }

  void shapeFirstLoc() {
    nextShape();
    switch (shapes[randomShape]) {
      case 'i':
        shapeLoc = [7, 8, 9, 10];
        break;
      case 'j':
        shapeLoc = [7, 8, 9, 24];
        break;
      case 'l':
        shapeLoc = [9, 8, 7, 22];
        break;
      case 'o':
        shapeLoc = [7, 8, 22, 23];
        break;
      case 's':
        shapeLoc = [9, 8, 23, 22];
        break;
      case 'z':
        shapeLoc = [8, 9, 24, 25];
        break;
      case 't':
        shapeLoc = [7, 8, 9, 23];
        break;
    }
  }

  List getShapeLoc() {
    shapeFirstLoc();
    return shapeLoc;
  }

  List movement() {
    if (gameOver() == true) {
      return shapeLoc;
    }
    if (checkBoundries() == true) {
      saveShapeLoc();
      shapeFirstLoc();
    } else {
      shapeLocAdder(15);
    }
    completeRow();

    return shapeLoc;
  }

  void moveRight() {
    bool wallChecker = false;
    for (int i = 0; i < shapeLoc.length; i++) {
      int point = shapeLoc[i];

      List pointLoc = getColRowPoint(point);
      if (point % 15 == 14) {
        wallChecker = true;
        break;
      }
      if (boardList[pointLoc[0] + 1][pointLoc[1]] != -1) {
        wallChecker = true;
        break;
      }
    }

    if (wallChecker == false) {
      shapeLocAdder(1);
    }
  }

  void moveLeft() {
    bool wallChecker = false;
    for (int i = 0; i < shapeLoc.length; i++) {
      int point = shapeLoc[i];
      List pointLoc = getColRowPoint(point);

      if (point % 15 == 0) {
        wallChecker = true;
        break;
      }
      if (boardList[pointLoc[0] - 1][pointLoc[1]] != -1) {
        wallChecker = true;
        break;
      }
    }
    if (wallChecker == false) {
      shapeLocAdder(-1);
    }
  }

  void rotate() {
    switch (shapes[randomShape]) {
      case 'i':
        if (rotateCycle % 2 == 0) {
          shapeLocChangeByList(adder: [0, 14, 28, 42]);
        } else {
          shapeLocChangeByList(adder: [0, -14, -28, -42]);
        }
        /**
         * solve this problem to use general restartRotateCycle in it
         */
        if (rotateCycle >= 3) {
          rotateCycle = 0;
        } else {
          rotateCycle++;
        }
        break;
      case 'j':
        restartRotateCycle();

        if (rotateCycle == 0) {
          shapeLocChangeByList(adder: [-1, 1, -13, -13]);
        } else if (rotateCycle == 1) {
          shapeLocChangeByList(adder: [1, 15, 29, 13]);
        } else if (rotateCycle == 2) {
          shapeLocChangeByList(adder: [14, 14, 0, 2]);
        } else if (rotateCycle == 3) {
          shapeLocChangeByList(adder: [-14, -30, -16, -2]);
        }

        break;
      case 'l':
        restartRotateCycle();

        if (rotateCycle == 0) {
          shapeLocChangeByList(adder: [2, 0, -16, -16]);
        } else if (rotateCycle == 1) {
          shapeLocChangeByList(adder: [-1, 15, 31, 17]);
        } else if (rotateCycle == 2) {
          shapeLocChangeByList(adder: [29, 15, 1, -15]);
        } else if (rotateCycle == 3) {
          shapeLocChangeByList(adder: [-30, -30, -16, 14]);
        }

        break;
      case 'o':
        break;
      case 's':
        if (rotateCycle % 2 == 0) {
          shapeLocChangeByList(adder: [-1, 15, 1, 17]);
        } else {
          shapeLocChangeByList(adder: [1, -15, -1, -17]);
        }
        /**
         * solve this problem to use general restartRotateCycle in it
         */
        if (rotateCycle >= 3) {
          rotateCycle = 0;
        } else {
          rotateCycle++;
        }
        break;
      case 'z':
        if (rotateCycle % 2 == 0) {
          shapeLocChangeByList(adder: [1, 15, -1, 13]);
        } else {
          shapeLocChangeByList(adder: [-1, -15, 1, -13]);
        }
        /**
         * solve this problem to use general restartRotateCycle in it
         */
        if (rotateCycle >= 3) {
          rotateCycle = 0;
        } else {
          rotateCycle++;
        }
        break;
      case 't':
        restartRotateCycle();

        if (rotateCycle == 0) {
          shapeLocChangeByList(adder: [-1, -15, -29, 1]);
        } else if (rotateCycle == 1) {
          shapeLocChangeByList(adder: [1, 15, 29, 1]);
        } else if (rotateCycle == 2) {
          shapeLocChangeByList(adder: [14, 0, -14, -16]);
        } else if (rotateCycle == 3) {
          shapeLocChangeByList(adder: [-14, 0, 14, 14]);
        }

        break;
    }
  }

  bool checkBoundries() {
    bool checker = false;
    int x = shapeLoc.reduce(max);
    int lastRowPointer = colLenght * (rowLength - 1);
    if (x >= lastRowPointer) {
      checker = true;
    }
/**
 * check if the shape get boundries of board list
 *   board[shape.getColRowPoint(index)[0]] [shape.getColRowPoint(index)[1]]
 */
    for (int i = 0; i < shapeLoc.length; i++) {
      int point = shapeLoc[i];

      if (point >= lastRowPointer) {
        continue;
      } else {
        point += 15;
      }
      if (boardList[getColRowPoint(point)[0]][getColRowPoint(point)[1]] != -1) {
        checker = true;
      }
    }
    return checker;
  }

  List getColRowPoint(int point) {
    int colPoint = point % colLenght;
    int roepoint = point ~/ colLenght;

    return [colPoint, roepoint];
  }

  void saveShapeLoc() {
    boardList[getColRowPoint(shapeLoc[0])[0]][getColRowPoint(shapeLoc[0])[1]] =
        randomShape;
    boardList[getColRowPoint(shapeLoc[1])[0]][getColRowPoint(shapeLoc[1])[1]] =
        randomShape;
    boardList[getColRowPoint(shapeLoc[2])[0]][getColRowPoint(shapeLoc[2])[1]] =
        randomShape;
    boardList[getColRowPoint(shapeLoc[3])[0]][getColRowPoint(shapeLoc[3])[1]] =
        randomShape;
  }

  bool completeRow() {
    for (int i = 0; i < colLenght; i++) {
      if (boardList[i][22] == -1) {
        return false;
      }
    }
    _score++;
    shiftBoard();
    return true;
  }

  void shiftBoard() {
    for (int j = rowLength - 1; j > 0; j--) {
      for (int i = 0; i < colLenght; i++) {
        boardList[i][j] = boardList[i][j - 1];
      }
    }
  }

  void shapeLocAdder(int adder) {
    for (int i = 0; i < shapeLoc.length; i++) {
      shapeLoc[i] += adder;
    }
  }

  void shapeLocChangeByList({required List<int> adder}) {
    for (int i = 0; i < shapeLoc.length; i++) {
      shapeLoc[i] += adder[i];
    }
  }

  void restartRotateCycle() {
    if (rotateCycle >= 4) {
      rotateCycle = 0;
    } else {
      rotateCycle++;
    }
  }

  int getScore() {
    return _score;
  }

  bool gameOver() {
    for (int i = 0; i < colLenght; i++) {
      if (boardList[i][0] != -1) {
        shapeFirstLoc();
        boardList = List.generate(15, (i) => List.generate(23, (j) => -1));
        _score = 0;
        return true;
      }
    }
    return false;
  }
}
