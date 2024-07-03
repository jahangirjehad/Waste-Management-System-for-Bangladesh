import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_app/Controller/fetchUser.dart';
import 'package:maps_app/Model/userModel.dart';
import 'package:maps_app/View/Profile/companyProfileScreen.dart';
import 'package:maps_app/View/google_map/screens/google_map_page.dart';
import 'package:maps_app/utils/my_colors.dart';

class CompanyListPage extends StatefulWidget {
  const CompanyListPage({super.key});

  @override
  _CompanyListPageState createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  late Future<List<RecyclingCompany>> futureCompanies;
  List<RecyclingCompany> allCompanies = [];
  List<RecyclingCompany> filteredCompanies = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  double maxDistance = double.infinity;
  String addressFilter = '';
  double userLat = 0.0;
  double userLon = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      Position position = await _getCurrentLocation();
      setState(() {
        userLat = position.latitude;
        userLon = position.longitude;
      });

      List<RecyclingCompany> companies = await ApiService().fetchUsers();
      setState(() {
        allCompanies = companies;
        filteredCompanies = companies;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      // Handle error, maybe show error message
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  void filterCompanies(String nameQuery,
      {String? addressQuery, double? distance}) {
    setState(() {
      filteredCompanies = allCompanies.where((company) {
        bool nameMatch =
            company.companyName.toLowerCase().contains(nameQuery.toLowerCase());
        bool addressMatch = addressQuery == null ||
            company.address.toLowerCase().contains(addressQuery.toLowerCase());
        double companyDistance =
            calculateDistance(userLat, userLon, company.lat, company.long);
        bool distanceMatch = distance == null || companyDistance <= distance;
        return nameMatch && addressMatch && distanceMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.caribbeanGreenTint7,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.white,
                    elevation: 10,
                    child: Autocomplete<RecyclingCompany>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<RecyclingCompany>.empty();
                        }
                        return allCompanies.where((RecyclingCompany company) {
                          return company.companyName
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (RecyclingCompany selection) {
                        filterCompanies(selection.companyName,
                            addressQuery: addressFilter, distance: maxDistance);
                      },
                      displayStringForOption: (RecyclingCompany option) =>
                          option.companyName,
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                        return TextField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Search by name...',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            suffixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            filterCompanies(value,
                                addressQuery: addressFilter,
                                distance: maxDistance);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return allCompanies
                                .map((company) => company.address)
                                .where((address) => address
                                    .toLowerCase()
                                    .contains(
                                        textEditingValue.text.toLowerCase()))
                                .toSet() // Remove duplicates
                                .toList();
                          },
                          onSelected: (String selection) {
                            addressFilter = selection;
                            filterCompanies(searchController.text,
                                addressQuery: addressFilter,
                                distance: maxDistance);
                          },
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted) {
                            addressController = fieldTextEditingController;
                            return TextField(
                              controller: fieldTextEditingController,
                              focusNode: fieldFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Filter by address',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onChanged: (value) {
                                addressFilter = value;
                                filterCompanies(searchController.text,
                                    addressQuery: addressFilter,
                                    distance: maxDistance);
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      DropdownButton<double>(
                        value:
                            maxDistance == double.infinity ? null : maxDistance,
                        hint: Text('Max distance'),
                        items:
                            [5.0, 10.0, 20.0, 50.0, 100.0].map((double value) {
                          return DropdownMenuItem<double>(
                            value: value,
                            child: Text('$value km'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            maxDistance = value ?? double.infinity;
                            filterCompanies(searchController.text,
                                addressQuery: addressFilter,
                                distance: maxDistance);
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.caribbeanGreenTint4,
                        elevation: 3,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const GoogleMapPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, color: Colors.redAccent),
                          Text('Search By Map'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCompanies.length,
                      itemBuilder: (context, index) {
                        RecyclingCompany company = filteredCompanies[index];
                        return Card(
                          elevation: 3,
                          color: MyColors.caribbeanGreenTint5,
                          child: ListTile(
                            leading: Image.network(
                              company.image,
                              width: 50,
                              height: 70,
                            ),
                            title: Text(
                              company.companyName,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                                "Address: ${company.address}\nMobile: ${company.mobile}"),
                            onTap: () {
                              print(company);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CompanyProfile(
                                          recyclingCompany: company)));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
