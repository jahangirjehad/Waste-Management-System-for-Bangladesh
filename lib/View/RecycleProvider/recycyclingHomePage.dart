import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:maps_app/Model/recyclingCompany.dart';
import 'package:maps_app/View/RecycleProvider/recycleCompanyProfilePage.dart';
import 'package:shimmer/shimmer.dart';

import '../Home/mapScreen.dart';

class RecyclingHomePage extends StatefulWidget {
  const RecyclingHomePage({super.key});

  @override
  _RecyclingHomePageState createState() => _RecyclingHomePageState();
}

class _RecyclingHomePageState extends State<RecyclingHomePage>
    with SingleTickerProviderStateMixin {
  List<RecyclingCompany> companies = [];
  List<RecyclingCompany> filteredCompanies = [];
  List<String> searchSuggestions = [];
  String searchQuery = '';
  String? selectedCategory;
  double maxDistance = 100.0;
  Position? currentPosition;
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
    fetchData();
    getCurrentLocation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/jahangirjehad/JSON-FIle/master/recyclingCompany'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          companies =
              data.map((item) => RecyclingCompany.fromJson(item)).toList();
          filteredCompanies = companies;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackBar('Failed to load data. Please try again.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: fetchData,
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 200,
              floating: true,
              pinned: true,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Recycling Partners',
                  style: TextStyle(
                    color: innerBoxIsScrolled ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          body: RefreshIndicator(
            onRefresh: fetchData,
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) => Opacity(
                opacity: _fadeAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
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
                        child: isLoading
                            ? _buildLoadingGrid()
                            : _buildCompanyGrid(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Hero(
      tag: 'searchBar',
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search recycling partners',
            prefixIcon:
                Icon(Icons.search, color: Theme.of(context).primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
              filterCompanies();
            });
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return AnimationLimiter(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(category.toUpperCase()),
                  selected: selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = selected ? category : null;
                      filterCompanies();
                    });
                  },
                  selectedColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                  checkmarkColor: Theme.of(context).primaryColor,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }

  Widget _buildCompanyGrid() {
    if (filteredCompanies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No companies found.\nTry adjusting your filters.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return AnimationLimiter(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: filteredCompanies.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: _buildCompanyCard(filteredCompanies[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompanyCard(RecyclingCompany company) {
    return OpenContainer(
      transitionDuration: Duration(milliseconds: 500),
      openBuilder: (context, _) => RecycleCompanyProfilePage(company: company),
      closedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      closedBuilder: (context, openContainer) => Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'company_image_${company.image}',
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  company.image,
                  height: 100,
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
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      company.address,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        ...List.generate(
                          company.rating.round(),
                          (index) =>
                              Icon(Icons.star, color: Colors.amber, size: 16),
                        ),
                        SizedBox(width: 4),
                        Text(
                          company.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall,
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
          onPressed: () {},
        ),
      ],
    );
  }
}
