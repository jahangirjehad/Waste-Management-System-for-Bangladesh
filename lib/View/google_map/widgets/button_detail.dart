import 'package:flutter/material.dart';

class ButtonDetail extends StatelessWidget {
  const ButtonDetail({
    super.key,
    required this.colorButton,
    required this.onPressed,
    required this.textButton,
    required this.textColor,
  });

  final Color colorButton;
  final Function() onPressed;
  final String textButton;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorButton, colorButton],
        ),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: textColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPressed(),
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: Text(
              textButton,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      )
    );
  }
}
