class RecyclingCompany {
  String name;
  String image;
  String mobile;
  double rating;
  String address;
  String email;
  double lat;
  double long;
  Map<String, List<SellingCategory>> sellingCategory;

  RecyclingCompany({
    required this.name,
    required this.image,
    required this.mobile,
    required this.rating,
    required this.address,
    required this.email,
    required this.lat,
    required this.long,
    required this.sellingCategory,
  });

  factory RecyclingCompany.fromJson(Map<String, dynamic> json) {
    return RecyclingCompany(
      name: json['name'],
      image: json['image'],
      mobile: json['mobile'],
      rating: json['rating'].toDouble(),
      address: json['address'],
      email: json['email'],
      lat: json['lat'].toDouble(),
      long: json['long'].toDouble(),
      sellingCategory: (json['selling_category'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((item) => SellingCategory.fromJson(item))
              .toList(),
        ),
      ),
    );
  }
}

class SellingCategory {
  String images;
  String description;
  int minWeight;
  int price;

  SellingCategory({
    required this.images,
    required this.description,
    required this.minWeight,
    required this.price,
  });

  factory SellingCategory.fromJson(Map<String, dynamic> json) {
    return SellingCategory(
      images: json['images'],
      description: json['description'],
      minWeight: json['minWeight'],
      price: json['price'],
    );
  }
}
