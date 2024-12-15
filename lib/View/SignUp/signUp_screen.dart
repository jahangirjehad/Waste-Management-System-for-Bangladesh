import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_app/utils/my_colors.dart';

import '../../Controller/AuthController.dart';

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

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthController _authController = AuthController();

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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential;
        String userId;
        String? profileImageUrl;

        // Upload profile image if selected
        if (_profileImage != null) {
          try {
            profileImageUrl = await _uploadProfileImage(_profileImage!);
            if (profileImageUrl == null) {
              throw Exception('Failed to upload profile image.');
            }
            print('Profile image uploaded successfully. URL: $profileImageUrl');
          } catch (e) {
            print('Error uploading profile image: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Failed to upload profile image. Please try again.')),
            );
            return; // Exit the function if image upload fails
          }
        } else {
          print('No profile image selected');
        }

        if (isCreateUser) {
          // Create user account
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          userId = userCredential.user!.uid;

          // Save additional user information to Firestore
          await FirebaseFirestore.instance.collection('users').doc(userId).set({
            'name': nameController.text,
            'email': emailController.text,
            'userType': 'individual',
            'createdAt': FieldValue.serverTimestamp(),
            'profileImageUrl':
                profileImageUrl ?? '', // Store image URL or empty string
          });
          print('User data saved to Firestore. User ID: $userId');
        } else {
          // Create organization account
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: orgEmailController.text,
            password: passwordController.text,
          );
          userId = userCredential.user!.uid;

          // Save organization information to Firestore
          await FirebaseFirestore.instance
              .collection('organizations')
              .doc(userId)
              .set({
            'name': orgNameController.text,
            'email': orgEmailController.text,
            'phone': orgPhoneController.text,
            'location': GeoPoint(
              double.parse(latController.text),
              double.parse(longController.text),
            ),
            'userType': 'organization',
            'createdAt': FieldValue.serverTimestamp(),
            'profileImageUrl': profileImageUrl ?? '',
          });
          print(
              'Organization data saved to Firestore. Organization ID: $userId');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );

        // Navigate to the next screen (e.g., home screen)
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } catch (e) {
        print('Error during registration: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<String?> _uploadProfileImage(File imageFile) async {
    try {
      // Read the image file into bytes
      Uint8List imageBytes = await imageFile.readAsBytes();

      String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');

      // Set metadata to indicate it's an image
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');

      // Upload the image as bytes instead of a file
      UploadTask uploadTask = storageReference.putData(imageBytes, metadata);

      // Wait for the upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;

      if (taskSnapshot.state == TaskState.success) {
        // Get the download URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        print('Image uploaded successfully. Download URL: $downloadUrl');
        return downloadUrl;
      } else {
        print('Upload task failed. State: ${taskSnapshot.state}');
        return null;
      }
    } catch (e) {
      print('Error in _uploadProfileImage: $e');
      return null;
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
                            WidgetStateProperty.all<Color>(Colors.green),
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
