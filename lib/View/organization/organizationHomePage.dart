import 'package:flutter/material.dart';
import 'package:maps_app/View/organization/organizationList.dart';

class MyColors {
  static const Color primaryColor = Color(0xFF3498db);
  static const Color accentColor = Color(0xFF2ecc71);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF2c3e50);
  static const Color secondaryTextColor = Color(0xFF7f8c8d);
}

class OrganizationHomepage extends StatelessWidget {
  const OrganizationHomepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Organizations',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('My Organizations'),
            _buildOrganizationList(myOrganizations),
            _buildHeader('Suggested Organizations'),
            _buildOrganizationList(suggestedOrganizations),
            _buildSeeMoreButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: MyColors.textColor,
        ),
      ),
    );
  }

  Widget _buildOrganizationList(List<Map<String, dynamic>> organizations) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: organizations.length,
        itemBuilder: (context, index) {
          return _buildOrganizationCard(context, organizations[index]);
        },
      ),
    );
  }

  Widget _buildOrganizationCard(
      BuildContext context, Map<String, dynamic> organization) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizationDetails(organization),
          ),
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 180,
        margin: const EdgeInsets.only(left: 16, bottom: 16),
        decoration: BoxDecoration(
          color: MyColors.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: organization['name'],
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  organization['image'],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    organization['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MyColors.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${organization['members']} members',
                    style: TextStyle(
                      fontSize: 14,
                      color: MyColors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeeMoreButton(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OrganizationsPage()),
            );
          },
          child: const Text('See More Organizations'),
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.accentColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  // Sample data
  static final List<Map<String, dynamic>> myOrganizations = [
    {
      'name': 'ক্লিন ক্যাম্পাস',
      'members': 120,
      'image': 'https://via.placeholder.com/100?text=Clean+Campus'
    },
    {
      'name': 'সবুজ ছায়া',
      'members': 75,
      'image': 'https://via.placeholder.com/100?text=Green+Shade'
    },
    {
      'name': 'গ্রীন কেমেস্ট্রি',
      'members': 110,
      'image': 'https://via.placeholder.com/100?text=Green+Chemistry'
    },
    {
      'name': 'চট্টগ্রাম বিশ্ববিদ্যালয় পরিবার',
      'members': 85,
      'image': 'https://via.placeholder.com/100?text=CU+Family'
    },
    {
      'name': 'রিসাইকেল্ক কমিউনিটি',
      'members': 95,
      'image': 'https://via.placeholder.com/100?text=Recycle+Community'
    },
  ];

  static final List<Map<String, dynamic>> suggestedOrganizations = [
    {
      'name': 'EcoWarriors',
      'members': 120,
      'image': 'https://via.placeholder.com/100?text=EcoWarriors'
    },
    {
      'name': 'CleanTech Solutions',
      'members': 75,
      'image': 'https://via.placeholder.com/100?text=CleanTech'
    },
    {
      'name': 'Future Green',
      'members': 110,
      'image': 'https://via.placeholder.com/100?text=FutureGreen'
    },
    {
      'name': 'GreenTech Innovators',
      'members': 85,
      'image': 'https://via.placeholder.com/100?text=GreenTech'
    },
    {
      'name': 'Renewable Pioneers',
      'members': 95,
      'image': 'https://via.placeholder.com/100?text=Renewable'
    },
  ];
}

class OrganizationDetails extends StatelessWidget {
  final Map<String, dynamic> organization;

  const OrganizationDetails(this.organization, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          organization['name'],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Column(
        children: [
          Hero(
            tag: organization['name'],
            child: Image.network(
              organization['image'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  organization['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${organization['members']} members',
                  style: TextStyle(color: MyColors.secondaryTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
