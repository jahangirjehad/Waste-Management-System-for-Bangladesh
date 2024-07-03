import 'package:flutter/material.dart';
import 'package:maps_app/View/Gov-Action/activitiesPage.dart';
import 'package:maps_app/View/Gov-Action/earnPage.dart';
import 'package:maps_app/View/Gov-Action/lawPage.dart';

class G_Action_Navigation extends StatefulWidget {
  const G_Action_Navigation({Key? key}) : super(key: key);

  @override
  State<G_Action_Navigation> createState() => _G_Action_NavigationState();
}

class _G_Action_NavigationState extends State<G_Action_Navigation>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(icon: Icon(Icons.gavel), text: 'Law'),
                Tab(icon: Icon(Icons.attach_money), text: 'Earn'),
                Tab(icon: Icon(Icons.directions_run), text: 'Activities'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LawPage(),
          EarnPage(),
          ActivitiesPage(),
        ],
      ),
    );
  }
}
