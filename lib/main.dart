import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maps_app/Controller/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAlDCAbTVg3wnPj-Gwpx4LHbX33hz63wHY",
      appId: "1:783852131840:android:b2a678b79d09b11ce46ae5",
      messagingSenderId: "783852131840",
      projectId: "waste-management-59417",
      storageBucket: "waste-management-59417.appspot.com",
    ),
  );

  // Check if user info is stored
  final prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');
  String? password = prefs.getString('password');

  runApp(MyApp(
      initialRoute: (email != null && password != null) ? '/first' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maps App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
