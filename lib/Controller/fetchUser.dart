// lib/api_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maps_app/Model/userModel.dart';

class ApiService {
  final String url =
      'https://raw.githubusercontent.com/jahangirjehad/JSON-FIle/master/randomCompany';

  Future<List<RecyclingCompany>> fetchUsers() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      //print('helooooooo I am OK');
      return jsonData.map((json) => RecyclingCompany.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
