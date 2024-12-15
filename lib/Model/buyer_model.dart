class Buyer {
  final String userName;
  final String location;
  final String contact;
  final String profileImageUrl;
  final int totalListings;
  final int totalSold;
  final int totalReviews;
  final double rating;
  final List<Product> products;

  Buyer({
    required this.userName,
    required this.location,
    required this.contact,
    required this.profileImageUrl,
    required this.totalListings,
    required this.totalSold,
    required this.totalReviews,
    required this.rating,
    required this.products,
  });

  factory Buyer.fromMap(Map<String, dynamic> data) {
    return Buyer(
      userName: data['userName'] ?? 'Unknown',
      location: data['location'] ?? 'Unknown',
      contact: data['contact'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      totalListings: (data['totalListings']),
      totalSold: (data['totalSold']),
      totalReviews: (data['totalReviews']),
      rating: (data['rating']).toDouble(),
      products: (data['products'] as List)
          .map((item) => Product.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Product {
  final String imageUrl;
  final String name;
  final String description;

  Product({
    required this.imageUrl,
    required this.name,
    required this.description,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      imageUrl: map['imageUrl'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
