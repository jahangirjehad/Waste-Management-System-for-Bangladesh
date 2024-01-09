import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

class MyLocationMarker extends AnimatedWidget {
  const MyLocationMarker(
    this.markColor, 
    this.myLocation,
    Animation<double> animation,
    {Key? key}
  ) : super(key: key, listenable: animation);

  final latLng.LatLng myLocation;
  final markColor;

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    final size = 50.0 * value;

    return MarkerLayer(
      markers: [
        Marker(
          point: myLocation,
          child: Center(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: size,
                    width: size,
                    decoration: BoxDecoration(
                      color: markColor.withOpacity(0.5),
                      shape: BoxShape.circle
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: markColor,
                      shape: BoxShape.circle
                    ),
                  ),
                ),
              ],
            )
          )
        )
      ]
    );
  }
}