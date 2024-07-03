import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:maps_app/Model/organizationMeetingModel.dart';

class MemberGraph extends StatefulWidget {
  final List<Meeting> meetings;

  MemberGraph({required this.meetings});

  @override
  _MemberGraphState createState() => _MemberGraphState();
}

class _MemberGraphState extends State<MemberGraph> {
  late Map<String, int> memberAttendance;
  late List<String> members;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    memberAttendance = _calculateMemberAttendance();
    members = memberAttendance.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredMembers = members
        .where((member) =>
            member.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return members.where((String option) {
                return option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              setState(() {
                searchQuery = selection;
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
                  hintText: 'Search member...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredMembers.length,
            itemBuilder: (context, index) {
              final member = filteredMembers[index];
              final attendance = memberAttendance[member]!;
              final totalMeetings = widget.meetings.length;
              final absent = totalMeetings - attendance;

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(member,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildChart(
                                'Present', attendance.toDouble(), Colors.green),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildChart(
                                'Absent', absent.toDouble(), Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChart(String title, double value, Color color) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [_createBarChartRodData(value, color)],
                ),
              ],
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 1,
                  ),
                ),
                bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              maxY: widget.meetings.length.toDouble(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text('$value / ${widget.meetings.length}',
            style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Map<String, int> _calculateMemberAttendance() {
    final Map<String, int> memberAttendance = {};
    for (var meeting in widget.meetings) {
      for (var member in meeting.presentedMembers) {
        memberAttendance.update(member, (value) => value + 1,
            ifAbsent: () => 1);
      }
    }
    return memberAttendance;
  }

  BarChartRodData _createBarChartRodData(double value, Color color) {
    return BarChartRodData(
      toY: value.isFinite ? value : 0,
      color: color,
      width: 30,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
    );
  }
}
