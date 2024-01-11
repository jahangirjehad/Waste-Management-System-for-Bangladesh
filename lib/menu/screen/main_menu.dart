import 'package:flutter/material.dart';
import 'package:maps_app/menu/widgets/gradient_button.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientButton(
              textButton: 'Go to Map with Flutter_Map',
              onPressed: () => Navigator.pushNamed(context, '/google_maps_with_fm'),
            ),
            const SizedBox(height: 10),
            GradientButton(
              textButton: 'Go to Map without Flutter_Map',
              onPressed: () => Navigator.pushNamed(context, '/google_maps_without_fm'),
            ),
          ],
        ),
      ),
    );
  }
}