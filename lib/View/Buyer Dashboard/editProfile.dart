import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Product {
  String name;
  String category;
  String description;
  String imageUrl;
  double minWeight;
  double maxWeight;
  double price;

  Product({
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.minWeight,
    required this.maxWeight,
    required this.price,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      minWeight: (map['minWeight'] ?? 0).toDouble(),
      maxWeight: (map['maxWeight'] ?? 0).toDouble(),
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'minWeight': minWeight,
      'maxWeight': maxWeight,
      'price': price,
    };
  }
}

class UserModel {
  String? userName;
  String? profileImageUrl;
  String? email;
  String? location;
  double? latitude;
  double? longitude;
  List<Product> products;

  UserModel({
    this.userName,
    this.profileImageUrl,
    this.email,
    this.location,
    this.latitude,
    this.longitude,
    List<Product>? products,
  }) : products = products ?? [];

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      userName: doc['userName'] ?? '',
      profileImageUrl: doc['profileImageUrl'] ?? '',
      email: doc['email'] ?? '',
      location: doc['location'] ?? '',
      latitude: doc['latitude']?.toDouble(),
      longitude: doc['longitude']?.toDouble(),
      products: List<Product>.from(
          (doc['products'] as List).map((item) => Product.fromMap(item))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'profileImageUrl': profileImageUrl,
      'email': email,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'products': products.map((product) => product.toMap()).toList(),
    };
  }
}

class EditProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;

  Future<UserModel> loadUserData() async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(userEmail).get();
    return UserModel.fromDocument(doc);
  }

  Future<String> uploadProfileImage(File image) async {
    final ref = _storage.ref().child('profile_images').child('$userEmail.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> updateProfile(UserModel userModel) async {
    await _firestore
        .collection('users')
        .doc(userEmail)
        .update(userModel.toMap());
  }
}

// Previous Product and UserModel classes remain the same...

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>
    with SingleTickerProviderStateMixin {
  final _controller = EditProfileController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  File? _profileImage;
  UserModel? _userModel;
  bool _isLoading = false;

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadUserData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      _userModel = await _controller.loadUserData();
      setState(() {
        _nameController.text = _userModel?.userName ?? '';
        _emailController.text = _userModel?.email ?? '';
        _locationController.text = _userModel?.location ?? '';
        _latitudeController.text = _userModel?.latitude?.toString() ?? '';
        _longitudeController.text = _userModel?.longitude?.toString() ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile data')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      _userModel?.userName = _nameController.text;
      _userModel?.email = _emailController.text;
      _userModel?.location = _locationController.text;
      _userModel?.latitude = double.tryParse(_latitudeController.text);
      _userModel?.longitude = double.tryParse(_longitudeController.text);

      if (_profileImage != null) {
        _userModel?.profileImageUrl =
            await _controller.uploadProfileImage(_profileImage!);
      }

      await _controller.updateProfile(_userModel!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() => _profileImage = File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image')),
      );
    }
  }

  void _editProduct(Product product, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return ProductDialog(
          product: product,
          onProductUpdated: (updatedProduct) {
            setState(() {
              _userModel?.products[index] = updatedProduct;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _userModel == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:
            Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w600)),
        //backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(),
                _buildProfileForm(),
                _buildProductsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      //color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(bottom: 32.0),
      child: Column(
        children: [
          Hero(
            tag: 'profile_image',
            child: GestureDetector(
              onTap: _pickProfileImage,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _profileImage != null
                      ? Image.file(
                          _profileImage!,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: _userModel?.profileImageUrl ?? '',
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white70,
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
          Hero(tag: 'text', child: Text('tap image to change')),
          SizedBox(height: 16),
          Text(
            'Tap to change profile picture',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person,
              validator: (value) => value!.isEmpty ? 'Name is required' : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              validator: (value) {
                if (value!.isEmpty) return 'Email is required';
                if (!value.contains('@')) return 'Invalid email format';
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _locationController,
              label: 'Location',
              icon: Icons.location_on,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateProfile,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Update Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildProductsList() {
    if (_userModel?.products.isEmpty ?? true) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No products added yet',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return AnimatedList(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      initialItemCount: _userModel?.products.length ?? 0,
      itemBuilder: (context, index, animation) {
        final product = _userModel!.products[index];
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(Icons.image, color: Colors.grey),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(Icons.error, color: Colors.grey),
                  ),
                ),
              ),
              title: Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    product.category,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                onPressed: () => _editProduct(product, index),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProductDialog extends StatefulWidget {
  final Product? product;
  final Function(Product) onProductUpdated;

  ProductDialog({this.product, required this.onProductUpdated});

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File? _productImage;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _categoryController.text = widget.product!.category;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      if (widget.product!.imageUrl.isNotEmpty) {
        _productImage = File(widget.product!.imageUrl); // Load existing image
      }
    }
  }

  Future<void> _pickProductImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _productImage = File(pickedFile.path);
      });
    }
  }

  void _saveProduct() {
    final updatedProduct = Product(
      name: _nameController.text,
      category: _categoryController.text,
      description: _descriptionController.text,
      imageUrl: _productImage?.path ?? widget.product?.imageUrl ?? '',
      minWeight: 0,
      maxWeight: 0,
      price: double.parse(_priceController.text),
    );
    widget.onProductUpdated(updatedProduct);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product != null ? 'Edit Product' : 'Add Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: _categoryController,
            decoration: InputDecoration(labelText: 'Category'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          _productImage != null
              ? Image.file(
                  _productImage!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )
              : Text('No image selected'),
          ElevatedButton(
            onPressed: _pickProductImage,
            child: Text('Pick Product Image'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _saveProduct,
          child: Text('Save'),
        ),
      ],
    );
  }
}
