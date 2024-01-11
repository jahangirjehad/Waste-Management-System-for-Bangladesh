
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart' as latLng;

import 'package:maps_app/google_map/widgets/google_tile_layer_widget.dart';
import 'package:maps_app/google_map/widgets/locations_markers.dart';
import 'package:maps_app/google_map/widgets/map_item_details.dart';
import 'package:maps_app/google_map/widgets/my_location_marker.dart';
import 'package:maps_app/mocks/map_markers.dart';
import 'package:maps_app/utils/animate_move_map.dart';


const MARK_COLOR = Color.fromARGB(255, 0, 105, 191);
const _myLocation = latLng.LatLng(7.9145828862184, -72.48626491089652);
const MARKER_SIZE_EXPANDED = 55.0;
const MARKER_SIZE_SHRINKED = 38.0;

class GoogleMapPageFm extends StatefulWidget {
  const GoogleMapPageFm({super.key});

  @override
  State<GoogleMapPageFm> createState() => _GoogleMapPageFmState();
}

class _GoogleMapPageFmState extends State<GoogleMapPageFm> with TickerProviderStateMixin{

  final _pageController = PageController();
  late final AnimationController _animationController;
  flutterMap.MapController? mapController;
  AnimateMoveMap? animateMoveMap;
  int _selectedIndex = 0;

  List<flutterMap.Marker> buildMarkers() {
    final markerList = <flutterMap.Marker>[];
    for (int i = 0; i < mapMarkers.length; i++) {
      final mapItem = mapMarkers[i];
      markerList.add(
        flutterMap.Marker(
          width: MARKER_SIZE_EXPANDED,
          height: MARKER_SIZE_EXPANDED,
          point: latLng.LatLng(mapItem.location.latitude, mapItem.location.longitude),
          child: GestureDetector(
            onTap: () {
              if (kDebugMode) print('Selected marker: ${mapItem.title}');
              _selectedIndex = i;
              setState(() {
                animateMoveMap?.animatedMapMove(latLng.LatLng(mapItem.location.latitude, mapItem.location.longitude), 17);
                _pageController.animateToPage(i,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease
                );
              });
            },
            child: LocationMarker(
              selected: _selectedIndex == i,
              maxSize: MARKER_SIZE_EXPANDED,
              minSize: MARKER_SIZE_SHRINKED,
            ),
          )
        )
      );
    }

    return markerList;
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    mapController = flutterMap.MapController();
    animateMoveMap = AnimateMoveMap(mapController: mapController!, context: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = buildMarkers();

    return Scaffold(
      body: Stack(
        children: [
          flutterMap.FlutterMap(
            mapController: mapController,
            options: const flutterMap.MapOptions(
              minZoom: kGoogleMapMinZoom,
              maxZoom: kGoogleMapMaxZoom,
              initialCenter: _myLocation,
              initialZoom: 17
            ),
            children: [
              GoogleMapTileLayer(
                mapType: MapType.normal,
                mapReady: (controller) => {
                  // setState(() {
                  //   mapController = controller;
                  // })
                },
              ),
              flutterMap.MarkerLayer(markers: markers),
              MyLocationMarker(
                MARK_COLOR,
                _myLocation, 
                _animationController,
              )
            ],
          ),
          Positioned(
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
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            top: MediaQuery.of(context).size.height * 0.65,
            child: PageView.builder(
              onPageChanged: (index) {
                if (kDebugMode) print('Selected marker: ${mapMarkers[index].title}');
                setState(() {
                  _selectedIndex = index;
                  animateMoveMap?.animatedMapMove(latLng.LatLng(mapMarkers[index].location.latitude, mapMarkers[index].location.longitude), 17);
                });
              },
              controller: _pageController,
              itemCount: markers.length,
              itemBuilder: ((context, index) {
                final item = mapMarkers[index];
                return MapItemDetails(
                  mapMarker: item,
                  onPressedGoTo: () {
                    animateMoveMap?.animatedMapMove(latLng.LatLng(item.location.latitude, item.location.longitude), 17);
                  },
                  onPressedCall: () {
                    
                  },
                );
              })
            ),
          )
        ],
      )
    );
  }
}