import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maps_app/Model/marketplaceProcuctModel,dart.dart';

class Fetchmarketplaceproduct {
  final String url =
      'https://raw.githubusercontent.com/jahangirjehad/JSON-FIle/master/marketplace_product';

  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
