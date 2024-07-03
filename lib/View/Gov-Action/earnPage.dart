import 'package:flutter/material.dart';
import 'package:maps_app/utils/my_colors.dart';

class EarnPage extends StatelessWidget {
  final List<Map<String, String>> initiatives = [
    {
      'title': 'অপরিষ্কার কমোড এবং টায়ার পরিষ্কার করা',
      'reward': 'প্রতিটি ৫০ টাকা',
      'details':
          'কাউন্সিলরের অফিস বা জোনাল অফিসে জমা দিয়ে প্রতিটি অপরিষ্কার কমোড এবং টায়ার পরিষ্কার করার জন্য ৫০ টাকা উপার্জন করুন।',
    },
    {
      'title': 'নারকেল খোসা, চিপস প্যাকেট এবং ফাঁকা বাটি পরিষ্কার করা',
      'reward': 'প্রতিটি ৫ টাকা',
      'details':
          'কাউন্সিলরের অফিস বা জোনাল অফিসে জমা দিয়ে প্রতিটি নারকেল খোসা, চিপস প্যাকেট এবং ফাঁকা বাটি পরিষ্কার করার জন্য ৫ টাকা উপার্জন করুন।',
    },
    {
      'title': 'বর্জ্য ব্যবস্থাপনা উদ্যোগে অংশগ্রহণ',
      'reward': 'পরিবর্তনশীল',
      'details':
          'বিভিন্ন বর্জ্য ব্যবস্থাপনা উদ্যোগে অংশগ্রহণ করুন এবং সংগৃহীত বর্জ্যের ধরণ ও পরিমাণ অনুযায়ী পুরষ্কার অর্জন করুন।',
    },
    {
      'title': 'প্লাস্টিক বোতল এবং ব্যাগ পরিষ্কার করা',
      'reward': 'প্রতিটি ২ টাকা',
      'details':
          'কাউন্সিলরের অফিস বা জোনাল অফিসে জমা দিয়ে প্রতিটি প্লাস্টিক বোতল এবং ব্যাগ পরিষ্কার করার জন্য ২ টাকা উপার্জন করুন।',
    },
    {
      'title': 'পুরাতন কাগজ, বই এবং ম্যাগাজিন সংগ্রহ',
      'reward': 'প্রতি কেজি ১০ টাকা',
      'details':
          'কাউন্সিলরের অফিস বা জোনাল অফিসে জমা দিয়ে পুরাতন কাগজ, বই এবং ম্যাগাজিন সংগ্রহ করে প্রতি কেজির জন্য ১০ টাকা উপার্জন করুন।',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.caribbeanGreenTint6,
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: initiatives.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ExpansionTile(
              title: Text(
                initiatives[index]['title']!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'পুরষ্কার: ${initiatives[index]['reward']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    initiatives[index]['details']!,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
