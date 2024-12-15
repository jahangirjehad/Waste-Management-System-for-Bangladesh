import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController minSellController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

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
        title: const Text('Add Product'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFE0E5EC),
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
                    const Text(
                      'Product Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    NeumorphicTextField(
                      labelText: 'Product Name',
                      hintText: 'Enter product name',
                      controller: productNameController,
                    ),
                    const SizedBox(height: 16),
                    NeumorphicTextField(
                      labelText: 'Price / kg',
                      hintText: 'Enter price per kg',
                      controller: priceController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    NeumorphicTextField(
                      labelText: 'Minimum Sell kg',
                      hintText: 'Enter minimum sell kg',
                      controller: minSellController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    NeumorphicTextField(
                      labelText: 'Description',
                      hintText: 'Enter product description',
                      controller: descriptionController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    NeumorphicButton(
                      onPressed: getImage,
                      label: 'Pick Image',
                    ),
                    const SizedBox(height: 16),
                    _image != null
                        ? Image.file(_image!)
                        : const Text('No image selected.'),
                    const SizedBox(height: 20),
                    NeumorphicButton(
                      onPressed: () {
                        _submitProduct(context);
                      },
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

  Future<void> _submitProduct(BuildContext context) async {
    String productName = productNameController.text.trim();
    String price = priceController.text.trim();
    String minSell = minSellController.text.trim();
    String description = descriptionController.text.trim();

    // Check if required fields are filled
    if (productName.isEmpty ||
        price.isEmpty ||
        minSell.isEmpty ||
        description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All fields except image are required!"),
        ),
      );
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User is not logged in")),
      );
      return;
    }

    String buyerEmail = user.email!; // Use buyer's email only

    try {
      String? downloadUrl; // Variable to store image URL, if any

      // If an image is selected, upload it
      if (_image != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('product_images/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
        TaskSnapshot taskSnapshot = await uploadTask;
        downloadUrl = await taskSnapshot.ref.getDownloadURL();
      }

      // Save data to the 'products' collection in Firebase Firestore
      CollectionReference products =
          FirebaseFirestore.instance.collection('products');
      DocumentReference newProductRef = products.doc();
      await newProductRef.set({
        'name': productName,
        'description': description,
        'features': {
          'price_per_kg': price,
          'min_sell_kg': minSell,
        },
        'imageUrl': downloadUrl ??
            '', // Add image URL if available, otherwise empty string
        'buyer_email': buyerEmail, // Add buyer email field
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added successfully!")),
      );

      // Clear the form
      productNameController.clear();
      priceController.clear();
      minSellController.clear();
      descriptionController.clear();
      setState(() {
        _image = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add product: $e")),
      );
    }
  }
}

// (NeumorphicContainer, NeumorphicTextField, and NeumorphicButton classes remain the same)

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
            offset: const Offset(0, 3), // changes position of shadow
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
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;

  const NeumorphicTextField({
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
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
