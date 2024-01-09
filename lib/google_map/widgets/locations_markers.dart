import 'package:flutter/material.dart';

class LocationMarker extends StatelessWidget {
  const LocationMarker({
    super.key,
    required this.maxSize,
    required this.minSize,
    this.selected = false,
  });

  final bool selected;
  final maxSize;
  final minSize;

  @override
  Widget build(BuildContext context) {
    final size = selected ? maxSize : minSize;

    return Center(
      child: AnimatedContainer(
        width: size,
        height: size,
        duration: const Duration(milliseconds: 500),
        child: Image.asset('assets/location_pin.png'),
      ),
    );
  }
}