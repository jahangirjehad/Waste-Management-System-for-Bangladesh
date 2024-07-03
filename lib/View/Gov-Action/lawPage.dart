import 'package:flutter/material.dart';

class LawPage extends StatelessWidget {
  final List<Map<String, String>> laws = [
    {
      'title': 'Solid Waste Management Rules, 2021',
      'description':
          'These rules provide the framework for the management of solid waste in Bangladesh.',
      'punishment':
          'Failure to comply with these rules can result in fines up to BDT 50,000 or imprisonment up to 6 months.'
    },
    {
      'title': 'Environment Conservation Act, 1995',
      'description':
          'This act is aimed at protecting the environment and improving environmental standards.',
      'punishment':
          'Violations of this act can result in fines up to BDT 100,000 or imprisonment up to 2 years.'
    },
    {
      'title': 'E-Waste Management Rules, 2021',
      'description':
          'These rules address the management and disposal of electronic waste in Bangladesh.',
      'punishment':
          'Non-compliance can lead to fines up to BDT 50,000 or imprisonment up to 1 year.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waste Management Laws in Bangladesh'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: laws.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    laws[index]['title']!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    laws[index]['description']!,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Punishment: ${laws[index]['punishment']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
