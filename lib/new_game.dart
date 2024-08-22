import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tetris/shape.dart';

class TetrisScreen extends StatefulWidget {
  const TetrisScreen({super.key});

  @override
  State<TetrisScreen> createState() => _TetrisScreenState();
}

class _TetrisScreenState extends State<TetrisScreen> {
  List tet = [];
  Shape shape = Shape();
  late List<List<int>> board =
      List.generate(15, (i) => List.generate(23, (j) => 0));
  int score = 0;

  void gameMovement() {
    final Duration _interval = const Duration(milliseconds: 250);

    Timer.periodic(_interval, (Timer timer) {
      setState(() {
        tet = shape.movement();
        board = shape.boardList;
        score = shape.getScore();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    tet = shape.getShapeLoc();
    gameMovement();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    double paddingLeftRight = 0;
    if ((h / w) > 1.9) {
      paddingLeftRight = w * .01;
    } else if ((h / w) > 1.35) {
      paddingLeftRight = (((h / 2) - (h - w)) / 2) * 1.2;
    } else {
      paddingLeftRight = (((h / 2) - (h - w)) / 2) * 1;
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: h * .8,
            child: GridView.builder(
                padding: EdgeInsets.fromLTRB(
                    paddingLeftRight, h * .01, paddingLeftRight, 0),
                itemCount: (23 * 15).toInt(),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 15,
                  crossAxisSpacing: h * .001,
                  mainAxisSpacing: h * .001,
                ),
                itemBuilder: (context, index) {
                  if (tet.contains(index)) {
                    return Container(
                      color: shape.getCurrentColor(),
                    );
                  } else if (board[shape.getColRowPoint(index)[0]]
                          [shape.getColRowPoint(index)[1]] !=
                      -1) {
                    return Container(
                      color: shape.shapeColor[
                          board[shape.getColRowPoint(index)[0]]
                              [shape.getColRowPoint(index)[1]]],
                    );
                  } else {
                    return Container(
                      color: Colors.grey[850],
                    );
                  }
                }),
          ),
          Column(
            children: [
              Text(
                "Score: $score",
                style: const TextStyle(color: Colors.grey, fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    color: Colors.grey[600],
                    onPressed: () {
                      setState(() {
                        shape.moveLeft();
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  IconButton(
                    color: Colors.grey[600],
                    onPressed: () {
                      setState(() {
                        shape.rotate();
                      });
                    },
                    icon: const Icon(Icons.rotate_right_rounded),
                  ),
                  IconButton(
                    color: Colors.grey[600],
                    onPressed: () {
                      setState(() {
                        shape.moveRight();
                      });
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
