import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/google_map/widgets/back_to_menu.dart';
import 'package:maps_app/google_map/widgets/button_center_map_on_the_marker.dart';
import 'package:maps_app/google_map/widgets/list_details.dart';
import 'package:maps_app/google_map/widgets/page_indicator.dart';
import 'package:maps_app/helpers/assets_to_bytes.dart';
import 'package:maps_app/mocks/map_markers.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final _pageController = PageController();
  late final GoogleMapController mapController;
  Position? _currentPosition;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor? markerIconSelected = BitmapDescriptor.defaultMarker;
  int selectedMarker = 0;
  bool isTapped = false;

  void _addCustomMarker() async {
    final icon = BitmapDescriptor.fromBytes(
      await assetToBytes('assets/location_pin.png', width: 80, height: 80)
    );
    setState(() {
      markerIcon = icon;
    });
  }

  void _addCustomMarkerSelected() async {
    final icon = BitmapDescriptor.fromBytes(
      await assetToBytes('assets/location_pin.png', width: 100, height: 100)
    );
    setState(() {
      markerIconSelected = icon;
    });
  }

  BitmapDescriptor validateMarkerSelected(bool selected) {
    return selected ? markerIconSelected! : markerIcon;
  }

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  Future _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.denied:
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
        break;
      case LocationPermission.deniedForever:
        throw Exception('Location permissions are permanently denied, we cannot request permissions.');
      default:
        break;
    }

    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onPageChanged(int value) {
    if (isTapped) return;
    setState(() {
      selectedMarker = value;
    });
  }

  List<Marker> buildMarkers() {
    final markerList = <Marker>[];
    for (int i = 0; i < mapMarkers.length; i++) {
      final mapItem = mapMarkers[i];
      markerList.add(
        Marker(
          icon: validateMarkerSelected(selectedMarker == i),
          markerId: MarkerId(i.toString()),
          position: mapItem.location,
          onTap: () {
            if (kDebugMode) print('Selected marker: ${mapItem.title}');
            selectedMarker = i;
            isTapped = true;
            setState(() {
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(CameraPosition(target: mapItem.location, zoom: 17))
              );
              _pageController.animateToPage(i,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease
              );
            });
          },
        ),
      );
    }

    return markerList;
  }

  @override
  void initState() {
    _addCustomMarker();
    _addCustomMarkerSelected();
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final markers = buildMarkers();

    return Scaffold(
      body: Stack(
        children: [
          _currentPosition == null ? 
          const Center(child: CircularProgressIndicator()) :
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            initialCameraPosition: const CameraPosition(
              target: LatLng(7.9145828862184, -72.48626491089652),
              zoom: 17,
            ),
            markers: markers.toSet(),
          ),
          const BackToMenu(),
          ButtonCenterMapOnTheMarker(
            onPressed: () {
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(CameraPosition(
                  target: mapMarkers[selectedMarker].location, zoom: 17)
                )
              );
            },
          ),
          PageIndicator(
            selectedMarker: selectedMarker,
            numberOfPages: mapMarkers.length,
          ),
          ListDetails(
            pageController: _pageController,
            onPageChanged: (value) => onPageChanged(value),
            onPressedGoTo: (item) {
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(CameraPosition(target: item.location, zoom: 20))
              );
            },
            onPressedCall: () {},
          ),
        ],
      ),
    );
  }
}