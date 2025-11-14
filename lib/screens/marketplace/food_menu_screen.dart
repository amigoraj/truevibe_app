import 'package:flutter/material.dart';
import '../../models/service_model.dart';
import 'food_customization_screen.dart';

class FoodMenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageEmoji;
  final bool isVegetarian;
  final bool isSpicy;
  final List<String> allergens;
  final int preparationTime; // in minutes

  FoodMenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageEmoji,
    this.isVegetarian = false,
    this.isSpicy = false,
    this.allergens = const [],
    required this.preparationTime,
  });
}

class FoodMenuScreen extends StatefulWidget {
  final UnifiedListing restaurant;

  const FoodMenuScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<FoodMenuScreen> createState() => _FoodMenuScreenState();
}

class _FoodMenuScreenState extends State<FoodMenuScreen> {
  String selectedCategory = 'All';
  Map<String, int> cartItems = {}; // itemId -> quantity

  final List<String> categories = [
    'All',
    'Popular',
    'Main Course',
    'Appetizers',
    'Desserts',
    'Beverages',
  ];

  @override
  Widget build(BuildContext context) {
    final menuItems = _getMenuItems();
    final filteredItems = selectedCategory == 'All'
        ? menuItems
        : menuItems.where((item) => item.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRestaurantInfo(),
                const SizedBox(height: 16),
                _buildLocalAdvantageBanner(),
                const SizedBox(height: 16),
                _buildCategoryTabs(),
                const SizedBox(height: 16),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildMenuItem(filteredItems[index]);
                },
                childCount: filteredItems.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: cartItems.isNotEmpty ? _buildCartButton() : null,
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.orange.shade400, Colors.red.shade400],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.restaurant.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.restaurant.description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber[700], size: 20),
              const SizedBox(width: 4),
              Text(
                '${widget.restaurant.shop.rating}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Text(
                '(${widget.restaurant.shop.reviewCount} reviews)',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(width: 16),
              Icon(Icons.location_on, color: Colors.grey[600], size: 20),
              const SizedBox(width: 4),
              Text(
                '${widget.restaurant.shop.distance.toStringAsFixed(1)} km',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.restaurant.shop.vibeMatch}% Match',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocalAdvantageBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.teal.shade400],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_fire_department, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fresh & Hot!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Ready in 15-20 min • No delivery fees',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey[300]!,
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(FoodMenuItem item) {
    final quantity = cartItems[item.id] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showCustomizationScreen(item),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food emoji/image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      item.imageEmoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (item.isVegetarian)
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.eco,
                                color: Colors.green,
                                size: 14,
                              ),
                            ),
                          if (item.isSpicy)
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.local_fire_department,
                                color: Colors.red,
                                size: 14,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'RM ${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${item.preparationTime} min',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Add/Remove buttons
                if (quantity == 0)
                  ElevatedButton(
                    onPressed: () => _addToCart(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Add'),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 20),
                          onPressed: () => _removeFromCart(item),
                          color: const Color(0xFF6366F1),
                        ),
                        Text(
                          '$quantity',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: () => _addToCart(item),
                          color: const Color(0xFF6366F1),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartButton() {
    final totalItems = cartItems.values.fold<int>(0, (sum, qty) => sum + qty);
    final totalPrice = _calculateTotal();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () => _proceedToCheckout(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$totalItems',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'View Cart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                'RM ${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart(FoodMenuItem item) {
    setState(() {
      cartItems[item.id] = (cartItems[item.id] ?? 0) + 1;
    });
  }

  void _removeFromCart(FoodMenuItem item) {
    setState(() {
      final currentQty = cartItems[item.id] ?? 0;
      if (currentQty > 1) {
        cartItems[item.id] = currentQty - 1;
      } else {
        cartItems.remove(item.id);
      }
    });
  }

  double _calculateTotal() {
    double total = 0;
    final menuItems = _getMenuItems();
    
    cartItems.forEach((itemId, quantity) {
      final item = menuItems.firstWhere((m) => m.id == itemId);
      total += item.price * quantity;
    });
    
    return total;
  }

  void _showCustomizationScreen(FoodMenuItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodCustomizationScreen(
          item: item,
          onAddToCart: () => _addToCart(item),
        ),
      ),
    );
  }

  void _proceedToCheckout() {
    // Navigate to checkout screen (to be created)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Proceeding to checkout...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  List<FoodMenuItem> _getMenuItems() {
    return [
      FoodMenuItem(
        id: '1',
        name: 'Nasi Lemak Special',
        description: 'Fragrant coconut rice with sambal, fried chicken, egg & anchovies',
        price: 12.90,
        category: 'Popular',
        imageEmoji: '🍛',
        isSpicy: true,
        preparationTime: 15,
      ),
      FoodMenuItem(
        id: '2',
        name: 'Roti Canai',
        description: 'Crispy Malaysian flatbread served with curry',
        price: 3.50,
        category: 'Popular',
        imageEmoji: '🥞',
        isVegetarian: true,
        preparationTime: 10,
      ),
      FoodMenuItem(
        id: '3',
        name: 'Mee Goreng',
        description: 'Spicy stir-fried noodles with vegetables and chicken',
        price: 9.90,
        category: 'Main Course',
        imageEmoji: '🍜',
        isSpicy: true,
        preparationTime: 20,
      ),
      FoodMenuItem(
        id: '4',
        name: 'Chicken Rice',
        description: 'Tender poached chicken with fragrant rice',
        price: 10.90,
        category: 'Main Course',
        imageEmoji: '🍗',
        preparationTime: 15,
      ),
      FoodMenuItem(
        id: '5',
        name: 'Spring Rolls',
        description: 'Crispy vegetable spring rolls (6 pcs)',
        price: 6.90,
        category: 'Appetizers',
        imageEmoji: '🥟',
        isVegetarian: true,
        preparationTime: 10,
      ),
      FoodMenuItem(
        id: '6',
        name: 'Banana Fritters',
        description: 'Golden crispy banana fritters (4 pcs)',
        price: 4.50,
        category: 'Desserts',
        imageEmoji: '🍌',
        isVegetarian: true,
        preparationTime: 10,
      ),
      FoodMenuItem(
        id: '7',
        name: 'Teh Tarik',
        description: 'Famous Malaysian pulled milk tea',
        price: 2.50,
        category: 'Beverages',
        imageEmoji: '🥤',
        isVegetarian: true,
        preparationTime: 5,
      ),
      FoodMenuItem(
        id: '8',
        name: 'Cendol',
        description: 'Traditional dessert with coconut milk & gula melaka',
        price: 5.90,
        category: 'Desserts',
        imageEmoji: '🍧',
        isVegetarian: true,
        preparationTime: 5,
      ),
    ];
  }
}