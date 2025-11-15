import 'package:flutter/material.dart';
import 'fun_feed_screen.dart';
import 'passion_feed_screen.dart';
import 'discover_screen.dart';
import 'vibe_match_screen.dart';
import '../profile_screen.dart';
import 'marketplace_home_screen.dart';
import '../revolutionary_profile_screen.dart';
import '../revolutionary_feed_screen.dart';
import '../revolutionary_passion_feed_screen.dart';

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
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    if (_currentIndex == 0) {
      return TabBarView(
        controller: _tabController,
        children: const [
          RevolutionaryFeedScreen(),           // ← Fun Feed with 15 emojis
          RevolutionaryPassionFeedScreen(),    // ← Passion Feed with 15 emojis
        ],
      );
    }

    switch (_currentIndex) {
      case 1: return const DiscoverScreen();
      case 2: return const VibeMatchScreen();
      case 3: return const MarketplaceHomeScreen();
      case 4: return const RevolutionaryProfileScreen();
      default: return const RevolutionaryFeedScreen();
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
}