import 'package:flutter/material.dart';

import '../BusinessProfile/businessProfile.dart';
import '../Detection/wasteDetectionScreen.dart';
import '../Gov-Action/Navigation.dart';
import '../Market_Place/marketPlaceHome.dart';
import '../RecycleProvider/recycyclingHomePage.dart';
import '../organization/organizationHomePage.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildListDelegate(_buildGridItems(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF06DAA5), Color(0xFFB4F4E4)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  "WMS BD",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildProfileSection(),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.login),
          onPressed: () => _handleLogin(context),
        ),
        IconButton(
          icon: const Icon(Icons.app_registration),
          onPressed: () => _handleRegistration(context),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage:
                NetworkImage('https://example.com/profile-image.jpg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Dhaka, Bangladesh',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF06DAA5)),
            onPressed: () => _handleEditProfile(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGridItems(BuildContext context) {
    final items = [
      GridItem(Icons.search, "Waste Detection", Colors.blue, () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => WasteDetectionScreen()));
      }),
      GridItem(Icons.bar_chart, "Recycle Center", Colors.orange, () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RecyclingHomePage()));
      }),
      GridItem(Icons.group_add, "Organization", Colors.blue.shade200, () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const OrganizationHomepage()));
      }),
      GridItem(Icons.business, "Business Profile", const Color(0xFF4A235A), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RecycleBuyerProfile()));
      }),
      GridItem(Icons.sell, "Marketplace", Colors.green.shade900, () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MarketBottomNavBar()));
      }),
      GridItem(Icons.cast_for_education, "Tutorial", Colors.green,
          () => _handleTutorial(context)),
      GridItem(Icons.pending_actions, "Gov. Action", Colors.teal, () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const G_Action_Navigation()));
      }),
    ];

    return items.map((item) => _buildGridItem(context, item)).toList();
  }

  Widget _buildGridItem(BuildContext context, GridItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 40, color: item.color),
            const SizedBox(height: 8),
            Text(
              item.text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    // Implement login logic
  }

  void _handleRegistration(BuildContext context) {
    // Implement registration logic
  }

  void _handleEditProfile() {
    // Implement edit profile logic
  }

  void _handleTutorial(BuildContext context) {
    // Implement tutorial logic
  }
}

class GridItem {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const GridItem(this.icon, this.text, this.color, this.onTap);
}
