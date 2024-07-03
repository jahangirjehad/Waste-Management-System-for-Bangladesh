import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maps_app/View/Market_Place/productDetails.dart';
import 'package:maps_app/View/Market_Place/sellItem.dart';

import '../../Model/marketplaceProcuctModel,dart.dart';

class MarketPlacePage extends StatefulWidget {
  const MarketPlacePage({Key? key}) : super(key: key);

  @override
  _MarketPlacePageState createState() => _MarketPlacePageState();
}

class _MarketPlacePageState extends State<MarketPlacePage> {
  List<Product> products = [];
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.trending_up, 'label': 'Trending', 'color': Colors.red},
    {'icon': Icons.directions_car, 'label': 'Vehicles', 'color': Colors.blue},
    {'icon': Icons.home, 'label': 'Property', 'color': Colors.green},
    {
      'icon': Icons.phone_android,
      'label': 'Electronics',
      'color': Colors.orange
    },
    {'icon': Icons.chair, 'label': 'Home & Garden', 'color': Colors.purple},
    {'icon': Icons.more_horiz, 'label': 'More', 'color': Colors.brown},
  ];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/jahangirjehad/JSON-FIle/master/marketplaces_products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        products = data.map((json) => Product.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildQuickActions(),
            _buildCategoryList(),
            _buildActionButtons(),
            Expanded(
              child: _buildProductGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Marketplace',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black, size: 28),
            onPressed: () {
              // Handle search
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black, size: 28),
            onPressed: () {
              // Handle notifications
            },
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionItem(Icons.storefront, 'Your Store'),
          _buildQuickActionItem(Icons.campaign, 'Advertise'),
          _buildQuickActionItem(Icons.local_offer, 'Deals'),
          _buildQuickActionItem(Icons.sell, 'Sell'),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.blue[700], size: 24),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: InkWell(
              onTap: () {
                // Handle category selection
                print('Selected category: ${categories[index]['label']}');
              },
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: categories[index]['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      categories[index]['icon'],
                      color: categories[index]['color'],
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    categories[index]['label'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              icon: Icon(Icons.add, size: 18),
              label: Text('Sell', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SellPage()));
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue[700]!),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sort, size: 18, color: Colors.blue[700]),
                  SizedBox(width: 4),
                  Icon(Icons.filter_list, size: 18, color: Colors.blue[700]),
                  SizedBox(width: 4),
                  Text('Filter & Sort',
                      style: TextStyle(fontSize: 16, color: Colors.blue[700])),
                ],
              ),
              onPressed: () {
                _showFilterDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return products.isEmpty
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductTile(product: products[index]);
            },
          );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter & Sort',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Sort by',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  ChoiceChip(
                    label: Text('Price: Low to High'),
                    selected: false,
                    onSelected: (bool selected) {},
                  ),
                  ChoiceChip(
                    label: Text('Price: High to Low'),
                    selected: false,
                    onSelected: (bool selected) {},
                  ),
                  ChoiceChip(
                    label: Text('Newest First'),
                    selected: false,
                    onSelected: (bool selected) {},
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Apply'),
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProductTile extends StatelessWidget {
  final Product product;

  ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetails(product: product)),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      Center(child: Icon(Icons.error)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.price,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketBottomNavBar extends StatefulWidget {
  const MarketBottomNavBar({Key? key}) : super(key: key);

  @override
  State<MarketBottomNavBar> createState() => _MarketBottomNavBarState();
}

class _MarketBottomNavBarState extends State<MarketBottomNavBar> {
  @override
  int pageIndex = 0;
  final List<Widget> pages = [
    const MarketPlacePage(),
    const Text('Saved'),
    const Text('Message'),
    const Text('Profile')
  ];

  void navigateToPage(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: navigateToPage,
        currentIndex: pageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
      body: pages[pageIndex],
    );
  }
}
