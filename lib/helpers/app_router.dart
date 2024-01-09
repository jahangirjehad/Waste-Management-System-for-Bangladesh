import 'package:flutter/material.dart';

import 'package:maps_app/google_map/screens/google_map_page.dart';
import 'package:maps_app/google_map/screens/google_map_page_fm.dart';
import 'package:maps_app/menu/screen/main_menu.dart';

class AppRoutes {
  static const String initialRoute = '/main_menu';

  static Map<String, Widget Function(BuildContext)> routes = {
    '/main_menu':               (context) => const MainMenu(),
    '/google_maps_with_fm':     (context) => const GoogleMapPageFm(),
    '/google_maps_without_fm':  (context) => const GoogleMapPage(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const MainMenu(),
    );
  }
}