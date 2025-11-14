// lib/screens/passion_feed_screen.dart
import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/logo.dart';
import '../widgets/vibe_score_badge.dart';
import '../utils/gradient_background.dart';
import '../services/api_client.dart';

/// =============================================
/// PASSION FEED SCREEN — Deep, Thoughtful, Conscious
/// =============================================
class PassionFeedScreen extends StatefulWidget {
  @override
  _PassionFeedScreenState createState() => _PassionFeedScreenState();
}

class _PassionFeedScreenState extends State<PassionFeedScreen> {
  // List of passion-focused posts
  List<Map<String, dynamic>> posts = [];

  // User's current vibe score and level
  int _vibeScore = 42;
  String _vibeLevel = "Aware Explorer";

  @override
  void initState() {
    super.initState();
    _loadPassionPosts();
  }

  /// Load sample passion posts (replace with API call later)
  void _loadPassionPosts() {
    setState(() {
      posts = [
        {
          'id': 'p1',
          'content': 'Just finished a deep dive into AI ethics. Mind blown.',
          'author': 'Alex',
          'timestamp': '2h ago',
          'tags': ['AI', 'Ethics', 'Tech'],
        },
        {
          'id': 'p2',
          'content': 'Studying how to spot fake news in 2025. Here’s what I learned:',
          'author': 'Aisha',
          'timestamp': '5h ago',
          'tags': ['Media', 'Truth', 'Learning'],
        },
        {
          'id': 'p3',
          'content': 'Reading “Sapiens” again. Every time I learn something new.',
          'author': 'Leo',
          'timestamp': '1d ago',
          'tags': ['Books', 'History', 'Growth'],
        },
        {
          'id': 'p4',
          'content': 'Climate solutions: Nuclear + Solar + Policy. Let’s talk.',
          'author': 'Maya',
          'timestamp': '2d ago',
          'tags': ['Climate', 'Energy', 'Policy'],
        },
      ];
    });
  }

  /// Handle conscious reaction → send to backend + update vibe
  Future<void> _handleReaction(String postId, String type) async {
    final res = await ApiClient.react(postId, type);
    if (res != null) {
      setState(() {
        _vibeScore = res['vibeScore'] ?? _vibeScore;
        _vibeLevel = res['vibeLevel'] ?? _vibeLevel;
      });

      // Show confetti if level up
      if ((res['vibeLevel'] ?? '') != _vibeLevel && res['levelUp'] == true) {
        _showLevelUpConfetti();
      }
    }

    // Show fact tip for critical reactions
    if (type == 'Questioning' || type == 'Unclear') {
      _showFactTip();
    }
  }

  /// Show fact-checking popup
  void _showFactTip() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFFF8F4FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.orange),
            SizedBox(width: 8),
            Text("Fact Tip", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("• Does this have a verified source?"),
            Text("• Is the image/video edited?"),
            Text("• Check date & context"),
            SizedBox(height: 8),
            Text("Stay neutral until sure!", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Got it!"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  /// Show confetti when user levels up
  void _showLevelUpConfetti() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.amber),
            SizedBox(width: 8),
            Text("Level Up! "),
            Text("$_vibeLevel", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.purple,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          GradientBackground(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header
                _Header(
                  title: "Passion Feed",
                  vibeScore: _vibeScore,
                  vibeLevel: _vibeLevel,
                ),

                SizedBox(height: 16),

                // Post List
                Expanded(
                  child: posts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, size: 48, color: Colors.white38),
                              SizedBox(height: 16),
                              Text("No passion posts yet", style: TextStyle(color: Colors.white70)),
                              SizedBox(height: 8),
                              Text("Start sharing your journey!", style: TextStyle(color: Colors.white60, fontSize: 12)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: posts.length,
                          itemBuilder: (ctx, i) {
                            final post = posts[i];
                            return _PassionPostCard(
                              post: post,
                              onReact: _handleReaction,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// =============================================
/// PASSION POST CARD — With Tags & Reaction Bar
/// =============================================
class _PassionPostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final Function(String, String) onReact;

  _PassionPostCard({required this.post, required this.onReact});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: GlassCard(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author + Timestamp
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white12,
                    child: Text(
                      post['author'][0],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post['author'], style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(post['timestamp'], style: TextStyle(color: Colors.white60, fontSize: 11)),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Post Content
              Text(
                post['content'],
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              // Tags
              if (post['tags'] != null && (post['tags'] as List).isNotEmpty) ...[
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: (post['tags'] as List<String>).map((tag) {
                    return Chip(
                      label: Text(tag, style: TextStyle(fontSize: 11)),
                      backgroundColor: Colors.white10,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    );
                  }).toList(),
                ),
              ],

              SizedBox(height: 16),

              // Conscious Reaction Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _reactionBtn('Inspired', Icons.lightbulb, Colors.amber),
                  _reactionBtn('Neutral', Icons.remove_circle_outline, Colors.grey),
                  _reactionBtn('Questioning', Icons.help_outline, Colors.orange),
                  _reactionBtn('Supportive', Icons.favorite, Colors.pink),
                  _reactionBtn('Unclear', Icons.cloud_off, Colors.blueGrey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reactionBtn(String type, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => onReact(post['id'], type),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white10,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}

/// =============================================
/// HEADER WIDGET — Shared across feeds
/// =============================================
class _Header extends StatelessWidget {
  final String title;
  final int vibeScore;
  final String vibeLevel;

  _Header({required this.title, required this.vibeScore, required this.vibeLevel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Logo(),
          SizedBox(width: 12),
          Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Spacer(),
          VibeScoreBadge(score: vibeScore, level: vibeLevel),
        ],
      ),
    );
  }
}