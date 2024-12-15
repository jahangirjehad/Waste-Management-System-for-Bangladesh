import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/Model/recyclingCompany.dart';

class MapScreen extends StatefulWidget {
  final List<RecyclingCompany> companies;
  final Position currentPosition;

  const MapScreen(
      {Key? key, required this.companies, required this.currentPosition})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  RecyclingCompany? selectedCompany;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  Map<String, BitmapDescriptor> customMarkers = {};

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadCustomMarkers();
  }

  void _setupAnimations() {
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticOut,
      ),
    );

    _bounceController.repeat(reverse: true);
  }

  Future<void> _loadCustomMarkers() async {
    // Create custom marker for current location
    final currentLocationMarker = await _createCustomMarker(
        Icons.my_location, Colors.blue, 'Your Location');

    // Create custom markers for each company
    for (var company in widget.companies) {
      final customMarker = await _createCustomMarkerFromImage(
        company.image,
        company.name,
      );
      if (customMarker != null) {
        customMarkers[company.name] = customMarker;
      }
    }

    _createMarkers(currentLocationMarker);
  }

  Future<BitmapDescriptor> _createCustomMarker(
    IconData icon,
    Color color,
    String label,
  ) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final size = const Size(240, 240); // Further increased size
    final paint = Paint()..color = color;

    // Draw background circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      80, // Increased radius for larger marker
      paint,
    );

    // Draw icon
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 100, // Increased font size for visibility
        fontFamily: icon.fontFamily,
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Future<BitmapDescriptor?> _createCustomMarkerFromImage(
    String imageUrl,
    String label,
  ) async {
    try {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final size = const Size(240, 240); // Further increased size

      // Load and draw company image
      final imageProvider = NetworkImage(imageUrl);
      final imageStream = imageProvider.resolve(ImageConfiguration.empty);
      final completer = Completer<void>();
      late ImageInfo imageInfo;

      imageStream.addListener(
        ImageStreamListener((info, _) {
          imageInfo = info;
          completer.complete();
        }, onError: (error, _) {
          completer.completeError(error);
        }),
      );

      await completer.future;

      // Draw circular background
      final paint = Paint()..color = Colors.white;
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        80, // Increased radius for larger marker
        paint,
      );

      // Draw company image in a circle
      final imageSize = Size(
        imageInfo.image.width.toDouble(),
        imageInfo.image.height.toDouble(),
      );
      final src = Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);
      final dst =
          Rect.fromLTWH(80, 80, 80, 80); // Adjusted size for larger image
      canvas.save();
      canvas.clipPath(
          Path()..addOval(Rect.fromLTWH(80, 80, 80, 80))); // Adjusted clip
      canvas.drawImageRect(imageInfo.image, src, dst, Paint());
      canvas.restore();

      final picture = recorder.endRecording();
      final image = await picture.toImage(
        size.width.toInt(),
        size.height.toInt(),
      );
      final bytes = await image.toByteData(format: ImageByteFormat.png);

      return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
    } catch (e) {
      print('Error creating custom marker: $e');
      return null;
    }
  }

  void _createMarkers(BitmapDescriptor currentLocationMarker) {
    setState(() {
      markers = widget.companies.map((company) {
        return Marker(
          markerId: MarkerId(company.name),
          position: LatLng(company.lat, company.long),
          infoWindow: InfoWindow(title: company.name),
          icon: customMarkers[company.name] ?? BitmapDescriptor.defaultMarker,
          onTap: () {
            setState(() {
              selectedCompany = company;
              _bounceController.reset();
              _bounceController.forward();
            });
          },
        );
      }).toSet();

      // Add current location marker
      markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(
          widget.currentPosition.latitude,
          widget.currentPosition.longitude,
        ),
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: currentLocationMarker,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Companies Map'),
        elevation: 0,
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.currentPosition.latitude,
                widget.currentPosition.longitude,
              ),
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            compassEnabled: true,
            zoomControlsEnabled: false,
          ),
          if (selectedCompany != null)
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Positioned(
                  bottom: 16 + (10 * _bounceAnimation.value),
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Hero(
                                tag: selectedCompany!.name,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Image.network(
                                      selectedCompany!.image,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error,
                                            size: 40);
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedCompany!.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            size: 16, color: Colors.green),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            selectedCompany!.address,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        ...List.generate(
                                          selectedCompany!.rating.round(),
                                          (index) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${selectedCompany!.rating.toString()} / 5',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Add navigation or details page logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: const Size(double.infinity, 45),
                            ),
                            child: const Text(
                              'View Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }
}
