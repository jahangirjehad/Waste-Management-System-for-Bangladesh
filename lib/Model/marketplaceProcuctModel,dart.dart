class Product {
  final String name;
  final String price;
  final String imagePath;
  final String sellerID;
  final String description;
  final double lat;
  final double long;

  Product({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.sellerID,
    required this.description,
    required this.lat,
    required this.long,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      imagePath: json['image'],
      sellerID: json['SellerID'],
      description: json['description'],
      lat: json['lat'],
      long: json['long'],
    );
  }
}
