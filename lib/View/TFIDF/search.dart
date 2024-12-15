import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: Text('Product Search'),
        //backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                //color: Theme.of(context).primaryColor,
                /* boxShadow: [
                BoxShadow(
                  //color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ], */
                ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter product keywords',
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.white70),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults.clear();
                    });
                  },
                ),
                filled: true,
                //fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.grey),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _searchResults.isNotEmpty
                    ? ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final product = _searchResults[index];
                          return _buildProductCard(product);
                        },
                      )
                    : Center(
                        child: Text(
                          'No results found. Try a different search term.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['name'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Buyer: ${product['buyerEmail']}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            _highlightQueryText(product['description'], _searchController.text),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Match: ${product['similarity'].toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement contact action
                  },
                  child: Text('Contact Buyer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).canvasColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final searchQueryTfIdf = _computeTfIdf(query.split(' '));
    final searchResults = await _fetchAndMatchProducts(searchQueryTfIdf);

    setState(() {
      _searchResults = searchResults;
      _isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> _fetchAndMatchProducts(
      Map<String, double> searchQueryTfIdf) async {
    final productsSnapshot =
        await FirebaseFirestore.instance.collection('products').get();
    List<Map<String, dynamic>> matchedProducts = [];

    for (var doc in productsSnapshot.docs) {
      final productData = doc.data();
      final tfidfFeatures = productData['features'] as Map<String, dynamic>;

      if (tfidfFeatures == null) {
        print('TF-IDF features missing for product: ${productData['name']}');
        continue;
      }

      final similarity =
          _calculateCosineSimilarity(searchQueryTfIdf, tfidfFeatures);

      if (similarity > 0) {
        matchedProducts.add({
          'name': productData['name'],
          'buyerEmail': productData['buyer email'],
          'description': productData['description'],
          'similarity': similarity * 100,
        });
      }
    }

    matchedProducts.sort((a, b) => b['similarity'].compareTo(a['similarity']));
    return matchedProducts;
  }

  double _calculateCosineSimilarity(
      Map<String, double> queryTfIdf, Map<String, dynamic> productTfIdf) {
    double dotProduct = 0.0;
    double queryMagnitude = 0.0;
    double productMagnitude = 0.0;

    queryTfIdf.forEach((term, weight) {
      dotProduct += weight * (productTfIdf[term] ?? 0.0);
      queryMagnitude += weight * weight;
    });

    productTfIdf.forEach((term, weight) {
      productMagnitude += weight * weight;
    });

    queryMagnitude = sqrt(queryMagnitude);
    productMagnitude = sqrt(productMagnitude);

    if (queryMagnitude == 0 || productMagnitude == 0) {
      return 0.0;
    }

    return dotProduct / (queryMagnitude * productMagnitude);
  }

  Map<String, double> _computeTfIdf(List<String> queryTerms) {
    Map<String, double> tfidf = {};
    int totalTerms = queryTerms.length;

    for (var term in queryTerms) {
      tfidf[term] = (tfidf[term] ?? 0.0) + 1.0;
    }

    tfidf.forEach((term, count) {
      tfidf[term] = count / totalTerms;
    });

    return tfidf;
  }

  Widget _highlightQueryText(String text, String query) {
    List<TextSpan> spans = [];
    String lowerText = text.toLowerCase();
    String lowerQuery = query.toLowerCase();

    int start = 0;
    int indexOfHighlight;
    while ((indexOfHighlight = lowerText.indexOf(lowerQuery, start)) != -1) {
      if (indexOfHighlight > start) {
        spans.add(TextSpan(
          text: text.substring(start, indexOfHighlight),
          style: TextStyle(color: Colors.black87),
        ));
      }

      spans.add(TextSpan(
        text: text.substring(indexOfHighlight, indexOfHighlight + query.length),
        style: TextStyle(
          color: Colors.amber,
          fontWeight: FontWeight.bold,
        ),
      ));

      start = indexOfHighlight + query.length;
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(color: Colors.black87),
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
