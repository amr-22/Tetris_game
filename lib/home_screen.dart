import 'package:flutter/material.dart';
import 'package:tetris/Main_Menu/main_menu_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainMenuScreen(),
    );
  }
}
