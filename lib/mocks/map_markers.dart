import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkers {
  const MapMarkers({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.gradientColor,
    required this.textColorTitle,
    required this.textColorAddress
  });

  final String image;
  final String title;
  final String address;
  final LatLng location;
  final List<Color> gradientColor;
  final Color textColorTitle;
  final Color textColorAddress;
}


const _locations = [
  LatLng(7.914566946258304, -72.48708298466292),
  LatLng(7.913538817721219, -72.48736193440523),
  LatLng(7.913294404360775, -72.48679062386822),
  LatLng(7.913408641056527, -72.48769721052015),
  LatLng(7.913047334184446, -72.48745312949261),
];

const _path = 'assets/logos_details/';

final mapMarkers = [
  MapMarkers(
    image: '${_path}1-logo.png',
    title: 'Google Office',
    address: 'Calle 10 # 7-11',
    location: _locations[0],
    gradientColor: [
      const Color.fromARGB(255, 173, 94, 183),
      const Color.fromARGB(255, 75, 53, 120),
    ],
    textColorTitle: Colors.white,
    textColorAddress: Colors.white
  ),
  MapMarkers(
    image: '${_path}2-logo.png',
    title: 'Chanel Office',
    address: 'Calle 10 # 7-12',
    location: _locations[1],
    gradientColor: [
      const Color.fromARGB(255, 8, 7, 11),
      const Color.fromARGB(255, 35, 14, 30),
      const Color.fromARGB(255, 10, 47, 68),
    ],
    textColorTitle: Colors.white,
    textColorAddress: Colors.white
  ),
  MapMarkers(
    image: '${_path}3-logo.jpeg',
    title: 'Logistics Office',
    address: 'Calle 10 # 7-13',
    location: _locations[2],
    gradientColor: [
      const Color.fromARGB(255, 228, 228, 228),
      const Color.fromARGB(255, 236, 236, 236),
    ],
    textColorTitle: Colors.black,
    textColorAddress: Colors.grey[800]!
  ),
  MapMarkers(
    image: '${_path}4-logo.png',
    title: 'M Office',
    address: 'Calle 10 # 7-14',
    location: _locations[3],
    gradientColor: [
      const Color.fromARGB(255, 87, 180, 189),
      const Color.fromARGB(255, 90, 182, 192),
    ],
    textColorTitle: Colors.white,
    textColorAddress: Colors.white
  ),
  MapMarkers(
    image: '${_path}5-logo.jpeg',
    title: 'Agrosegovia Office',
    address: 'Calle 10 # 7-15',
    location: _locations[4],
    gradientColor: [
      const Color.fromARGB(255, 255, 200, 2),
      const Color.fromARGB(255, 255, 200, 2),
    ],
    textColorTitle: Colors.black,
    textColorAddress: Colors.grey[800]!
  ),
];