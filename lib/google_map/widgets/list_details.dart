import 'package:flutter/material.dart';
import 'package:maps_app/google_map/widgets/map_item_details.dart';
import 'package:maps_app/mocks/map_markers.dart';

class ListDetails extends StatelessWidget {
  const ListDetails({
    super.key,
    required this.pageController,
    required this.onPageChanged,
    required this.onPressedGoTo,
    required this.onPressedCall,
  });

  final PageController pageController;
  final Function(int) onPageChanged;
  final Function(MapMarkers) onPressedGoTo;
  final Function onPressedCall;
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 50,
      top: MediaQuery.of(context).size.height * 0.65,
      child: PageView.builder(
        onPageChanged: (value) => onPageChanged(value),
        controller: pageController,
        itemCount: mapMarkers.length,
        itemBuilder: ((context, index) {
          final item = mapMarkers[index];
          return MapItemDetails(
            mapMarker: item,
            onPressedGoTo: () => onPressedGoTo(item),
            onPressedCall: () => onPressedCall(),
          );
        })
      ),
    );
  }
}