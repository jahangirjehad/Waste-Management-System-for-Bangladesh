import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:maps_app/utils/my_colors.dart';

import '../SignUp/signUp_screen.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  String? selectedImagePath;
  File? _profileImage;
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  TimeOfDay? _startTime;
  String? _startTimeZone;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  String? _endTimeZone;
  String _eventType = 'In Person';
  String? _location;
  String? _meetingLink;
  String? _eventName;
  ImageProvider? _image;
  TextEditingController eventName = new TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();

  void _pickImage() async {
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

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _showMap() async {
    // Simulate location picking
    setState(() {
      _location = 'Selected Location';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: MediaQuery.of(context).size.width * .8,
                    height: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500]!,
                          offset: Offset(4, 4),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4, -4),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: _profileImage == null
                        ? Icon(Icons.add_a_photo,
                            size: 50, color: Colors.grey[700])
                        : Image.file(
                            _profileImage!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Name'),
                onSaved: (value) {
                  _eventName = value;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Start Date'),
                      readOnly: true,
                      onTap: () => _selectDate(context, true),
                      controller: TextEditingController(
                        text: _startDate != null
                            ? DateFormat.yMd().format(_startDate!)
                            : '',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Start Time'),
                      readOnly: true,
                      onTap: () => _selectTime(context, true),
                      controller: TextEditingController(
                        text: _startTime != null
                            ? _startTime!.format(context)
                            : '',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'End Date'),
                      readOnly: true,
                      onTap: () => _selectDate(context, false),
                      controller: TextEditingController(
                        text: _endDate != null
                            ? DateFormat.yMd().format(_endDate!)
                            : '',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'End Time'),
                      readOnly: true,
                      onTap: () => _selectTime(context, false),
                      controller: TextEditingController(
                        text: _endTime != null ? _endTime!.format(context) : '',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _eventType,
                decoration: InputDecoration(labelText: 'Event Type'),
                items: ['In Person', 'Virtual']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _eventType = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              if (_eventType == 'In Person')
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _navigateToMapScreen();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 80),
                        backgroundColor: MyColors.caribbeanGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Pick Location'),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: NeumorphicTextField(
                            controller: latController,
                            readOnly: true,
                            labelText: 'Latitude',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: NeumorphicTextField(
                            controller: longController,
                            readOnly: true,
                            labelText: 'Longitude',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (_eventType == 'Virtual')
                TextFormField(
                  decoration: InputDecoration(labelText: 'Meeting Link'),
                  onSaved: (value) {
                    _meetingLink = value;
                  },
                ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Handle create event action
                    }
                  },
                  child: Text('Create Event'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        latController.text = pickedLocation.latitude.toString();
        longController.text = pickedLocation.longitude.toString();
      });
    }
  }
}

class NeumorphicTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final bool readOnly;

  const NeumorphicTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            offset: const Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[300]!,
            Colors.grey[400]!,
          ],
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: labelText,
          filled: true,
          fillColor: Colors
              .transparent, // Set transparent background color for text field
          border: const OutlineInputBorder(
            borderSide: BorderSide.none, // Remove border side
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none, // Remove border side
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none, // Remove border side
          ),
          //prefixIcon: Icon(prefixIcon, color: Colors.grey[600]),
        ),
      ),
    );
  }
}
