import 'package:flutter/material.dart';
import 'product_model.dart';

enum ListingType {
  service,
  food,
  product,
}

class UnifiedListing {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final ShopModel shop;
  final List<String> tags;
  final ListingType listingType;

  UnifiedListing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.shop,
    this.tags = const [],
    required this.listingType,
  });
}