// meeting_data.dart
import 'dart:convert';

class Meeting {
  final String title;
  final DateTime date;
  final int totalPresent;
  final int totalAbsent;
  final int totalMembers;
  final List<String> presentedMembers;
  final List<String> absentMembers;
  final int durationMinutes;
  final String location;
  final List<String> keyDecisions;

  Meeting({
    required this.title,
    required this.date,
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalMembers,
    required this.presentedMembers,
    required this.absentMembers,
    required this.durationMinutes,
    required this.location,
    required this.keyDecisions,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      title: json['meeting_title'],
      date: DateTime.parse(json['date']),
      totalPresent: json['total_present'],
      totalAbsent: json['total_absent'],
      totalMembers: json['total_members'],
      presentedMembers: List<String>.from(json['presented_members']),
      absentMembers: List<String>.from(json['absent_members']),
      durationMinutes: json['duration_minutes'],
      location: json['location'],
      keyDecisions: List<String>.from(json['key_decisions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meeting_title': title,
      'date': date.toIso8601String(),
      'total_present': totalPresent,
      'total_absent': totalAbsent,
      'total_members': totalMembers,
      'presented_members': presentedMembers,
      'absent_members': absentMembers,
      'duration_minutes': durationMinutes,
      'location': location,
      'key_decisions': keyDecisions,
    };
  }
}
