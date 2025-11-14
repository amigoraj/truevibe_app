// lib/screens/discover_screen.dart
import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/logo.dart';
import '../widgets/vibe_score_badge.dart';
import '../utils/gradient_background.dart';
import '../services/api_client.dart';
import 'fun_feed_screen.dart';
import 'passion_feed_screen.dart';

/// =============================================
/// DISCOVER SCREEN — Dual Feed Toggle (Fun vs Passion)
/// =============================================
class DiscoverScreen extends StatefulWidget {
  final Map<String, dynamic>? profile;
  const DiscoverScreen({super.key, this.profile});

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  // Feed type: 'fun' or 'passion'
  String _feedType = 'fun';

  // Sample posts (replace with API later)
  List<Map<String, dynamic>> posts = [];

  // Vibe score & level
  int _vibeScore = 42;
  String _vibeLevel = "Aware Explorer";

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  /// Load posts based on feed type
  void _loadPosts() {
    setState(() {
      posts = _feedType == 'fun'
          ? [
              {
                'id': 'f1',
                'content': 'Just danced like no one’s watching!',
                'author': 'Luna',
                'timestamp': '10m ago',
                'type': 'fun',
              },
              {
                'id': 'f2',
                'content': 'Tried a new coffee art — it’s a heart!',
                'author': 'Leo',
                'timestamp': '1h ago',
                'type': 'fun',
              },
            ]
          : [
              {
                'id': 'p1',
                'content': 'Just finished a deep dive into AI ethics. Mind blown.',
                'author': 'Alex',
                'timestamp': '2h ago',
                'type': 'passion',
              },
              {
                'id': 'p2',
                'content': 'Studying how to spot fake news in 2025.',
                'author': 'Aisha',
                'timestamp': '5h ago',
                'type': 'passion',
              },
            ];
    });
  }

  /// Handle reaction → backend + update vibe
  Future<void> _handleReaction(String postId, String type) async {
    final res = await ApiClient.react(postId, type);
    if (res != null) {
      setState(() {
        _vibeScore = res['vibeScore'] ?? _vibeScore;
        _vibeLevel = res['vibeLevel'] ?? _vibeLevel;
      });
    }

    if (type == 'Questioning' || type == 'Unclear') {
      _showFactTip();
    }
  }

  /// Show fact-checking tip
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text("Got it!"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile ?? {'name': 'You', 'goal': ''};

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Logo(),
                      const SizedBox(width: 12),
                      const Text("Discover", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      VibeScoreBadge(score: _vibeScore, level: _vibeLevel),
                    ],
                  ),
                ),

                // DUAL FEED TOGGLE
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      _tab("Fun", _feedType == 'fun', Icons.celebration),
                      _tab("Passion", _feedType == 'passion', Icons.auto_awesome),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // User mini-profile
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 22, backgroundColor: Colors.white12, child: Icon(Icons.person)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(profile['goal'], style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Post List
                Expanded(
                  child: posts.isEmpty
                      ? Center(
                          child: Text(
                            _feedType == 'fun' ? "No fun posts yet!" : "No passion posts yet!",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: posts.length,
                          itemBuilder: (ctx, i) {
                            final post = posts[i];
                            return _DiscoverPostCard(post: post, onReact: _handleReaction);
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

  /// Toggle tab
  Widget _tab(String label, bool active, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _feedType = active ? _feedType : label.toLowerCase();
            _loadPosts();
          });
        },
        child: AnimatedContainer(
          duration: 300.ms,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: active ? const Color(0xFF7B2FF7) : Colors.white),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: active ? const Color(0xFF7B2FF7) : Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

/// =============================================
/// DISCOVER POST CARD — Unified for both feeds
/// =============================================
class _DiscoverPostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final Function(String, String) onReact;

  const _DiscoverPostCard({required this.post, required this.onReact});

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
              // Author + Time
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white12,
                    child: Text(post['author'][0], style: const TextStyle(fontWeight: FontWeight.bold)),
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

              // Content
              Text(post['content'], style: const TextStyle(fontSize: 16, height: 1.5)),

              const SizedBox(height: 16),

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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white10,
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 15)],
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}