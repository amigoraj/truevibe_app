// lib/screens/trending_feed_screen.dart
// Brand new "Viral" or "Trending" feed tab showing popular content

import 'package:flutter/material.dart';
import '../models/reaction_model.dart';
import '../widgets/reaction_bar_widget.dart';
import '../screens/personality_dashboard_screen.dart';

class TrendingFeedScreen extends StatefulWidget {
  const TrendingFeedScreen({Key? key}) : super(key: key);

  @override
  State<TrendingFeedScreen> createState() => _TrendingFeedScreenState();
}

class _TrendingFeedScreenState extends State<TrendingFeedScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'News', 'Motivation', 'Funny', 'Local'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔥 Trending'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          // Link to personality dashboard
          IconButton(
            icon: const Icon(Icons.insights),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonalityDashboardScreen(),
                ),
              );
            },
            tooltip: 'Your Insights',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = filter == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: Colors.blue[100],
                      checkmarkColor: Colors.blue,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.blue[700] : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Info banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Every reaction teaches you! Tap any emoji to learn.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Feed content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Sample posts with different types
                _buildTrendingPost(
                  id: 'post1',
                  author: 'Climate Science Daily',
                  avatar: '🌍',
                  content: 'New study shows renewable energy costs dropped 70% in the last decade. Solar and wind are now cheaper than fossil fuels in most regions.',
                  type: 'news',
                  trendingScore: 9.2,
                  image: '📊',
                ),
                
                const SizedBox(height: 16),
                
                _buildTrendingPost(
                  id: 'post2',
                  author: 'Sarah_Inspires',
                  avatar: '💪',
                  content: 'Failed my driving test 3 times. Just passed today! Never give up on your dreams, no matter how many tries it takes! 🚗✨',
                  type: 'motivation',
                  trendingScore: 8.7,
                  image: '🎉',
                ),
                
                const SizedBox(height: 16),
                
                _buildTrendingPost(
                  id: 'post3',
                  author: 'TechMemes',
                  avatar: '💻',
                  content: 'When you finally fix the bug at 3AM and it breaks 5 other things 😅\n\n"I am inevitable" - The Bug',
                  type: 'funny',
                  trendingScore: 9.5,
                  image: '🐛',
                ),
                
                const SizedBox(height: 16),
                
                _buildTrendingPost(
                  id: 'post4',
                  author: 'Local Food Scene',
                  avatar: '🍜',
                  content: 'New restaurant in Shah Alam serving authentic Penang street food! Who wants to try this weekend?',
                  type: 'general',
                  trendingScore: 7.8,
                  image: '🍲',
                ),
                
                const SizedBox(height: 16),
                
                _buildTrendingPost(
                  id: 'post5',
                  author: 'Dr. Health Tips',
                  avatar: '⚕️',
                  content: 'Reminder: Walking 30 minutes daily reduces heart disease risk by 35%. You don\'t need a gym membership to be healthy!',
                  type: 'news',
                  trendingScore: 8.3,
                  image: '🚶',
                ),
                
                const SizedBox(height: 16),
                
                _buildTrendingPost(
                  id: 'post6',
                  author: 'Startup Stories',
                  avatar: '🚀',
                  content: 'From coding in my bedroom to $1M revenue. The journey wasn\'t easy, but consistency beats talent every single time.',
                  type: 'motivation',
                  trendingScore: 9.0,
                  image: '💰',
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTrendingPost({
    required String id,
    required String author,
    required String avatar,
    required String content,
    required String type,
    required double trendingScore,
    required String image,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple[400]!, Colors.blue[400]!],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      avatar,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 14,
                            color: Colors.orange[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Trending ${trendingScore.toStringAsFixed(1)}/10',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Post type badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getTypeColor(type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getTypeLabel(type),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _getTypeColor(type),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
          
          // Post image/emoji
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                image,
                style: const TextStyle(fontSize: 80),
              ),
            ),
          ),
          
          // THIS IS THE KEY PART - Add ReactionBar to every post!
          ReactionBar(
            postId: id,
            postType: type,
          ),
        ],
      ),
    );
  }
  
  Color _getTypeColor(String type) {
    switch (type) {
      case 'news':
        return Colors.blue;
      case 'motivation':
        return Colors.green;
      case 'funny':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  String _getTypeLabel(String type) {
    switch (type) {
      case 'news':
        return 'News';
      case 'motivation':
        return 'Inspiring';
      case 'funny':
        return 'Fun';
      default:
        return 'General';
    }
  }
}