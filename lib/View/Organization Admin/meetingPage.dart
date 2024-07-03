import 'package:flutter/material.dart';
import 'package:maps_app/Model/organizationMeetingModel.dart';
import 'package:maps_app/View/Organization%20Admin/meetingGraph.dart';
import 'package:maps_app/View/Organization%20Admin/memberGraph.dart';

import '../../Controller/fetchMeetingData.dart';

class MeetingPage extends StatefulWidget {
  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final DataService dataService = DataService();
  Future<List<Meeting>>? futureMeetings;

  @override
  void initState() {
    super.initState();
    futureMeetings = dataService.fetchMeetings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BD CLEAN Meeting Attendance'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MemberPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Meeting>>(
        future: futureMeetings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return MeetingGraph(meetings: snapshot.data!);
          }
        },
      ),
    );
  }
}

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Individual Member Attendance'),
      ),
      body: FutureBuilder<List<Meeting>>(
        future: DataService().fetchMeetings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return MemberGraph(meetings: snapshot.data!);
          }
        },
      ),
    );
  }
}
