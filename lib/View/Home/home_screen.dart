import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps_app/View/Home/imageSlider.dart';

import '../BusinessProfile/businessProfile.dart';
import '../Detection/wasteDetectionScreen.dart';
import '../Gov-Action/Navigation.dart';
import '../Login/login_screen.dart';
import '../Market_Place/marketPlaceHome.dart';
import '../RecycleProvider/recycyclingHomePage.dart';
import '../TFIDF/search.dart';
import '../organization/organizationHomePage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            _buildSearchBar(context),
            SliverToBoxAdapter(
              // Wrap ImageSlider in SliverToBoxAdapter
              child: const ImageSlider(
                imageUrls: [
                  'https://raw.githubusercontent.com/jahangirjehad/JSON-FIle/refs/heads/master/WNkXCgoS.jpg',
                  'https://raw.githubusercontent.com/jahangirjehad/JSON-FIle/refs/heads/master/DALL%C2%B7E%202024-10-30%2011.18.33%20-%20A%20vibrant%20community%20recycling%20event%20organized%20by%20an%20urban%20municipality%2C%20inspired%20by%20South%20Asian%20cities.%20The%20scene%20includes%20people%20bringing%20various%20was.webp',
                  'https://raw.githubusercontent.com/jahangirjehad/JSON-FIle/refs/heads/master/images.jpg',
                ],
                height: 250.0,
                slideDuration: Duration(seconds: 4),
                animationDuration: Duration(milliseconds: 800),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildListDelegate(_buildGridItems(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeController,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.2),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _slideController,
            curve: Curves.easeOut,
          )),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1D1E),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Let's keep our environment clean",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                _buildLogoutIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutIcon() {
    return GestureDetector(
      onTap: () {
        _showLogoutConfirmationDialog();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.logout, size: 24),
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Add your logout logic here
                Navigator.of(context).pop(); // Close the dialog
                _performLogout(context); // Call the logout function
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) async {
    try {
      await _auth.signOut(); // Sign out from Firebase
      // Optionally, clear any local data here
      // Navigate to the login screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                const LoginScreen()), // Replace with your LoginPage widget
        (Route<dynamic> route) => false, // Removes all previous routes
      );
    } catch (e) {
      // Handle errors (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.2, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _slideController,
          curve: Curves.easeOut,
        )),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[400]),
                  const SizedBox(width: 12),
                  Text(
                    "Search for waste categories...",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'label': 'All', 'isSelected': true},
      {'label': 'Recycle', 'isSelected': false},
      {'label': 'Organic', 'isSelected': false},
      {'label': 'E-waste', 'isSelected': false},
    ];

    return SliverToBoxAdapter(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.2, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _slideController,
          curve: Curves.easeOut,
        )),
        child: SizedBox(
          height: 40,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category['isSelected'] as bool;

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 800 + (index * 200)),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2ECC71)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            category['label'] as String,
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Colors.grey[700],
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGridItems(BuildContext context) {
    final items = [
      GridItem(
          Icons.delete_outline,
          "Waste\nDetection",
          const Color(0xFF2ECC71),
          const Color(0xFFE8F8F0),
          WasteDetectionScreen()),
      const GridItem(Icons.recycling, "Recycle\nCenter", Color(0xFF3498DB),
          Color(0xFFEBF5FB), RecyclingHomePage()),
      const GridItem(Icons.business, "Business\nProfile", Color(0xFFE67E22),
          Color(0xFFFDF2E9), RecycleBuyerProfile()),
      const GridItem(Icons.store, "Marketplace", Color(0xFF9B59B6),
          Color(0xFFF4ECF7), MarketPlacePage()),
      const GridItem(Icons.groups, "Organization", Color(0xFF1ABC9C),
          Color(0xFFE8F6F3), OrganizationHomepage()),
      GridItem(Icons.school, "Tutorial", const Color(0xFFE74C3C),
          const Color(0xFFFDEDEC), SearchScreen()),
      const GridItem(Icons.policy, "Gov.\nAction", Color(0xFF34495E),
          Color(0xFFEBEDEF), G_Action_Navigation()),
      GridItem(Icons.search, "TF IDF\nSearch", const Color(0xFFF1C40F),
          const Color(0xFFFEF9E7), SearchScreen()),
    ];

    return List.generate(items.length, (index) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 1000 + (index * 100)),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: _buildGridItem(context, items[index]),
          );
        },
      );
    });
  }

  // Step 1: Update _buildGridItem with navigation functionality
  Widget _buildGridItem(BuildContext context, GridItem item) {
    return InkWell(
      onTap: () {
        // Step 2: Define the navigation logic here
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item.destinationPage),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: item.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item.icon,
                color: item.iconColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D1E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridItem {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color backgroundColor;
  final Widget destinationPage; // Add destination page here

  const GridItem(this.icon, this.text, this.iconColor, this.backgroundColor,
      this.destinationPage);
}
