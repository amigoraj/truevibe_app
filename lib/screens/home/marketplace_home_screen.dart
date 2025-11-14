import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../models/service_model.dart';
import '../../services/cart_service.dart';
import '../marketplace/service_booking_screen.dart';
import '../marketplace/my_bookings_screen.dart';
import '../marketplace/shopping_cart_screen.dart';

class MarketplaceHomeScreen extends StatefulWidget {
  const MarketplaceHomeScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceHomeScreen> createState() => _MarketplaceHomeScreenState();
}

class _MarketplaceHomeScreenState extends State<MarketplaceHomeScreen> {
  String _selectedCategory = 'All';
  String _sortBy = 'Recommended';
  final CartService _cartService = CartService();

  final List<String> categories = [
    'All',
    'Services',
    'Food',
    'Products',
    'Beauty',
    'Fitness',
    'Education',
    'Health',
  ];

  final List<String> sortOptions = [
    'Recommended',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
    'Distance',
    'Vibe Match',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildSearchBar(),
          _buildCategories(),
          _buildSortingBar(),
          _buildProductGrid(filteredProducts),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      title: const Text(
        'Marketplace',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      actions: [
        // 🛒 SHOPPING CART BUTTON WITH BADGE
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShoppingCartScreen(),
                  ),
                );
                setState(() {});
              },
            ),
            if (_cartService.totalQuantity > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '${_cartService.totalQuantity}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),

        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.calendar_today),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyBookingsScreen(),
              ),
            );
          },
        ),

        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for services, food, or products...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.blue),
                onPressed: () {
                  _showFilterDialog();
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = _selectedCategory == category;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: Colors.blue,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSortingBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sortBy,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: sortOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _sortBy = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () {
                  _showFilterDialog();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<UnifiedListing> products) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildProductCard(products[index]);
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildProductCard(UnifiedListing product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    _getEmoji(product.listingType, product.category),
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getBadgeColor(product.listingType),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.listingType.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (product.tags.isNotEmpty)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.tags.first,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(
                        Icons.store,
                        size: 12,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product.shop.name,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        product.shop.rating.toString(),
                        style: const TextStyle(fontSize: 11),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${product.shop.distance.toStringAsFixed(1)} km',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RM ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 10,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${product.shop.vibeMatch}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (product.listingType == ListingType.service) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceBookingScreen(
                              service: product,
                            ),
                          ),
                        );
                      } else {
                        // For food and products, show message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              product.listingType == ListingType.food
                                  ? 'Food menu coming soon! Use "Add" to add to cart.'
                                  : 'Product details coming soon! Use "Add" to add to cart.',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: BorderSide(color: Colors.blue.shade300),
                    ),
                    child: const Text(
                      'View',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _addToCart(product);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.add_shopping_cart, size: 14),
                    label: const Text(
                      'Add',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(UnifiedListing product) {
    _cartService.addFromMarketplace(
      id: product.id,
      name: product.title,
      price: product.price,
      shopName: product.shop.name,
      emoji: _getEmoji(product.listingType, product.category),
    );

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text('${product.title} added to cart!'),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ShoppingCartScreen(),
              ),
            );
            setState(() {});
          },
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Price Range'),
            const Text('Distance'),
            const Text('Rating'),
            const Text('Vibe Match'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<UnifiedListing> _getFilteredProducts() {
    final allProducts = _getMockProducts();

    if (_selectedCategory == 'All') {
      return allProducts;
    }

    return allProducts.where((product) {
      if (_selectedCategory == 'Services') {
        return product.listingType == ListingType.service;
      } else if (_selectedCategory == 'Food') {
        return product.listingType == ListingType.food;
      } else if (_selectedCategory == 'Products') {
        return product.listingType == ListingType.product;
      } else {
        return product.category
            .toLowerCase()
            .contains(_selectedCategory.toLowerCase());
      }
    }).toList();
  }

  List<UnifiedListing> _getMockProducts() {
    final shop1 = ShopModel(
      id: '1',
      name: 'Style Studio',
      ownerName: 'Sarah Johnson',
      location: 'Rawang Plaza, Selangor',
      description: 'Premium salon and beauty services',
      rating: 4.8,
      reviewCount: 156,
      distance: 2.3,
      vibeMatch: 85,
      joinedDate: DateTime(2023, 1, 15),
    );

    final shop2 = ShopModel(
      id: '2',
      name: 'FitZone Gym',
      ownerName: 'Mike Chen',
      location: 'Rawang Town Center, Selangor',
      description: 'Your fitness journey starts here',
      rating: 4.9,
      reviewCount: 203,
      distance: 1.5,
      vibeMatch: 92,
      joinedDate: DateTime(2022, 6, 10),
    );

    final shop3 = ShopModel(
      id: '3',
      name: 'Creative Corner',
      ownerName: 'Emma Davis',
      location: 'Bandar Country Homes, Rawang',
      description: 'Art supplies and creative workshops',
      rating: 4.7,
      reviewCount: 89,
      distance: 3.1,
      vibeMatch: 78,
      joinedDate: DateTime(2023, 3, 20),
    );

    final shop4 = ShopModel(
      id: '4',
      name: 'Mama Kitchen',
      ownerName: 'Mrs. Wong',
      location: 'Rawang Market Area',
      description: 'Authentic Malaysian cuisine',
      rating: 4.9,
      reviewCount: 312,
      distance: 1.2,
      vibeMatch: 88,
      joinedDate: DateTime(2020, 8, 5),
    );

    final shop5 = ShopModel(
      id: '5',
      name: 'Tech Haven',
      ownerName: 'David Tan',
      location: 'Aeon Rawang',
      description: 'Electronics and gadgets',
      rating: 4.6,
      reviewCount: 145,
      distance: 2.8,
      vibeMatch: 72,
      joinedDate: DateTime(2022, 11, 12),
    );

    return [
      UnifiedListing(
        id: '1',
        title: 'Premium Haircut',
        description: 'Professional haircut with styling',
        price: 25.00,
        category: 'Beauty',
        shop: shop1,
        tags: ['Bestseller'],
        listingType: ListingType.service,
      ),
      UnifiedListing(
        id: '2',
        title: 'Personal Training Session',
        description: '1-hour personal training',
        price: 45.00,
        category: 'Fitness',
        shop: shop2,
        tags: ['Hot'],
        listingType: ListingType.service,
      ),
      UnifiedListing(
        id: '3',
        title: 'Art Class Beginner',
        description: 'Learn painting basics',
        price: 35.00,
        category: 'Education',
        shop: shop3,
        tags: ['New'],
        listingType: ListingType.service,
      ),
      UnifiedListing(
        id: '4',
        title: 'Nasi Lemak Special',
        description: 'Traditional Malaysian breakfast',
        price: 12.50,
        category: 'Food',
        shop: shop4,
        tags: ['Trending'],
        listingType: ListingType.food,
      ),
      UnifiedListing(
        id: '5',
        title: 'Chicken Rice Set',
        description: 'Hainanese chicken rice with soup',
        price: 15.00,
        category: 'Food',
        shop: shop4,
        tags: ['Bestseller'],
        listingType: ListingType.food,
      ),
      UnifiedListing(
        id: '6',
        title: 'Business Planner 2025',
        description: 'Digital planner with templates',
        price: 29.99,
        category: 'Business',
        shop: shop3,
        tags: ['New'],
        listingType: ListingType.product,
      ),
      UnifiedListing(
        id: '7',
        title: 'Wireless Earbuds',
        description: 'Bluetooth 5.0 with noise cancellation',
        price: 89.00,
        category: 'Electronics',
        shop: shop5,
        tags: ['Hot'],
        listingType: ListingType.product,
      ),
      UnifiedListing(
        id: '8',
        title: 'Yoga Class',
        description: 'Group yoga session',
        price: 20.00,
        category: 'Fitness',
        shop: shop2,
        tags: ['Trending'],
        listingType: ListingType.service,
      ),
      UnifiedListing(
        id: '9',
        title: 'Facial Treatment',
        description: 'Deep cleansing facial',
        price: 55.00,
        category: 'Beauty',
        shop: shop1,
        tags: ['Bestseller'],
        listingType: ListingType.service,
      ),
      UnifiedListing(
        id: '10',
        title: 'Roti Canai Set',
        description: 'Crispy roti with curry',
        price: 8.50,
        category: 'Food',
        shop: shop4,
        tags: ['Hot'],
        listingType: ListingType.food,
      ),
      UnifiedListing(
        id: '11',
        title: 'Smartwatch',
        description: 'Fitness tracker with heart rate monitor',
        price: 199.00,
        category: 'Electronics',
        shop: shop5,
        tags: ['New'],
        listingType: ListingType.product,
      ),
      UnifiedListing(
        id: '12',
        title: 'Art Supplies Set',
        description: 'Complete painting kit',
        price: 45.00,
        category: 'Art',
        shop: shop3,
        tags: ['Trending'],
        listingType: ListingType.product,
      ),
    ];
  }

  String _getEmoji(ListingType type, String category) {
    switch (type) {
      case ListingType.service:
        switch (category.toLowerCase()) {
          case 'beauty':
            return '💇‍♀️';
          case 'fitness':
            return '💪';
          case 'education':
            return '📚';
          case 'health':
            return '🏥';
          default:
            return '⭐';
        }
      case ListingType.food:
        return '🍛';
      case ListingType.product:
        switch (category.toLowerCase()) {
          case 'electronics':
            return '📱';
          case 'art':
            return '🎨';
          case 'business':
            return '📊';
          default:
            return '📦';
        }
    }
  }

  Color _getBadgeColor(ListingType type) {
    switch (type) {
      case ListingType.service:
        return Colors.blue;
      case ListingType.food:
        return Colors.orange;
      case ListingType.product:
        return Colors.green;
    }
  }
}