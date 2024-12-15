import 'package:flutter/material.dart';
import 'package:maps_app/View/Home/bottm_nav_bar.dart';
import 'package:maps_app/View/Home/home_screen.dart';
import 'package:maps_app/View/Login/login_screen.dart';
import 'package:maps_app/View/SignUp/signUp_screen.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/login': (context) => const LoginScreen(),
    '/signUp': (context) => const RegisterScreen(),
    '/home': (context) => const HomeScreen(),
    '/first': (context) => const BottomNavBar(),
  };

// Removed onGenerateRoute since initial routing is handled in main.dart
}
