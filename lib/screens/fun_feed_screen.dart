// lib/screens/fun_feed_screen.dart
import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/logo.dart';
import '../widgets/vibe_score_badge.dart';
import '../widgets/reaction_bar.dart'; 
import '../utils/gradient_background.dart';
import '../services/api_client.dart';

/// =============================================
/// FUN FEED SCREEN — Light, Playful, Joyful
/// =============================================
class FunFeedScreen extends StatefulWidget {
  const FunFeedScreen({super.key});

  @override
  _FunFeedScreenState createState() => _FunFeedScreenState();
}

class _FunFeedScreenState extends State<FunFeedScreen> {
  // List of fun, lighthearted posts
  List<Map<String, dynamic>> posts = [];

  // User's current vibe score and level
  int _vibeScore = 42;
  String _vibeLevel = "Aware Explorer";

  @override
  void initState() {
    super.initState();
    _loadFunPosts();
  }

  /// Load sample fun posts (replace with API call later)
  void _loadFunPosts() {
    setState(() {
      posts = [
        {
          'id': 'f1',
          'content': 'Just danced like no one's watching!',
          'author': 'Luna',
          'timestamp': '10m ago',
          'tags': ['Dance', 'Joy', 'Fun'],
        },
        {
          'id': 'f2',
          'content': 'Tried a new coffee art — it's a heart!',
          'author': 'Leo',
          'timestamp': '1h ago',
          'tags': ['Coffee', 'Art', 'Morning'],
        },
        {
          'id': 'f3',
          'content': 'Sunset walk with my dog. Pure happiness.',
          'author': 'Maya',
          'timestamp': '3h ago',
          'tags': ['Nature', 'Pets', 'Walk'],
        },
        {
          'id': 'f4',
          'content': 'Laughed so hard I cried at this meme.',
          'author': 'Alex',
          'timestamp': '5h ago',
          'tags': ['Humor', 'Memes', 'Laugh'],
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
        backgroundColor: const Color(0xFFF8F4FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.orange),
            SizedBox(width: 8),
            Text("Fact Tip", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
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
            child: const Text("Got it!"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
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
          children: const [
            Icon(Icons.celebration, color: Colors.amber),
            SizedBox(width: 8),
            Text("Level Up! "),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          const GradientBackground(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header
                _Header(
                  title: "Fun Feed",
                  vibeScore: _vibeScore,
                  vibeLevel: _vibeLevel,
                ),

                const SizedBox(height: 16),

                // Post List
                Expanded(
                  child: posts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.celebration, size: 48, color: Colors.white38),
                              SizedBox(height: 16),
                              Text("No fun posts yet", style: TextStyle(color: Colors.white70)),
                              SizedBox(height: 8),
                              Text("Share the joy!", style: TextStyle(color: Colors.white60, fontSize: 12)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: posts.length,
                          itemBuilder: (ctx, i) {
                            final post = posts[i];
                            return _FunPostCard(
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
/// FUN POST CARD — With Tags & Smart Reaction Bar
/// =============================================
class _FunPostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final Function(String, String) onReact;

  const _FunPostCard({required this.post, required this.onReact});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post['author'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(post['timestamp'], style: const TextStyle(color: Colors.white60, fontSize: 11)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Post Content
              Text(
                post['content'],
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),

              // Tags
              if (post['tags'] != null && (post['tags'] as List).isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: (post['tags'] as List<String>).map((tag) {
                    return Chip(
                      label: Text(tag, style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.white10,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 16),

              // ============================================
              // NEW: Smart Reaction Bar with 15 emojis
              // Replaces the old 5-button reaction system
              // ============================================
              ReactionBar(
                postId: post['id'],
                postType: 'funny', // Fun feed posts are entertainment content
              ),
            ],
          ),
        ),
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

  const _Header({required this.title, required this.vibeScore, required this.vibeLevel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Logo(),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          VibeScoreBadge(
            score: vibeScore,
            level: vibeLevel,
          ),
        ],
      ),
    );
  }
}