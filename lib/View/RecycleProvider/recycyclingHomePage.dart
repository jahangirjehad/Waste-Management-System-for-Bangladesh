import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:maps_app/Model/recyclingCompany.dart';
import 'package:maps_app/View/Home/mapScreen.dart';
import 'package:maps_app/View/RecycleProvider/recommendationPage.dart';
import 'package:maps_app/View/RecycleProvider/recycleCompanyProfilePage.dart';

class RecyclingHomePage extends StatefulWidget {
  const RecyclingHomePage({super.key});

  @override
  _RecyclingHomePageState createState() => _RecyclingHomePageState();
}

class _RecyclingHomePageState extends State<RecyclingHomePage> {
  List<RecyclingCompany> companies = [];
  List<RecyclingCompany> filteredCompanies = [];
  List<String> searchSuggestions = [];
  String searchQuery = '';
  String? selectedCategory;
  double maxDistance = 100.0;
  Position? currentPosition;
  final List<String> categories = [
    'paper',
    'metal',
    'plastic',
    'glass',
    'electronics',
    'textiles'
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
    getCurrentLocation();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/jahangirjehad/JSON-FIle/master/recyclingCompany'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        companies =
            data.map((item) => RecyclingCompany.fromJson(item)).toList();
        filteredCompanies = companies;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getCurrentLocation() async {
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      filterCompanies();
    });
  }

  double getDistance(RecyclingCompany company) {
    if (currentPosition == null) return double.infinity;
    return Geolocator.distanceBetween(currentPosition!.latitude,
            currentPosition!.longitude, company.lat, company.long) /
        1000; // Convert to km
  }

  void filterCompanies() {
    setState(() {
      filteredCompanies = companies.where((company) {
        bool matchesQuery =
            company.name.toLowerCase().contains(searchQuery.toLowerCase());
        bool matchesCategory = selectedCategory == null ||
            company.sellingCategory.containsKey(selectedCategory);
        double distance = getDistance(company);
        bool matchesDistance = distance <= maxDistance;
        return matchesQuery && matchesCategory && matchesDistance;
      }).toList();

      if (currentPosition != null) {
        filteredCompanies
            .sort((a, b) => getDistance(a).compareTo(getDistance(b)));
      }
    });
  }

  void updateSearchSuggestions(String query) {
    searchSuggestions = companies
        .where((company) =>
            company.name.toLowerCase().contains(query.toLowerCase()))
        .map((company) => company.name)
        .toList();
    searchSuggestions =
        searchSuggestions.take(5).toList(); // Limit to 5 suggestions
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Partners'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: fetchData),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              SizedBox(height: 16),
              _buildCategoryChips(),
              SizedBox(height: 16),
              _buildDistanceSlider(),
              SizedBox(height: 16),
              _buildActionButtons(),
              SizedBox(height: 16),
              Expanded(
                child: _buildCompanyList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search recycling partners',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
          filterCompanies();
        });
      },
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = selected ? category : null;
                  filterCompanies();
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDistanceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Max Distance: ${maxDistance.round()} km'),
        Slider(
          value: maxDistance,
          min: 0,
          max: 1000,
          divisions: 20,
          label: '${maxDistance.round()} km',
          onChanged: (value) {
            setState(() {
              maxDistance = value;
              filterCompanies();
            });
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.map),
          label: Text('Map View'),
          onPressed: () {
            if (currentPosition != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    companies:
                        companies, // Use 'companies' instead of 'filteredCompanies' to show all
                    currentPosition: currentPosition!,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Waiting for current location...')),
              );
            }
          },
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.recommend),
          label: Text('Recommendations'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Recommendationpage()));
          },
        ),
      ],
    );
  }

  Widget _buildCompanyList() {
    if (filteredCompanies.isEmpty) {
      return Center(
          child: Text('No companies found. Try adjusting your filters.'));
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filteredCompanies.length,
      itemBuilder: (context, index) {
        final company = filteredCompanies[index];
        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RecycleCompanyProfilePage(company: company)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    company.image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[300],
                        child: Icon(Icons.error, color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          company.address,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Row(
                          children: [
                            ...List.generate(
                              company.rating.round(),
                              (index) => Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                            ),
                            SizedBox(width: 4),
                            Text(
                              company.rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
