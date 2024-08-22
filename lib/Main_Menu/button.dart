import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton({super.key, required this.screen});
  final List screen;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
        ),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => screen[1])),
        child: Text(screen[0]));
  }
}
