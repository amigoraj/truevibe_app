// lib/models/cart_item.dart
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageEmoji;
  final String shopName;
  final String? customization;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageEmoji,
    required this.shopName,
    this.customization,
  });

  // Create a copy with modified fields
  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? imageEmoji,
    String? shopName,
    String? customization,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageEmoji: imageEmoji ?? this.imageEmoji,
      shopName: shopName ?? this.shopName,
      customization: customization ?? this.customization,
    );
  }

  // Convert to JSON (for future backend integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageEmoji': imageEmoji,
      'shopName': shopName,
      'customization': customization,
    };
  }

  // Create from JSON (for future backend integration)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageEmoji: json['imageEmoji'] as String,
      shopName: json['shopName'] as String,
      customization: json['customization'] as String?,
    );
  }
}