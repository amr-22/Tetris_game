import 'package:flutter/material.dart';
import 'package:tetris/Main_Menu/button.dart';
import 'package:tetris/new_game.dart';

class MainMenuScreen extends StatelessWidget {
  MainMenuScreen({super.key});

  // Lst of screen that need to show in main menu [name of this button option , page ]

  List screens = [
    ['Tertris game', const TetrisScreen()]
  ];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: screens.length,
            padding: EdgeInsets.fromLTRB(w * .1, h * .2, w * .1, h * .2),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: h * .05,
              childAspectRatio: 4.0,
            ),
            itemBuilder: (context, index) {
              return MyButton(
                screen: screens[index],
              );
            }),
      ),
    );
  }
}
