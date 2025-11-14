import 'package:flutter/material.dart';
import 'fun_feed_screen.dart';
import 'passion_feed_screen.dart';
import 'discover_screen.dart';
import 'vibe_match_screen.dart';
import 'profile_screen.dart';
import 'marketplace_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    if (_currentIndex == 0) {
      return AppBar(
        title: const Text(
          'TrueVibe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF8B5CF6),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF8B5CF6),
          tabs: const [
            Tab(icon: Icon(Icons.emoji_emotions), text: 'Fun'),
            Tab(icon: Icon(Icons.rocket_launch), text: 'Passion'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer_outlined),
            onPressed: () => _showTimerDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      );
    }
    return AppBar(
      title: Text(_getTitle()),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 1: return 'Discover';
      case 2: return 'Find Clan';
      case 3: return 'Marketplace';
      case 4: return 'Profile';
      default: return 'TrueVibe';
    }
  }

  Widget _buildBody() {
    if (_currentIndex == 0) {
      return TabBarView(
        controller: _tabController,
        children: const [
          FunFeedScreen(),
          PassionFeedScreen(),
        ],
      );
    }

    switch (_currentIndex) {
      case 1: return const DiscoverScreen();
      case 2: return const VibeMatchScreen();
      case 3: return const MarketplaceHomeScreen();
      case 4: return const ProfileScreen();
      default: return const FunFeedScreen();
    }
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF8B5CF6),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Feeds',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Clan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Shop',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  void _showTimerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Timer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How long for entertainment?'),
            const SizedBox(height: 16),
            DropdownButton<int>(
              value: 30,
              items: [15, 30, 45, 60].map((mins) {
                return DropdownMenuItem(
                  value: mins,
                  child: Text('$mins minutes'),
                );
              }).toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Timer set! Enjoy 🎬'),
                ),
              );
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}