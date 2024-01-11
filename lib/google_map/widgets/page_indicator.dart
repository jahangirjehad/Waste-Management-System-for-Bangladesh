import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.selectedMarker,
    required this.numberOfPages,
  });

  final int selectedMarker;
  final int numberOfPages;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        color: Colors.white.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(numberOfPages, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: selectedMarker == index ? 20 : 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: selectedMarker == index ? Colors.black : Colors.grey,
                borderRadius: BorderRadius.circular(5)
              ),
            );
          }),
        ),
      )
    );
  }
}