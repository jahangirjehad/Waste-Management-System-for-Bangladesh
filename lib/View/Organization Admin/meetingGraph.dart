import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_app/Model/organizationMeetingModel.dart';

class MeetingGraph extends StatefulWidget {
  final List<Meeting> meetings;

  MeetingGraph({required this.meetings});

  @override
  _MeetingGraphState createState() => _MeetingGraphState();
}

class _MeetingGraphState extends State<MeetingGraph> {
  String? selectedMonth;
  List<String> monthOptions = [];

  @override
  void initState() {
    super.initState();
    _generateMonthOptions();
  }

  void _generateMonthOptions() {
    Set<String> uniqueMonths = {};
    for (var meeting in widget.meetings) {
      String monthYear = DateFormat('MMMM yyyy').format(meeting.date);
      uniqueMonths.add(monthYear);
    }
    monthOptions = uniqueMonths.toList()..sort();
    selectedMonth = monthOptions.isNotEmpty ? monthOptions.last : null;
  }

  List<Meeting> _getFilteredMeetings() {
    if (selectedMonth == null) return [];
    return widget.meetings.where((meeting) {
      String monthYear = DateFormat('MMMM yyyy').format(meeting.date);
      return monthYear == selectedMonth;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Meeting> filteredMeetings = _getFilteredMeetings();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton<String>(
            value: selectedMonth,
            hint: const Text('Select Month'),
            isExpanded: true,
            items: monthOptions.map((String month) {
              return DropdownMenuItem<String>(
                value: month,
                child: Text(month),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedMonth = newValue;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredMeetings.length,
            itemBuilder: (context, index) {
              final meeting = filteredMeetings[index];
              double present = meeting.totalPresent.toDouble();
              double absent = meeting.totalAbsent.toDouble();

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        meeting.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat('dd MMMM yyyy').format(meeting.date),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: present.isFinite ? present : 0,
                                    color: Colors.green,
                                    width: 40,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4)),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: absent.isFinite ? absent : 0,
                                    color: Colors.red,
                                    width: 40,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4)),
                                  ),
                                ],
                              ),
                            ],
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  interval: 5,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return const Text('Present');
                                      case 1:
                                        return const Text('Absent');
                                      default:
                                        return const Text('');
                                    }
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: false),
                          ),
                        ),
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
}
