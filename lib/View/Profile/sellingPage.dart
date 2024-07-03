import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_app/Model/userModel.dart';
import 'package:maps_app/utils/my_colors.dart';

class SelllingFormScreen extends StatefulWidget {
  final RecyclingCompany recyclingCompany;

  const SelllingFormScreen({Key? key, required this.recyclingCompany})
      : super(key: key);

  @override
  State<SelllingFormScreen> createState() => _SelllingFormScreenState();
}

class _SelllingFormScreenState extends State<SelllingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _commentController = TextEditingController();

  SalesLocation? _selectedSalesLocation;

  Future<void> _pickImage() async {
    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
      }
    } catch (err) {
      print("exception");
      print(err);
    }
  }

  Widget _buildNeumorphicContainer(
      {required Widget child, double borderRadius = 12.0}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
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
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.caribbeanGreenTint7,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _buildNeumorphicContainer(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .75,
                      height: MediaQuery.of(context).size.width * .75,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _image == null
                          ? Icon(Icons.add_a_photo, color: Colors.grey[700])
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(File(_image!.path),
                                  fit: BoxFit.cover),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _buildNeumorphicContainer(
                  child: DropdownButtonFormField<SalesLocation>(
                    value: _selectedSalesLocation,
                    hint: Text('Select Sales Location'),
                    onChanged: (value) {
                      setState(() {
                        _selectedSalesLocation = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a sales location';
                      }
                      return null;
                    },
                    items: widget.recyclingCompany.salesLocations
                        .map((SalesLocation location) =>
                            DropdownMenuItem<SalesLocation>(
                              value: location,
                              child: Text(location.location),
                            ))
                        .toList(),
                  ),
                ),
                if (_selectedSalesLocation != null) ...[
                  SizedBox(height: 16),
                  _buildNeumorphicContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildReadOnlyFormField(
                          label: 'Salesman',
                          text: _selectedSalesLocation!.salesman,
                        ),
                        _buildReadOnlyFormField(
                          label: 'Address',
                          text: _selectedSalesLocation!.location,
                        ),
                        _buildReadOnlyFormField(
                          label: 'Phone',
                          text: _selectedSalesLocation!.mobile,
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 16),
                _buildNeumorphicContainer(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16.0),
                      labelText: 'Weight',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                _buildNeumorphicContainer(
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16.0),
                      labelText: 'Address',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                _buildNeumorphicContainer(
                  child: TextFormField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16.0),
                      labelText: 'Comment',
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          MyColors.caribbeanGreen), // Set the background color
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Handle form submission
                        final price = _priceController.text;
                        final address = _addressController.text;
                        final comment = _commentController.text;

                        print('Price: $price');
                        print('Address: $address');
                        print('Comment: $comment');
                        if (_selectedSalesLocation != null) {
                          print(
                              'Selected Salesman: ${_selectedSalesLocation!.salesman}');
                          print(
                              'Selected Salesman Address: ${_selectedSalesLocation!.location}');
                          print(
                              'Selected Salesman Phone: ${_selectedSalesLocation!.mobile}');
                        }
                        // Submit data or perform other actions
                      } else {
                        print('Validation failed');
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyFormField(
      {required String label, required String text}) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(16.0),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
