import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Recommendationpage extends StatefulWidget {
  const Recommendationpage({Key? key}) : super(key: key);

  @override
  _RecommendationpageState createState() => _RecommendationpageState();
}

class _RecommendationpageState extends State<Recommendationpage> {
  List<String> categories = [];
  Map<String, List<String>> categoryCompanies = {};
  List<String> searchSuggestions = [];
  String selectedCategory = '';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/jahangirjehad/JSON-FIle/master/recommedation'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        categories = data.keys.toList();
        categoryCompanies = data.map((key, value) =>
            MapEntry<String, List<String>>(key, List<String>.from(value)));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void updateSearchSuggestions(String query) {
    setState(() {
      searchSuggestions = categories
          .where((category) =>
              category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Companies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'What do you want to sell?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  updateSearchSuggestions(value);
                });
              },
            ),
            const SizedBox(height: 16.0),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return searchSuggestions;
              },
              onSelected: (String selection) {
                setState(() {
                  selectedCategory = selection;
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search by category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onTap: () {
                    // Show suggestions when TextField is tapped
                    textEditingController.text = ''; // Clear existing text
                    updateSearchSuggestions('');
                  },
                  onChanged: (value) {
                    // Optionally handle onChanged event if needed
                    updateSearchSuggestions(value);
                  },
                );
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: categoryCompanies[selectedCategory]?.length ?? 0,
                itemBuilder: (context, index) {
                  final company = categoryCompanies[selectedCategory]![index];
                  return ListTile(
                    title: Text(company),
                    // Add more details like ratings, distance, etc. if available
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
