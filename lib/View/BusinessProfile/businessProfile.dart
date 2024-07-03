import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:maps_app/View/BusinessProfile/addProduct.dart';
import 'package:maps_app/View/BusinessProfile/editProfile.dart';
import 'package:maps_app/View/BusinessProfile/itemDetails.dart';

class RecycleBuyerProfile extends StatelessWidget {
  const RecycleBuyerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7EBF0), // Subtle background color
      appBar: AppBar(
        title: const Text('Buyer Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87), // Dark icon color
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.2,
                    backgroundImage: const NetworkImage(
                      'https://img.freepik.com/free-vector/isolated-young-handsome-man-different-poses-white-background-illustration_632498-859.jpg?w=740&t=st=1718398909~exp=1718399509~hmac=76aeacbe2e2d59d381a1cfddeafeaa7bf5e8d39620fd1fc8b9034a028ecbbbdf',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Buyer Profile Name',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: RatingStars(
                  value: 3.5,
                  starSize: 24,
                  starColor: Colors.amber,
                  valueLabelColor: Colors.black26,
                  starOffColor: Colors.black26,
                ),
              ),
              const SizedBox(height: 24),

              // Add Product and Edit Profile Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NeumorphicButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProductPage()),
                      );
                    },
                    label: 'Add Product',
                  ),
                  NeumorphicButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()),
                      );
                    },
                    label: 'Edit Profile',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // List of Products
              Expanded(
                child: ListView(
                  children: const [
                    ProductListItem(
                      productName: 'Product A',
                      pricePerKg: '5.00',
                    ),
                    ProductListItem(
                      productName: 'Product B',
                      pricePerKg: '3.50',
                    ),
                    ProductListItem(
                      productName: 'Product C',
                      pricePerKg: '4.20',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Neumorphic Button Widget
class NeumorphicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const NeumorphicButton({
    super.key,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
              BoxShadow(
                color: Colors.white,
                spreadRadius: -2,
                blurRadius: 7,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

// Product List Item Widget
class ProductListItem extends StatelessWidget {
  final String productName;
  final String pricePerKg;

  const ProductListItem({
    super.key,
    required this.productName,
    required this.pricePerKg,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProductDetailsPage()));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            productName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'Price/kg: \$$pricePerKg',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios,
              size: 18, color: Colors.black45),
        ),
      ),
    );
  }
}
