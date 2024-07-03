import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maps_app/Model/organizationModel.dart';

class DataService {
  final String dataUrl =
      'https://raw.githubusercontent.com/jahangirjehad/JSON-FIle/master/OrganizationsDatasetsFinal';

  Future<List<Organization>> fetchOrganizations() async {
    final response = await http.get(Uri.parse(dataUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      //print('hello');
      print(jsonResponse);
      return jsonResponse.map((data) => Organization.fromJson(data)).toList();
    } else {
      //print('fail..........');
      throw Exception('Failed to load data');
    }
  }
}
