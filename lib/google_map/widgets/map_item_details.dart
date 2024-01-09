import 'package:flutter/material.dart';
import 'package:maps_app/google_map/widgets/button_detail.dart';
import 'package:maps_app/mocks/map_markers.dart';

class MapItemDetails extends StatelessWidget {
  const MapItemDetails({
    super.key, 
    required this.mapMarker,
    required this.onPressedGoTo,
    required this.onPressedCall,
  });

  final MapMarkers mapMarker;
  final Function() onPressedGoTo;
  final Function() onPressedCall;

  @override
  Widget build(BuildContext context) {
    final styleTitle = TextStyle(
      color: mapMarker.textColorTitle,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    final styleAddress = TextStyle(
      color: mapMarker.textColorAddress,
      fontSize: 14,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: mapMarker.gradientColor,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
            )
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Image.asset(mapMarker.image)
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(mapMarker.title, style: styleTitle, textAlign: TextAlign.center),
                            const SizedBox(height: 5),
                            Text(mapMarker.address, style: styleAddress)
                          ],
                        )
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonDetail(
                      colorButton: mapMarker.gradientColor[0], 
                      onPressed: () => onPressedGoTo(), 
                      textButton: "Ir a",
                      textColor: mapMarker.textColorTitle,
                    ),
                    const SizedBox(width: 10),
                    ButtonDetail(
                      colorButton: mapMarker.gradientColor[mapMarker.gradientColor.length - 1], 
                      onPressed: () => onPressedCall(), 
                      textButton: "Llamar",
                      textColor: mapMarker.textColorTitle,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}