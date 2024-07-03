import 'package:flutter/material.dart';
import 'package:maps_app/View/Home/home_screen.dart';
import 'package:maps_app/View/Login/login_screen.dart';
import 'package:maps_app/View/SignUp/signUp_screen.dart';

class AppRoutes {
  static const String initialRoute = '/login';

  static Map<String, Widget Function(BuildContext)> routes = {
    '/login': (context) => const LoginScreen(),
    '/signUp': (context) => const RegisterScreen(),
    '/home': (context) => const HomeScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    );
  }
}
