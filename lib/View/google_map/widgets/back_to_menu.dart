import 'package:flutter/material.dart';

class BackToMenu extends StatelessWidget {
  const BackToMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 50,
      child: MaterialButton(
        onPressed: () => Navigator.pop(context),
        color: Colors.white,
        textColor: Colors.black,
        padding: const EdgeInsets.all(10),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.arrow_back,
          size: 20,
        ),
      ),
    );
  }
}