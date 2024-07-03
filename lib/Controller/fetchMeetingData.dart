import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maps_app/Model/organizationMeetingModel.dart';

class DataService {
  final String dataUrl =
      'https://raw.githubusercontent.com/jahangirjehad/JSON-FIle/master/OrganizationMeeting';

  Future<List<Meeting>> fetchMeetings() async {
    final response = await http.get(Uri.parse(dataUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['meetings'];
      return data.map((json) => Meeting.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
