import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' show MapCamera, PointExtension;
import 'package:google_maps_flutter/google_maps_flutter.dart';
export 'package:google_maps_flutter/google_maps_flutter.dart' show MapType;

const double kGoogleMapMaxZoom = 21.0;
const double kGoogleMapMinZoom = 3.0;

class GoogleMapTileLayer extends StatefulWidget {
  final MapType mapType;
  final EdgeInsets padding;
  final bool trafficEnabled;
  final bool buildingsEnabled;
  final bool compassEnabled;
  final bool myLocationEnabled;
  final bool indoorViewEnabled;
  final TextDirection? layoutDirection;
  final Function(GoogleMapController)? mapReady;
  const GoogleMapTileLayer({
    super.key,
    required this.mapType,
    this.padding = EdgeInsets.zero,
    this.trafficEnabled = false,
    this.buildingsEnabled = false,
    this.compassEnabled = false,
    this.myLocationEnabled = false,
    this.indoorViewEnabled = false,
    this.layoutDirection,
    this.mapReady,
  });

  @override
  State<GoogleMapTileLayer> createState() => _GoogleMapTileLayerState();
}

class _GoogleMapTileLayerState extends State<GoogleMapTileLayer> {
  GoogleMapController? _controller;

  // update google map to match the latlng of flutter_map
  void mapEvent(MapCamera mapCamera) {
    final ctrl = _controller;
    if (ctrl != null) {
      final center = convertLatLng(mapCamera);
      final zoom = mapCamera.zoom;
      var rotation = mapCamera.rotation;
      final newLatLngZoom = CameraUpdate.newCameraPosition(CameraPosition(target: center, zoom: zoom, bearing: -rotation));
      ctrl.moveCamera(newLatLngZoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapCamera = MapCamera.of(context);
    mapEvent(mapCamera);
    return Stack(
      alignment: Alignment.center,
      children: [
        IgnorePointer(
          child: GoogleMap(
            myLocationButtonEnabled: false,
            buildingsEnabled: widget.buildingsEnabled,
            compassEnabled: widget.compassEnabled,
            mapToolbarEnabled: false,
            myLocationEnabled: widget.myLocationEnabled,
            indoorViewEnabled: widget.indoorViewEnabled,
            layoutDirection: widget.layoutDirection,
            mapType: widget.mapType,
            padding: widget.padding,
            rotateGesturesEnabled: false,
            scrollGesturesEnabled: false,
            tiltGesturesEnabled: false,
            trafficEnabled: widget.trafficEnabled,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: false,
            initialCameraPosition: CameraPosition(target: convertLatLng(mapCamera), zoom: mapCamera.zoom),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              if (widget.mapReady != null) {
                widget.mapReady!(controller);
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                mapEvent(mapCamera);
                setState(() {});
              });
            },
          ),
        ),
        Container(color: Colors.transparent), // This is important for touch input to work with flutter_map
      ],
    );
  }

  // steps is used to make map move one pixel at a time by rounding to int, that is to be as close to how flutter_map render its widgets
  LatLng convertLatLng(MapCamera mapCamera) {
    // latlng
    final center = mapCamera.center;
    final zoom = mapCamera.zoom;

    // adjust map center for padding
    final padding = widget.padding;
    final top = padding.top;
    final right = padding.right;
    final bottom = padding.bottom;
    final left = padding.left;

    final mapCenterPoint = mapCamera.project(center, zoom);
    final adjustedCenterPoint = Point(mapCenterPoint.x + left / 2 - right / 2, mapCenterPoint.y + top / 2 - bottom / 2);
    final rotatePoint = mapCamera.rotatePoint(mapCenterPoint, adjustedCenterPoint);

    final rounded = rotatePoint.round(); // optional
    final fixedLatLng = mapCamera.unproject(rounded, zoom);
    return LatLng(fixedLatLng.latitude, fixedLatLng.longitude);
  }
}