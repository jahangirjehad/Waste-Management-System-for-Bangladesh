import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/Model/recyclingCompany.dart';

class MapScreen extends StatefulWidget {
  final List<RecyclingCompany> companies;
  final Position currentPosition;

  MapScreen({required this.companies, required this.currentPosition});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  RecyclingCompany? selectedCompany;

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    setState(() {
      markers = widget.companies.map((company) {
        return Marker(
          markerId: MarkerId(company.name),
          position: LatLng(company.lat, company.long),
          infoWindow: InfoWindow(title: company.name),
          onTap: () {
            setState(() {
              selectedCompany = company;
            });
          },
        );
      }).toSet();
      print('................................');
      print(markers.length);

      // Add a marker for the current position
      markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(
            widget.currentPosition.latitude, widget.currentPosition.longitude),
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Companies Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.currentPosition.latitude,
                  widget.currentPosition.longitude),
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: markers,
          ),
          if (selectedCompany != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: Container(
                          width: 80,
                          height: 80,
                          child: Image.network(
                            selectedCompany!.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, size: 40);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedCompany!.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selectedCompany!.address,
                              style: const TextStyle(fontSize: 14),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: List.generate(
                                selectedCompany!.rating.round(),
                                (index) => const Icon(Icons.star,
                                    color: Colors.yellow, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
