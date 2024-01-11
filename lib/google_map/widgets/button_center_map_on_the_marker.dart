import 'package:flutter/material.dart';

class ButtonCenterMapOnTheMarker extends StatelessWidget {
  const ButtonCenterMapOnTheMarker({
    super.key,
    required this.onPressed,
  });

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
            right: 0,
            top: 50,
            child: MaterialButton(
              onPressed: () => onPressed(),
              color: Colors.white,
              textColor: Colors.black,
              padding: const EdgeInsets.all(10),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.gps_fixed,
                size: 20,
              ),
            ),
          );
  }
}