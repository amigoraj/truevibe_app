import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import 'product_detail_screen.dart';
import 'shop_profile_screen.dart';

class MarketplaceHomeScreen extends StatefulWidget {
  const MarketplaceHomeScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceHomeScreen> createState() => _MarketplaceHomeScreenState();
}

class _MarketplaceHomeScreenState extends State<MarketplaceHomeScreen> {
  int _selectedCategory = 0;
  String _sortBy = 'vibe';

  final List<String> _categories = [
    'All',
    '💼 Services',
    '🍕 Food',
    '📦 Products',
    '🎨 Art',
    '✂️ Beauty',
    '🏋️ Fitness',
    '📚 Education',
  ];

  @override
  Widget build(BuildContext context) {
    final products = _getMockProducts();
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildCategoryFilter(),
                _buildSortOptions(),
                const SizedBox(height: 8),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildProductCard(products[index]),
                childCount: products.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Colors.white,
      title: const Text(
        'Local Marketplace',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
              onPressed: () {},
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFEC4899),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                _categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = index);
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF8B5CF6),
              elevation: isSelected ? 4 : 0,
              shadowColor: const Color(0xFF8B5CF6).withOpacity(0.4),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            'Sort by:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip('Vibe Match', 'vibe', Icons.favorite),
                  _buildSortChip('Price: Low-High', 'price_asc', Icons.arrow_upward),
                  _buildSortChip('Distance', 'distance', Icons.location_on),
                  _buildSortChip('Rating', 'rating', Icons.star),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value, IconData icon) {
    final isSelected = _sortBy == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _sortBy = value);
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF8B5CF6),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      product.images.isNotEmpty ? product.images[0] : '📦',
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '${product.vibeMatchScore}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (product.onlinePrice != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: product.isCheaperThanOnline
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            product.isCheaperThanOnline
                                ? Icons.trending_down
                                : Icons.trending_up,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'RM${product.priceDifference.abs().toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopProfileScreen(shop: product.shop),
                          ),
                        );
                      },
                      child: Row(
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
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${product.shop.distance.toStringAsFixed(1)}km',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          'RM${product.localPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                        if (product.onlinePrice != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            'RM${product.onlinePrice!.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ProductModel> _getMockProducts() {
    final shop1 = ShopModel(
      id: '1',
      name: 'Art Haven',
      description: 'Local art supplies',
      ownerName: 'Sarah Chen',
      location: 'Petaling Jaya',
      distance: 2.3,
      vibeMatch: 87,
      rating: 4.8,
      reviewCount: 234,
      categories: ['Art'],
      isVerified: true,
      joinedDate: DateTime.now().subtract(const Duration(days: 365)),
    );

    final shop2 = ShopModel(
      id: '2',
      name: 'Tech & Creative',
      description: 'Business tools',
      ownerName: 'John Martinez',
      location: 'Subang Jaya',
      distance: 4.1,
      vibeMatch: 92,
      rating: 4.9,
      reviewCount: 156,
      categories: ['Business', 'Tech'],
      isVerified: true,
      joinedDate: DateTime.now().subtract(const Duration(days: 180)),
    );

    return [
      ProductModel(
        id: '1',
        name: 'Premium Watercolor Set',
        description: 'Professional 24-color watercolor paint set',
        localPrice: 89.90,
        onlinePrice: 99.00,
        onlineSource: 'Shopee',
        images: ['🎨'],
        category: 'Art',
        shop: shop1,
        stock: 15,
        rating: 4.7,
        reviewCount: 45,
        tags: ['Premium', 'Art'],
        createdAt: DateTime.now(),
        vibeMatchScore: 87,
      ),
      ProductModel(
        id: '2',
        name: 'Business Planner 2024',
        description: 'Complete productivity planner',
        localPrice: 45.00,
        onlinePrice: 39.90,
        onlineSource: 'Lazada',
        images: ['📓'],
        category: 'Business',
        shop: shop2,
        stock: 30,
        rating: 4.9,
        reviewCount: 78,
        tags: ['Productivity'],
        createdAt: DateTime.now(),
        vibeMatchScore: 92,
      ),
      ProductModel(
        id: '3',
        name: 'Acrylic Paint Set',
        description: '12 vibrant colors for artists',
        localPrice: 55.00,
        onlinePrice: 65.00,
        onlineSource: 'Shopee',
        images: ['🖌️'],
        category: 'Art',
        shop: shop1,
        stock: 20,
        rating: 4.6,
        reviewCount: 34,
        tags: ['Art', 'Beginner'],
        createdAt: DateTime.now(),
        vibeMatchScore: 85,
      ),
      ProductModel(
        id: '4',
        name: 'Wireless Mouse',
        description: 'Ergonomic wireless mouse',
        localPrice: 39.90,
        onlinePrice: 35.00,
        onlineSource: 'Lazada',
        images: ['🖱️'],
        category: 'Tech',
        shop: shop2,
        stock: 50,
        rating: 4.5,
        reviewCount: 123,
        tags: ['Tech', 'Office'],
        createdAt: DateTime.now(),
        vibeMatchScore: 78,
      ),
    ];
  }
}