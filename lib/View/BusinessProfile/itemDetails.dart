import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductDetailsPage extends StatefulWidget {
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isEditing = false;
  String productName = 'Product Name';
  String productPrice = '৳ 100.00';
  String productDetails =
      'এটি একটি পণ্যের বিবরণ। এটি একটি খুব ভাল পণ্য যা আপনি কিনতে পারেন।';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  File? _image;

  final ImagePicker _picker = ImagePicker();

  void _editProduct() {
    setState(() {
      isEditing = true;
      _nameController.text = productName;
      _priceController.text = productPrice;
      _detailsController.text = productDetails;
    });
  }

  void _saveProduct() {
    setState(() {
      productName = _nameController.text;
      productPrice = _priceController.text;
      productDetails = _detailsController.text;
      isEditing = false;
    });
  }

  void _deleteProduct() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: isEditing ? _saveProduct : _editProduct,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteProduct,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image Carousel
              Container(
                height: 250,
                child: PageView(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: _image == null
                          ? Image.network(
                              'https://futurestartup.b-cdn.net/wp-content/uploads/2016/12/plastic-bottles-photo.jpg',
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Image.network(
                      'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Product Name
              _buildContainer(
                child: isEditing
                    ? TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          productName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 20),
              // Product Price
              _buildContainer(
                child: isEditing
                    ? TextField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Product Price',
                          border: OutlineInputBorder(),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          productPrice,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 20),
              // Product Details
              _buildContainer(
                child: isEditing
                    ? TextField(
                        controller: _detailsController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Product Details',
                          border: OutlineInputBorder(),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          productDetails,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 20),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(
                    onPressed: isEditing ? _saveProduct : _editProduct,
                    label: isEditing ? 'Save' : 'Edit',
                    color: isEditing ? Colors.green : Colors.blue,
                  ),
                  _buildButton(
                    onPressed: _deleteProduct,
                    label: 'Delete',
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildButton(
      {required VoidCallback onPressed,
      required String label,
      required Color color}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
