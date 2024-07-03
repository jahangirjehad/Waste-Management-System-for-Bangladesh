import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
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
                    Text(
                      'Product Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    NeumorphicTextField(
                      labelText: 'Product Name',
                      hintText: 'Enter product name',
                    ),
                    SizedBox(height: 16),
                    NeumorphicTextField(
                      labelText: 'Price / kg',
                      hintText: 'Enter price per kg',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    NeumorphicTextField(
                      labelText: 'Minimum Sell kg',
                      hintText: 'Enter minimum sell kg',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    NeumorphicTextField(
                      labelText: 'Description',
                      hintText: 'Enter product description',
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),
                    NeumorphicButton(
                      onPressed: () {
                        // Handle submit action
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
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;

  const NeumorphicTextField({
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
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
