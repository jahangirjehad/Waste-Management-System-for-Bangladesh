import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationUpdateScreen extends StatefulWidget {
  @override
  _LocationUpdateScreenState createState() => _LocationUpdateScreenState();
}

class _LocationUpdateScreenState extends State<LocationUpdateScreen> {
  LatLng? _currentPosition;
  LatLng? _selectedPosition;

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Fetch the user's current location
  Future<void> _getCurrentLocation() async {
    LocationPermission permission;

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Move the map camera to current location
    if (_mapController != null) {
      _mapController?.moveCamera(
        CameraUpdate.newLatLng(_currentPosition!),
      );
    }
  }

  // Function to handle the map tap to select a location
  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
  }

  // Save the selected or current location
  void _saveLocation() {
    final LatLng? locationToSave = _selectedPosition ?? _currentPosition;
    if (locationToSave != null) {
      // TODO: Save the location (Send location to the server, update the profile, etc.)
      print(
          'Location saved: ${locationToSave.latitude}, ${locationToSave.longitude}');
      Navigator.pop(context, locationToSave); // Returning the saved location
    } else {
      print("No location selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveLocation, // Save the location
          ),
        ],
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                _mapController?.moveCamera(
                  CameraUpdate.newLatLng(_currentPosition!),
                );
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 14.0,
              ),
              onTap: _onMapTapped, // Allow the user to tap and select location
              markers: _selectedPosition != null
                  ? {
                      Marker(
                        markerId: MarkerId('selected_location'),
                        position: _selectedPosition!,
                      ),
                    }
                  : {},
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
