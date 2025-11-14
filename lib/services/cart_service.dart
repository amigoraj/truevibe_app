// lib/services/cart_service.dart
import '../models/cart_item.dart';

class CartService {
  // Singleton pattern - only one instance of CartService exists
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  // Cart items storage
  final List<CartItem> _cartItems = [];

  // Get all cart items
  List<CartItem> get items => List.unmodifiable(_cartItems);

  // Get cart item count
  int get itemCount => _cartItems.length;

  // Get total quantity of all items
  int get totalQuantity {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Check if cart is empty
  bool get isEmpty => _cartItems.isEmpty;

  // Add item to cart
  void addItem(CartItem item) {
    // Check if item already exists in cart
    final existingIndex = _cartItems.indexWhere((i) => i.id == item.id);
    
    if (existingIndex >= 0) {
      // Item exists, increase quantity
      final existingItem = _cartItems[existingIndex];
      _cartItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      // New item, add to cart
      _cartItems.add(item);
    }
  }

  // Add item from marketplace (simplified)
  void addFromMarketplace({
    required String id,
    required String name,
    required double price,
    required String shopName,
    String? customization,
    String? emoji,
  }) {
    final item = CartItem(
      id: id,
      name: name,
      price: price,
      quantity: 1,
      imageEmoji: emoji ?? '📦',
      shopName: shopName,
      customization: customization,
    );
    addItem(item);
  }

  // Update item quantity
  void updateQuantity(String itemId, int newQuantity) {
    final index = _cartItems.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      }
    }
  }

  // Remove item from cart
  void removeItem(String itemId) {
    _cartItems.removeWhere((item) => item.id == itemId);
  }

  // Clear entire cart
  void clear() {
    _cartItems.clear();
  }

  // Get item by ID
  CartItem? getItem(String itemId) {
    try {
      return _cartItems.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  // Calculate subtotal
  double getSubtotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Calculate vibe discount (10%)
  double getVibeDiscount() {
    return getSubtotal() * 0.10;
  }

  // Calculate delivery fee
  double getDeliveryFee() {
    return getSubtotal() >= 50 ? 0 : 5.0;
  }

  // Calculate total
  double getTotal() {
    return getSubtotal() - getVibeDiscount() + getDeliveryFee();
  }
}