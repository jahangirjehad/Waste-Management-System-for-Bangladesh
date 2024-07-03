import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_app/View/Market_Place/locationPick.dart';

class SellPage extends StatefulWidget {
  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              GestureDetector(
                  onTap: () {},
                  child: _buildNeumorphicTextField(
                      TextEditingController(), 'Location')),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellItemScreen()));
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
