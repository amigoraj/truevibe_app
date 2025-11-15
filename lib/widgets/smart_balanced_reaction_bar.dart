import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Smart Balanced Reaction System for TrueVibe
/// 
/// This component displays all 15 emojis on every post but intelligently
/// suggests which reactions are most appropriate based on post type.
/// It tracks user balance across three categories:
/// - Wisdom Reactions (critical thinking, learning)
/// - Encouragement Reactions (support, motivation)
/// - Fun Reactions (joy, celebration)
/// 
/// Users earn bonus points for maintaining healthy balance and receive
/// gentle nudges if they're using one category too much.

class SmartBalancedReactionBar extends StatefulWidget {
  final String postId;
  final String postType; // 'fun', 'passion', 'news', 'motivation', etc.
  final Function(String reactionType, int points) onReact;
  
  const SmartBalancedReactionBar({
    Key? key,
    required this.postId,
    required this.postType,
    required this.onReact,
  }) : super(key: key);

  @override
  State<SmartBalancedReactionBar> createState() => _SmartBalancedReactionBarState();
}

class _SmartBalancedReactionBarState extends State<SmartBalancedReactionBar> {
  String? _selectedReaction;
  
  // User's current balance (would come from UserService in real app)
  static double _wisdomBalance = 0.35; // 35% wisdom reactions
  static double _encouragementBalance = 0.30; // 30% encouragement
  static double _funBalance = 0.35; // 35% fun
  
  // All 15 reactions organized by category
  final Map<String, List<Map<String, dynamic>>> _reactions = {
    'wisdom': [
      {'emoji': '🧠', 'label': 'Insightful', 'points': 15},
      {'emoji': '🤔', 'label': 'Critical', 'points': 15},
      {'emoji': '💡', 'label': 'Enlightening', 'points': 14},
      {'emoji': '📚', 'label': 'Educational', 'points': 14},
      {'emoji': '🎯', 'label': 'Focused', 'points': 13},
    ],
    'encouragement': [
      {'emoji': '💪', 'label': 'Motivating', 'points': 12},
      {'emoji': '🌟', 'label': 'Inspiring', 'points': 12},
      {'emoji': '❤️', 'label': 'Heartfelt', 'points': 11},
      {'emoji': '🙏', 'label': 'Grateful', 'points': 11},
      {'emoji': '👏', 'label': 'Applause', 'points': 10},
    ],
    'fun': [
      {'emoji': '😊', 'label': 'Uplifting', 'points': 10},
      {'emoji': '🎉', 'label': 'Celebratory', 'points': 10},
      {'emoji': '😂', 'label': 'Amusing', 'points': 8},
      {'emoji': '🔥', 'label': 'Fire', 'points': 9},
      {'emoji': '✨', 'label': 'Amazing', 'points': 9},
    ],
  };
  
  // Intelligent suggestions based on post type
  List<String> _getSuggestedCategories() {
    switch (widget.postType) {
      case 'news':
      case 'educational':
      case 'research':
        return ['wisdom', 'encouragement'];
      case 'achievement':
      case 'milestone':
        return ['encouragement', 'fun'];
      case 'funny':
      case 'meme':
      case 'entertainment':
        return ['fun', 'encouragement'];
      case 'motivation':
      case 'inspiration':
        return ['encouragement', 'wisdom'];
      default:
        return ['wisdom', 'encouragement', 'fun'];
    }
  }
  
  bool _isCategorySuggested(String category) {
    return _getSuggestedCategories().contains(category);
  }
  
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'wisdom':
        return const Color(0xFF8B5CF6);
      case 'encouragement':
        return const Color(0xFF10B981);
      case 'fun':
        return const Color(0xFFF59E0B);
      default:
        return Colors.grey;
    }
  }
  
  String _getCategoryLabel(String category) {
    switch (category) {
      case 'wisdom':
        return 'Wisdom';
      case 'encouragement':
        return 'Encouragement';
      case 'fun':
        return 'Fun';
      default:
        return '';
    }
  }
  
  void _handleReaction(String category, Map<String, dynamic> reaction) {
    setState(() {
      _selectedReaction = reaction['label'];
    });
    
    // Update balance (in real app, this would call UserService)
    _updateBalance(category);
    
    // Calculate points with balance bonus
    int basePoints = reaction['points'] as int;
    int bonusPoints = _calculateBalanceBonus();
    int totalPoints = basePoints + bonusPoints;
    
    // Notify parent
    widget.onReact(reaction['label'] as String, totalPoints);
    
    // Show educational moment with balance feedback
    _showEducationalMoment(
      category,
      reaction['emoji'] as String,
      reaction['label'] as String,
      totalPoints,
      bonusPoints,
    );
  }
  
  void _updateBalance(String category) {
    // Simulate balance update (in real app, would persist to backend)
    const updateAmount = 0.02; // Each reaction shifts balance by 2%
    
    setState(() {
      if (category == 'wisdom') {
        _wisdomBalance = math.min(1.0, _wisdomBalance + updateAmount);
        _encouragementBalance = math.max(0.0, _encouragementBalance - updateAmount / 2);
        _funBalance = math.max(0.0, _funBalance - updateAmount / 2);
      } else if (category == 'encouragement') {
        _encouragementBalance = math.min(1.0, _encouragementBalance + updateAmount);
        _wisdomBalance = math.max(0.0, _wisdomBalance - updateAmount / 2);
        _funBalance = math.max(0.0, _funBalance - updateAmount / 2);
      } else {
        _funBalance = math.min(1.0, _funBalance + updateAmount);
        _wisdomBalance = math.max(0.0, _wisdomBalance - updateAmount / 2);
        _encouragementBalance = math.max(0.0, _encouragementBalance - updateAmount / 2);
      }
      
      // Normalize to ensure they sum to 1.0
      double total = _wisdomBalance + _encouragementBalance + _funBalance;
      _wisdomBalance /= total;
      _encouragementBalance /= total;
      _funBalance /= total;
    });
  }
  
  int _calculateBalanceBonus() {
    // Perfect balance = 33.33% each category
    // Calculate how close user is to perfect balance
    double wisdomDiff = (_wisdomBalance - 0.333).abs();
    double encouragementDiff = (_encouragementBalance - 0.333).abs();
    double funDiff = (_funBalance - 0.333).abs();
    double totalDiff = wisdomDiff + encouragementDiff + funDiff;
    
    // Less difference = better balance = more bonus
    // Max bonus of 10 points for perfect balance
    if (totalDiff < 0.1) return 10;
    if (totalDiff < 0.2) return 7;
    if (totalDiff < 0.3) return 5;
    if (totalDiff < 0.4) return 3;
    return 0;
  }
  
  String _getBalanceStatus() {
    double maxBalance = math.max(_wisdomBalance, math.max(_encouragementBalance, _funBalance));
    
    if (maxBalance > 0.6) {
      if (_wisdomBalance > 0.6) return 'too_much_wisdom';
      if (_encouragementBalance > 0.6) return 'too_much_encouragement';
      if (_funBalance > 0.6) return 'too_much_fun';
    }
    
    if (_wisdomBalance > 0.28 && _wisdomBalance < 0.38 &&
        _encouragementBalance > 0.28 && _encouragementBalance < 0.38 &&
        _funBalance > 0.28 && _funBalance < 0.38) {
      return 'perfect_balance';
    }
    
    return 'good_balance';
  }
  
  void _showEducationalMoment(
    String category,
    String emoji,
    String label,
    int totalPoints,
    int bonusPoints,
  ) {
    final educationalMessages = {
      'Insightful': 'Critical thinking reactions help surface valuable content.',
      'Critical': 'Thoughtful analysis makes our community smarter together.',
      'Enlightening': 'Sharing knowledge creates a ripple effect of learning.',
      'Educational': 'Educational content gets prioritized to help everyone grow.',
      'Focused': 'Goal-oriented reactions build a purposeful community.',
      'Motivating': 'Your encouragement inspires others to keep pushing forward.',
      'Inspiring': 'Inspiration creates momentum for positive change.',
      'Heartfelt': 'Genuine connection strengthens our community bonds.',
      'Grateful': 'Gratitude multiplies the positive impact of good content.',
      'Applause': 'Celebrating others creates a culture of achievement.',
      'Uplifting': 'Positivity spreads joy throughout the community.',
      'Celebratory': 'Celebrating wins motivates continued excellence.',
      'Amusing': 'Healthy humor brings balance to serious learning.',
      'Fire': 'Excitement creates energy that drives engagement.',
      'Amazing': 'Wonder and awe expand our perspective.',
    };
    
    String balanceStatus = _getBalanceStatus();
    String balanceMessage = '';
    Color balanceColor = const Color(0xFF10B981);
    
    if (balanceStatus == 'perfect_balance') {
      balanceMessage = '🎯 Perfect Balance! You\'re using all reaction types equally.';
      balanceColor = const Color(0xFF10B981);
    } else if (balanceStatus == 'too_much_wisdom') {
      balanceMessage = '⚖️ Try using more Fun or Encouragement reactions to balance your engagement.';
      balanceColor = const Color(0xFFF59E0B);
    } else if (balanceStatus == 'too_much_encouragement') {
      balanceMessage = '⚖️ Consider using more Wisdom or Fun reactions to diversify your engagement.';
      balanceColor = const Color(0xFFF59E0B);
    } else if (balanceStatus == 'too_much_fun') {
      balanceMessage = '⚖️ Balance your fun with Wisdom or Encouragement reactions for more impact.';
      balanceColor = const Color(0xFFF59E0B);
    }
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getCategoryColor(category).withOpacity(0.95),
                _getCategoryColor(category).withOpacity(0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _getCategoryColor(category).withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '+$totalPoints Wisdom Points!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (bonusPoints > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '🎁 Balance Bonus: +$bonusPoints',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                educationalMessages[label] ?? 'Great choice! Building a better community.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              if (balanceMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        balanceMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      _buildMiniBalanceMeter(),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _getCategoryColor(category),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMiniBalanceMeter() {
    return Row(
      children: [
        Expanded(
          flex: (_wisdomBalance * 100).round(),
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                bottomLeft: Radius.circular(3),
              ),
            ),
          ),
        ),
        Expanded(
          flex: (_encouragementBalance * 100).round(),
          child: Container(
            height: 6,
            color: const Color(0xFF10B981),
          ),
        ),
        Expanded(
          flex: (_funBalance * 100).round(),
          child: Container(
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(3),
                bottomRight: Radius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'How does this make you feel?',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: _showBalanceDetail,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.balance,
                        color: Colors.white70,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getBalanceStatus() == 'perfect_balance' ? 'Perfect!' : 'Balance',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Wisdom Reactions
          _buildCategorySection('wisdom'),
          
          const SizedBox(height: 12),
          
          // Encouragement Reactions
          _buildCategorySection('encouragement'),
          
          const SizedBox(height: 12),
          
          // Fun Reactions
          _buildCategorySection('fun'),
        ],
      ),
    );
  }
  
  Widget _buildCategorySection(String category) {
    bool isSuggested = _isCategorySuggested(category);
    Color categoryColor = _getCategoryColor(category);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _getCategoryLabel(category),
              style: TextStyle(
                color: categoryColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isSuggested) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: categoryColor.withOpacity(0.4),
                  ),
                ),
                child: const Text(
                  'Suggested',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _reactions[category]!.map((reaction) {
              return _buildReactionButton(
                category,
                reaction,
                isSuggested,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildReactionButton(
    String category,
    Map<String, dynamic> reaction,
    bool isSuggested,
  ) {
    Color categoryColor = _getCategoryColor(category);
    bool isSelected = _selectedReaction == reaction['label'];
    
    return GestureDetector(
      onTap: () => _handleReaction(category, reaction),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [categoryColor, categoryColor.withOpacity(0.7)],
                )
              : LinearGradient(
                  colors: [
                    categoryColor.withOpacity(isSuggested ? 0.25 : 0.15),
                    categoryColor.withOpacity(isSuggested ? 0.15 : 0.05),
                  ],
                ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.white.withOpacity(0.5)
                : categoryColor.withOpacity(isSuggested ? 0.5 : 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSuggested
              ? [
                  BoxShadow(
                    color: categoryColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Text(
              reaction['emoji'] as String,
              style: TextStyle(fontSize: isSelected ? 26 : 22),
            ),
            const SizedBox(height: 3),
            Text(
              reaction['label'] as String,
              style: TextStyle(
                color: isSelected ? Colors.white : categoryColor,
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
            if (isSuggested) ...[
              const SizedBox(height: 2),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: categoryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  void _showBalanceDetail() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1F2937).withOpacity(0.95),
                const Color(0xFF111827).withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your Reaction Balance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Maintain balance for maximum wisdom points',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildBalanceStat(
                'Wisdom',
                _wisdomBalance,
                const Color(0xFF8B5CF6),
                '🧠',
              ),
              const SizedBox(height: 16),
              _buildBalanceStat(
                'Encouragement',
                _encouragementBalance,
                const Color(0xFF10B981),
                '💪',
              ),
              const SizedBox(height: 16),
              _buildBalanceStat(
                'Fun',
                _funBalance,
                const Color(0xFFF59E0B),
                '😊',
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: Color(0xFFF59E0B),
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Balance Tip',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getBalanceStatus() == 'perfect_balance'
                          ? 'Perfect balance! Keep it up to earn maximum bonus points on every reaction.'
                          : 'Try to keep each category between 25-40% for perfect balance and bonus points.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Got it!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildBalanceStat(String label, double value, Color color, String emoji) {
    int percentage = (value * 100).round();
    bool isOptimal = percentage >= 25 && percentage <= 40;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Text(
              '$percentage%',
              style: TextStyle(
                color: isOptimal ? const Color(0xFF10B981) : Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (isOptimal) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.check_circle,
                color: Color(0xFF10B981),
                size: 16,
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}