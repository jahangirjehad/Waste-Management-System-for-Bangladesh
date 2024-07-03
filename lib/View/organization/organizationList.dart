import 'package:flutter/material.dart';
import 'package:maps_app/Controller/fetchOrganizationData.dart';
import 'package:maps_app/Model/organizationModel.dart';
import 'package:maps_app/View/organization/Org_Profile/orgProfile.dart';

class MyColors {
  static const Color primaryColor = Color(0xFF3498db);
  static const Color accentColor = Color(0xFF2ecc71);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF2c3e50);
  static const Color subtitleColor = Color(0xFF7f8c8d);
  static const Color iconColor = Color(0xFF34495e);
}

class OrganizationsPage extends StatefulWidget {
  const OrganizationsPage({Key? key}) : super(key: key);

  @override
  _OrganizationsPageState createState() => _OrganizationsPageState();
}

class _OrganizationsPageState extends State<OrganizationsPage> {
  late Future<List<Organization>> futureOrganizations;
  final DataService dataService = DataService();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureOrganizations = DataService().fetchOrganizations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        title: Text('Organizations', style: TextStyle(color: Colors.white)),
        backgroundColor: MyColors.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          _buildSearchBar(),
          Expanded(
            child: _buildOrganizationList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search organizations...',
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: Colors.white),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildOrganizationList() {
    return FutureBuilder<List<Organization>>(
      future: futureOrganizations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No organizations found'));
        } else {
          List<Organization> filteredOrganizations = snapshot.data!
              .where((org) =>
                  org.name.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredOrganizations.length,
            itemBuilder: (context, index) {
              Organization organization = filteredOrganizations[index];
              return _buildOrganizationCard(organization, index);
            },
          );
        }
      },
    );
  }

  Widget _buildOrganizationCard(Organization organization, int index) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Orgprofile(
                organizations: organization,
                id: index,
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(organization),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organization.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MyColors.textColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      organization.title,
                      style: TextStyle(
                        color: MyColors.subtitleColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildInfoRow(
                        Icons.people, '${organization.member} members'),
                    SizedBox(height: 4),
                    _buildInfoRow(
                        Icons.post_add, '${organization.totalPost} posts'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(Organization organization) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage('https://via.placeholder.com/150'),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: MyColors.iconColor),
        SizedBox(width: 4),
        Text(text, style: TextStyle(color: MyColors.subtitleColor)),
      ],
    );
  }
}
