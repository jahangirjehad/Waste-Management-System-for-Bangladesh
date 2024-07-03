import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkers {
  const MapMarkers(
      {required this.image,
      required this.title,
      required this.address,
      required this.location,
      required this.gradientColor,
      required this.textColorTitle,
      required this.textColorAddress});

  final String image;
  final String title;
  final String address;
  final LatLng location;
  final List<Color> gradientColor;
  final Color textColorTitle;
  final Color textColorAddress;
}

const _locations = [
  LatLng(22.4481407, 91.8224547),
  LatLng(22.4213714, 91.82010129999999),
  LatLng(22.4090162, 91.8178341),
  LatLng(22.4875834, 91.8098954),
  LatLng(21.4637269, 91.9915908),
];

const _path = 'assets/logos_details/';

final mapMarkers = [
  MapMarkers(
      image: '${_path}1-logo.png',
      title: 'SHOPNO Recycle Material Sell',
      address: 'Chikandandi, Chittagong',
      location: _locations[0],
      gradientColor: [
        const Color.fromARGB(255, 173, 94, 183),
        const Color.fromARGB(255, 75, 53, 120),
      ],
      textColorTitle: Colors.white,
      textColorAddress: Colors.white),
  MapMarkers(
      image: '${_path}2-logo.png',
      title: 'Aman Bazar Recycle Seeling Point',
      address: 'Aman Bazaar, N106, Chittagong',
      location: _locations[1],
      gradientColor: [
        const Color.fromARGB(255, 8, 7, 11),
        const Color.fromARGB(255, 35, 14, 30),
        const Color.fromARGB(255, 10, 47, 68),
      ],
      textColorTitle: Colors.white,
      textColorAddress: Colors.white),
  MapMarkers(
      image: '${_path}3-logo.jpeg',
      title: 'GREEN Recycle',
      address: 'Baluchara, Chittagong',
      location: _locations[2],
      gradientColor: [
        const Color.fromARGB(255, 228, 228, 228),
        const Color.fromARGB(255, 236, 236, 236),
      ],
      textColorTitle: Colors.black,
      textColorAddress: Colors.grey[800]!),
  MapMarkers(
      image: '${_path}4-logo.png',
      title: 'BD Recycle Bye and Sell',
      address: '1 No Gate, Chittagong University',
      location: _locations[3],
      gradientColor: [
        const Color.fromARGB(255, 87, 180, 189),
        const Color.fromARGB(255, 90, 182, 192),
      ],
      textColorTitle: Colors.white,
      textColorAddress: Colors.white),
  MapMarkers(
      image: '${_path}5-logo.jpeg',
      title: 'মিনা মেটারিয়াল সেলিং পয়েন্ট',
      address: 'Jobra, Chittagong University',
      location: _locations[4],
      gradientColor: [
        const Color.fromARGB(255, 255, 200, 2),
        const Color.fromARGB(255, 255, 200, 2),
      ],
      textColorTitle: Colors.black,
      textColorAddress: Colors.grey[800]!),
];
