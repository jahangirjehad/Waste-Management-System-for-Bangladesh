// lib/user_model.dart

class SalesLocation {
  final String location;
  final String salesman;
  final String mobile;

  SalesLocation({
    required this.location,
    required this.salesman,
    required this.mobile,
  });

  factory SalesLocation.fromJson(Map<String, dynamic> json) {
    return SalesLocation(
      location: json['location'],
      salesman: json['salesman'],
      mobile: json['mobile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'salesman': salesman,
      'mobile': mobile,
    };
  }
}

class RecyclingCompany {
  final String companyName;
  final double lat;
  final double long;
  final String image;
  final String mobile;
  final String address;
  final String email;
  final List<SalesLocation> salesLocations;
  final Map<String, String> wasteCategories;

  RecyclingCompany({
    required this.companyName,
    required this.lat,
    required this.long,
    required this.image,
    required this.mobile,
    required this.address,
    required this.email,
    required this.salesLocations,
    required this.wasteCategories,
  });

  factory RecyclingCompany.fromJson(Map<String, dynamic> json) {
    var salesLocationsFromJson = json['sales_locations'] as List;
    List<SalesLocation> salesLocationsList =
        salesLocationsFromJson.map((i) => SalesLocation.fromJson(i)).toList();

    return RecyclingCompany(
      companyName: json['company_name'],
      lat: json['lat'].toDouble(),
      long: json['long'].toDouble(),
      image: json['image'],
      mobile: json['mobile'],
      address: json['address'],
      email: json['email'],
      salesLocations: salesLocationsList,
      wasteCategories: Map<String, String>.from(json['waste_categories']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'lat': lat,
      'long': long,
      'image': image,
      'mobile': mobile,
      'address': address,
      'email': email,
      'sales_locations': salesLocations.map((i) => i.toJson()).toList(),
      'waste_categories': wasteCategories,
    };
  }
}
