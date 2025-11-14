class ProductModel {
  final String id;
  final String name;
  final String description;
  final double localPrice;
  final double? onlinePrice;
  final String? onlineSource;
  final List<String> images;
  final String category;
  final ShopModel shop;
  final int stock;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final DateTime createdAt;
  final int vibeMatchScore;
  
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.localPrice,
    this.onlinePrice,
    this.onlineSource,
    this.images = const [],
    required this.category,
    required this.shop,
    this.stock = 0,
    this.isAvailable = true,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.tags = const [],
    required this.createdAt,
    this.vibeMatchScore = 0,
  });
  
  double get priceDifference {
    if (onlinePrice == null) return 0;
    return localPrice - onlinePrice!;
  }
  
  double get priceDifferencePercentage {
    if (onlinePrice == null || onlinePrice == 0) return 0;
    return ((localPrice - onlinePrice!) / onlinePrice!) * 100;
  }
  
  bool get isCheaperThanOnline => priceDifference < 0;
  
  String get priceComparisonText {
    if (onlinePrice == null) return 'Best local price';
    if (isCheaperThanOnline) {
      return 'RM${priceDifference.abs().toStringAsFixed(2)} cheaper than online!';
    } else {
      return 'RM${priceDifference.toStringAsFixed(2)} more than online';
    }
  }
  
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      localPrice: json['localPrice'].toDouble(),
      onlinePrice: json['onlinePrice']?.toDouble(),
      onlineSource: json['onlineSource'],
      images: List<String>.from(json['images'] ?? []),
      category: json['category'],
      shop: ShopModel.fromJson(json['shop']),
      stock: json['stock'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      vibeMatchScore: json['vibeMatchScore'] ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'localPrice': localPrice,
      'onlinePrice': onlinePrice,
      'onlineSource': onlineSource,
      'images': images,
      'category': category,
      'shop': shop.toJson(),
      'stock': stock,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'vibeMatchScore': vibeMatchScore,
    };
  }
}

class ShopModel {
  final String id;
  final String name;
  final String description;
  final String ownerName;
  final String? avatar;
  final String? coverImage;
  final String location;
  final double distance;
  final int vibeMatch;
  final double rating;
  final int reviewCount;
  final List<String> categories;
  final bool isVerified;
  final DateTime joinedDate;
  
  ShopModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerName,
    this.avatar,
    this.coverImage,
    required this.location,
    this.distance = 0.0,
    this.vibeMatch = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.categories = const [],
    this.isVerified = false,
    required this.joinedDate,
  });
  
  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      ownerName: json['ownerName'],
      avatar: json['avatar'],
      coverImage: json['coverImage'],
      location: json['location'],
      distance: json['distance']?.toDouble() ?? 0.0,
      vibeMatch: json['vibeMatch'] ?? 0,
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      categories: List<String>.from(json['categories'] ?? []),
      isVerified: json['isVerified'] ?? false,
      joinedDate: DateTime.parse(json['joinedDate']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ownerName': ownerName,
      'avatar': avatar,
      'coverImage': coverImage,
      'location': location,
      'distance': distance,
      'vibeMatch': vibeMatch,
      'rating': rating,
      'reviewCount': reviewCount,
      'categories': categories,
      'isVerified': isVerified,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }
}

class CartItemModel {
  final ProductModel product;
  int quantity;
  
  CartItemModel({
    required this.product,
    this.quantity = 1,
  });
  
  double get totalPrice => product.localPrice * quantity;
}

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final ShopModel shop;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final OrderStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? completedAt;
  
  OrderModel({
    required this.id,
    required this.items,
    required this.shop,
    required this.subtotal,
    this.deliveryFee = 0.0,
    this.discount = 0.0,
    required this.total,
    this.status = OrderStatus.pending,
    this.notes,
    required this.createdAt,
    this.completedAt,
  });
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  delivering,
  completed,
  cancelled,
}

class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final List<String> images;
  final DateTime createdAt;
  final bool isVerified;
  
  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    this.images = const [],
    required this.createdAt,
    this.isVerified = false,
  });
  
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      productId: json['productId'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      images: List<String>.from(json['images'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      isVerified: json['isVerified'] ?? false,
    );
  }
}