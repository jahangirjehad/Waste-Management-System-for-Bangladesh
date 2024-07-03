import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_app/utils/my_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isCreateUser = true;
  File? _profileImage;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController orgEmailController = TextEditingController();
  final TextEditingController orgPhoneController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();

  void _changeProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: MyColors.caribbeanGreen,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildRegisterTypeToggle(),
                SizedBox(height: 24),
                _buildProfileImagePicker(),
                SizedBox(height: 24),
                if (isCreateUser)
                  _buildUserForm()
                else
                  _buildOrganizationForm(),
                SizedBox(height: 24),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterTypeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton('User', isCreateUser,
                () => setState(() => isCreateUser = true)),
          ),
          Expanded(
            child: _buildToggleButton('Organization', !isCreateUser,
                () => setState(() => isCreateUser = false)),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? MyColors.caribbeanGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!)
                : NetworkImage('https://via.placeholder.com/150')
                    as ImageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: MyColors.caribbeanGreen,
              child: IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.white),
                onPressed: _changeProfileImage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserForm() {
    return Column(
      children: [
        _buildTextField(nameController, 'Name'),
        SizedBox(height: 16),
        _buildTextField(emailController, 'Email',
            keyboardType: TextInputType.emailAddress),
        SizedBox(height: 16),
        _buildTextField(passwordController, 'Password', obscureText: true),
      ],
    );
  }

  Widget _buildOrganizationForm() {
    return Column(
      children: [
        _buildTextField(orgNameController, 'Organization Name'),
        SizedBox(height: 16),
        _buildTextField(orgEmailController, 'Email',
            keyboardType: TextInputType.emailAddress),
        SizedBox(height: 16),
        _buildTextField(orgPhoneController, 'Phone',
            keyboardType: TextInputType.phone),
        SizedBox(height: 16),
        _buildLocationPicker(),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildLocationPicker() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _navigateToMapScreen,
          icon: Icon(Icons.location_on),
          label: Text('Pick Location'),
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.caribbeanGreen,
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildTextField(
              latController,
              'Latitude',
            )),
            SizedBox(width: 16),
            Expanded(
                child: _buildTextField(
              longController,
              'Longitude',
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      child: Text('Register', style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.caribbeanGreen,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _navigateToMapScreen() async {
    final LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );

    if (pickedLocation != null) {
      setState(() {
        latController.text = pickedLocation.latitude.toStringAsFixed(6);
        longController.text = pickedLocation.longitude.toStringAsFixed(6);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process form data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing Registration')),
      );
    }
  }
}

// MapScreen remains largely unchanged, but you may want to apply similar styling improvements

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? pickedLocation;
  Position? currentPosition;
  bool showPickButton = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Location'),
      ),
      body: Stack(
        children: [
          if (currentPosition != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentPosition!.latitude,
                  currentPosition!.longitude,
                ),
                zoom: 14,
              ),
              onTap: _selectLocation,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                });
              },
              markers: Set.of((pickedLocation != null)
                  ? [
                      Marker(
                        markerId: MarkerId('picked_location'),
                        position: pickedLocation!,
                      )
                    ]
                  : []),
            ),
          if (isLoading) Center(child: CircularProgressIndicator()),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MyColors.caribbeanGreenTint6,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Please Tap on Organization Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, pickedLocation);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      child: Text(
                        'Picked',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = position;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching current location: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _selectLocation(LatLng location) {
    setState(() {
      pickedLocation = location;
      showPickButton =
          true; // Show the "Picked" button when location is selected
    });
  }
}
