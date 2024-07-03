import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_app/utils/my_colors.dart';

class SellItemScreen extends StatefulWidget {
  @override
  _SellItemScreenState createState() => _SellItemScreenState();
}

class _SellItemScreenState extends State<SellItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _condition = 'Used - Like New';
  final List<String> _conditions = [
    'Used - Like New',
    'Used - Good',
    'Used - Fair'
  ];
  LatLng? _currentLocation;
  String? _currentAddress;
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _getAddressFromLatLng(_currentLocation!);
    });
  }

  Future<void> _pickLocation() async {
    LatLng? selectedLocation =
        await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          LocationPickerScreen(initialLocation: _currentLocation),
    ));
    if (selectedLocation != null) {
      setState(() {
        _currentLocation = selectedLocation;
        _getAddressFromLatLng(selectedLocation);
      });
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      setState(() {
        _currentAddress =
            "${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}";
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _currentLocation != null) {
      // Save listing to your backend with the location and address
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Listing created successfully!')));
      _formKey.currentState!.reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please fill in all fields and select a location')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.caribbeanGreenTint6,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: Offset(-6.0, -6.0),
                        blurRadius: 10.0,
                      ),
                      BoxShadow(
                        color: Colors.grey.shade600,
                        offset: Offset(6.0, 6.0),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: _image == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate,
                                  size: 50, color: Colors.grey[800]),
                              SizedBox(height: 8),
                              Text('Add Photo',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[800])),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 16),
              _buildNeumorphicTextField(_titleController, 'Title'),
              SizedBox(height: 16),
              _buildNeumorphicTextField(
                  _priceController, 'Price', TextInputType.number),
              SizedBox(height: 16),
              _buildNeumorphicDropdown(),
              SizedBox(height: 16),
              _buildNeumorphicTextField(
                _descriptionController,
                'Description',
                TextInputType.text,
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Location'),
                subtitle: Text(_currentAddress ?? 'No location selected'),
                trailing: ElevatedButton(
                  onPressed: _pickLocation,
                  child: Text('Edit'),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeumorphicTextField(
      TextEditingController controller, String labelText,
      [TextInputType keyboardType = TextInputType.text, int maxLines = 1]) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: Offset(-6.0, -6.0),
            blurRadius: 10.0,
          ),
          BoxShadow(
            color: Colors.grey.shade600,
            offset: Offset(6.0, 6.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildNeumorphicDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: Offset(-6.0, -6.0),
            blurRadius: 10.0,
          ),
          BoxShadow(
            color: Colors.grey.shade600,
            offset: Offset(6.0, 6.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _condition,
        decoration: InputDecoration(
          labelText: 'Condition',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: (String? newValue) {
          setState(() {
            _condition = newValue!;
          });
        },
        items: _conditions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  LocationPickerScreen({this.initialLocation});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_selectedLocation != null) {
      _mapController!.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _selectedLocation!, zoom: 15),
      ));
    }
  }

  Future<void> _onApplyLocation() async {
    if (_mapController != null) {
      LatLngBounds visibleRegion = await _mapController!.getVisibleRegion();
      LatLng center = LatLng(
        (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) /
            2,
        (visibleRegion.northeast.longitude +
                visibleRegion.southwest.longitude) /
            2,
      );
      _selectedLocation = center;
      Navigator.of(context).pop(center);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialLocation ?? LatLng(37.7749, -122.4194),
              zoom: 15,
            ),
            onMapCreated: _onMapCreated,
          ),
          Center(
            child: Icon(Icons.location_pin, size: 50, color: Colors.red),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _onApplyLocation,
              child: Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}
