class Product {
  final String? id;
  final String? imageUrl;
  final String? title;
  final String? author;
  final double? rating;
  final String? price;
  final bool isFavorite;

  Product({
    this.id,
    this.imageUrl,
    this.title,
    this.author,
    this.rating,
    this.price,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      author: json['author'],
      rating: json['rating']?.toDouble(),
      price: json['price'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'author': author,
      'rating': rating,
      'price': price,
      'isFavorite': isFavorite,
    };
  }
}