import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/google_map/widgets/map_item_details.dart';
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
            right: 0,
            top: 50,
            child: MaterialButton(
              onPressed: () => {
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(CameraPosition(target: markers[selectedMarker].position, zoom: 17))
                )
              },
              color: Colors.white,
              textColor: Colors.black,
              padding: const EdgeInsets.all(10),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.gps_fixed,
                size: 20,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.white.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(mapMarkers.length, (index) {
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
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            top: MediaQuery.of(context).size.height * 0.65,
            child: PageView.builder(
              onPageChanged: (value) {
                if (isTapped) return;
                setState(() {
                  selectedMarker = value;
                });
              },
              controller: _pageController,
              itemCount: markers.length,
              itemBuilder: ((context, index) {
                final item = mapMarkers[index];
                return MapItemDetails(
                  mapMarker: item,
                  onPressedGoTo: () {
                    mapController.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(target: item.location, zoom: 20))
                    );
                  },
                  onPressedCall: () {
                    
                  },
                );
              })
            ),
          ),
        ],
      ),
    );
  }
}