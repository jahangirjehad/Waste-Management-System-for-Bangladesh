import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _companyName = 'Company XYZ'; // Replace with actual company name
  String _phoneNumber = '1234567890'; // Replace with actual phone number
  String _latitude = '0.0'; // Replace with actual latitude
  String _longitude = '0.0'; // Replace with actual longitude
  String _email = 'example@example.com'; // Replace with actual email
  File? _profileImage; // Stores the selected profile image file

  // Method to handle changing the profile image
  void _changeProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Method to handle submitting changes
  void _submitChanges() {
    // Implement logic to save changes to backend or local storage
    // Example: send updated data to API or update local storage
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Changes saved successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFE0E5EC), // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: NeumorphicContainer(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Image with Change Image Icon
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors
                                .white, //  Replace with actual background color or image
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: _profileImage != null
                                ? Image.file(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    'https://img.freepik.com/free-vector/isolated-young-handsome-man-different-poses-white-background-illustration_632498-859.jpg?w=740&t=st=1718398909~exp=1718399509~hmac=76aeacbe2e2d59d381a1cfddeafeaa7bf5e8d39620fd1fc8b9034a028ecbbbdf',
                                    fit: BoxFit.cover,
                                  ), // Replace with actual image
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: _changeProfileImage,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    NeumorphicTextField(
                      labelText: 'Company Name',
                      initialValue: _companyName,
                      onChanged: (value) {
                        setState(() {
                          _companyName = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    NeumorphicTextField(
                      labelText: 'Phone Number',
                      initialValue: _phoneNumber,
                      onChanged: (value) {
                        setState(() {
                          _phoneNumber = value;
                        });
                      },
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: NeumorphicTextField(
                            labelText: 'Latitude',
                            initialValue: _latitude,
                            onChanged: (value) {
                              setState(() {
                                _latitude = value;
                              });
                            },
                            keyboardType: TextInputType.numberWithOptions(
                              signed: true,
                              decimal: true,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: NeumorphicTextField(
                            labelText: 'Longitude',
                            initialValue: _longitude,
                            onChanged: (value) {
                              setState(() {
                                _longitude = value;
                              });
                            },
                            keyboardType: TextInputType.numberWithOptions(
                              signed: true,
                              decimal: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    NeumorphicTextField(
                      labelText: 'Email',
                      initialValue: _email,
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    NeumorphicButton(
                      onPressed: _submitChanges,
                      label: 'Submit',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Neumorphic Container Widget
class NeumorphicContainer extends StatelessWidget {
  final Widget child;

  const NeumorphicContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}

// Neumorphic Text Field Widget
class NeumorphicTextField extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final TextInputType keyboardType;
  final Function(String)? onChanged;

  const NeumorphicTextField({
    required this.labelText,
    required this.initialValue,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}

// Neumorphic Button Widget
class NeumorphicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const NeumorphicButton({
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
