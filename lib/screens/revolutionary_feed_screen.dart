import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../widgets/smart_balanced_reaction_bar.dart';

/// Revolutionary TrueVibe Feed Screen
/// Features cutting-edge design with Smart Balanced Reaction System

class RevolutionaryFeedScreen extends StatefulWidget {
  const RevolutionaryFeedScreen({Key? key}) : super(key: key);

  @override
  State<RevolutionaryFeedScreen> createState() => _RevolutionaryFeedScreenState();
}

class _RevolutionaryFeedScreenState extends State<RevolutionaryFeedScreen>
    with TickerProviderStateMixin {
  late AnimationController _wisdomController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  
  int _dailyWisdomPoints = 0;
  int _streakDays = 7;
  bool _showWisdomGain = false;
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _wisdomController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _wisdomController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleReaction(String reactionType, int wisdomPoints) {
    setState(() {
      _dailyWisdomPoints += wisdomPoints;
      _showWisdomGain = true;
    });
    
    _wisdomController.forward(from: 0);
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showWisdomGain = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          _buildMainFeed(),
          _buildFloatingWisdomIndicator(),
          if (_showWisdomGain) _buildWisdomGainAnimation(),
          _buildStreakIndicator(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: FeedBackgroundPainter(
            animation: _particleController,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A0B2E).withOpacity(0.6),
                  const Color(0xFF0A0A0A),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainFeed() {
    return SafeArea(
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildGlassmorphicAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildStoryReel(),
                const SizedBox(height: 20),
                _buildDailyChallengeCard(),
                const SizedBox(height: 16),
              ],
            ),
          ),
          _buildFeedPosts(),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                      ).createShader(bounds),
                      child: const Text(
                        'TrueVibe',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _buildHeaderIcon(Icons.search),
                    const SizedBox(width: 12),
                    _buildHeaderIcon(Icons.notifications_none),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildStoryReel() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 8,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddStoryCard();
          }
          return _buildStoryCard(index);
        },
      ),
    );
  }

  Widget _buildAddStoryCard() {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your Story',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(int index) {
    final hasNewStory = index <= 3;
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: hasNewStory
                  ? const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                    )
                  : null,
              color: hasNewStory ? null : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasNewStory
                    ? Colors.transparent
                    : Colors.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white54,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'User $index',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyChallengeCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Challenge',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Spread positivity today',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Give 5 encouraging reactions to others',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '3/5',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.card_giftcard,
                  color: Color(0xFF8B5CF6),
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Reward: +500 Wisdom Points',
                  style: TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedPosts() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index % 5 == 0 && index > 0) {
            return _buildCommunityMissionCard();
          }
          return _buildImmersivePostCard(index);
        },
        childCount: 20,
      ),
    );
  }

  Widget _buildImmersivePostCard(int index) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPostHeader(index),
                _buildPersonalizedInsight(index),
                _buildPostContent(index),
                _buildSmartReactionBar(index),
                _buildPostStats(index),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostHeader(int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'User ${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.4),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            color: Color(0xFF10B981),
                            size: 12,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                const Text(
                  '2 hours ago • San Francisco',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalizedInsight(int index) {
    final insights = [
      {'icon': Icons.psychology, 'text': 'Matches your intellectual interests'},
      {'icon': Icons.favorite, 'text': 'From someone you vibe with'},
      {'icon': Icons.trending_up, 'text': 'Trending in your community'},
      {'icon': Icons.star, 'text': 'High wisdom content'},
    ];
    
    final insight = insights[index % insights.length];
    
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            insight['icon'] as IconData,
            color: const Color(0xFF8B5CF6),
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            insight['text'] as String,
            style: const TextStyle(
              color: Color(0xFF8B5CF6),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(int index) {
    final contentTypes = [
      'Just discovered an amazing perspective on mindful living. Sometimes the simplest practices create the biggest transformations. 🌟',
      'Finished reading an incredible book on human psychology today. The insights about habit formation are game-changing!',
      'Beautiful sunset walk reminded me how important it is to disconnect and appreciate the present moment.',
      'Had an enlightening conversation today about the power of positive reinforcement in communities. TrueVibe is really onto something special.',
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contentTypes[index % contentTypes.length],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF8B5CF6).withOpacity(0.3),
                  const Color(0xFF6366F1).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.image,
                color: Colors.white38,
                size: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartReactionBar(int index) {
    final postTypes = ['funny', 'motivation', 'educational', 'achievement'];
    final postType = postTypes[index % postTypes.length];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SmartBalancedReactionBar(
        postId: 'post_$index',
        postType: postType,
        onReact: _handleReaction,
      ),
    );
  }

  Widget _buildPostStats(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        children: [
          _buildStatItem(Icons.favorite, '${234 + index * 12}'),
          const SizedBox(width: 16),
          _buildStatItem(Icons.comment, '${45 + index * 3}'),
          const SizedBox(width: 16),
          _buildStatItem(Icons.share, '${12 + index}'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: Color(0xFF8B5CF6),
                  size: 14,
                ),
                SizedBox(width: 4),
                Text(
                  '+127',
                  style: TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String count) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          count,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityMissionCard() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Community Mission',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Join 2,847 others',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Help us reach 1M encouragement reactions this month! Together we\'re building a more positive community.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.73,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '730,000 / 1,000,000',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingWisdomIndicator() {
    return Positioned(
      top: 100,
      right: 16,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 + math.sin(_pulseController.value * 2 * math.pi) * 0.05,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_dailyWisdomPoints',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWisdomGainAnimation() {
    return Positioned(
      top: 120,
      right: 90,
      child: FadeTransition(
        opacity: _wisdomController,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0),
            end: const Offset(0, -2),
          ).animate(CurvedAnimation(
            parent: _wisdomController,
            curve: Curves.easeOut,
          )),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.5),
                  blurRadius: 15,
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  '15',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakIndicator() {
    return Positioned(
      top: 100,
      left: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF59E0B).withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              '$_streakDays',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Text(
              'Day Streak',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class FeedBackgroundPainter extends CustomPainter {
  final Animation<double> animation;

  FeedBackgroundPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 30; i++) {
      final x = (math.sin(animation.value * 2 * math.pi + i * 0.5) * 0.5 + 0.5) * size.width;
      final y = ((animation.value * 0.3 + i / 30) % 1.0) * size.height;
      final radius = 2.0 + (i % 4);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}