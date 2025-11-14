// lib/services/reaction_service.dart
// This is the brain of the reaction system - tracks behavior and teaches users

import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/reaction_model.dart';

class ReactionService extends ChangeNotifier {
  // Singleton pattern so we have one instance across the app
  static final ReactionService _instance = ReactionService._internal();
  factory ReactionService() => _instance;
  ReactionService._internal();

  // Store all user reactions (in a real app, this would sync with backend)
  final List<UserReaction> _userReactions = [];
  
  // Track reaction counts per post
  final Map<String, PostReactionCounts> _postReactionCounts = {};
  
  // User's current wisdom points
  int _wisdomPoints = 0;
  int get wisdomPoints => _wisdomPoints;
  
  // Get user's reaction history
  List<UserReaction> get userReactions => List.unmodifiable(_userReactions);
  
  // Add a reaction and award points
  Future<void> addReaction(String postId, String userId, ReactionType reaction) async {
    // Create the reaction
    final userReaction = UserReaction(
      postId: postId,
      userId: userId,
      reaction: reaction,
      timestamp: DateTime.now(),
    );
    
    // Add to history
    _userReactions.add(userReaction);
    
    // Award points
    _wisdomPoints += reaction.points;
    
    // Update post reaction counts
    _updatePostReactionCount(postId, reaction.emoji);
    
    // Save to local storage (in real app)
    await _saveToStorage();
    
    // Notify listeners to update UI
    notifyListeners();
  }
  
  // Update reaction counts for a post
  void _updatePostReactionCount(String postId, String emoji) {
    if (!_postReactionCounts.containsKey(postId)) {
      _postReactionCounts[postId] = PostReactionCounts(
        postId: postId,
        counts: {},
      );
    }
    
    final counts = _postReactionCounts[postId]!.counts;
    counts[emoji] = (counts[emoji] ?? 0) + 1;
  }
  
  // Get reaction counts for a post
  PostReactionCounts? getPostReactionCounts(String postId) {
    return _postReactionCounts[postId];
  }
  
  // Check if user has already reacted to a post
  UserReaction? getUserReactionForPost(String postId, String userId) {
    try {
      return _userReactions.firstWhere(
        (r) => r.postId == postId && r.userId == userId,
      );
    } catch (e) {
      return null;
    }
  }
  
  // BEHAVIORAL ANALYSIS - This is the revolutionary part!
  
  // Calculate percentage of each reaction category
  Map<String, double> getBehaviorPercentages() {
    if (_userReactions.isEmpty) {
      return {'wisdom': 0, 'encourage': 0, 'fun': 0};
    }
    
    final wisdomCount = _userReactions
        .where((r) => r.reaction.category == 'wisdom')
        .length;
    final encourageCount = _userReactions
        .where((r) => r.reaction.category == 'encourage')
        .length;
    final funCount = _userReactions
        .where((r) => r.reaction.category == 'fun')
        .length;
    
    final total = _userReactions.length;
    
    return {
      'wisdom': (wisdomCount / total * 100),
      'encourage': (encourageCount / total * 100),
      'fun': (funCount / total * 100),
    };
  }
  
  // Determine user's personality type based on reaction patterns
  String getPersonalityType() {
    if (_userReactions.isEmpty || _userReactions.length < 5) {
      return '🌱 Developing - Keep reacting to discover your style!';
    }
    
    final percentages = getBehaviorPercentages();
    final wisdom = percentages['wisdom']!;
    final encourage = percentages['encourage']!;
    final fun = percentages['fun']!;
    
    // Check for balanced user (all categories within 15% of each other)
    final diff1 = (wisdom - encourage).abs();
    final diff2 = (wisdom - fun).abs();
    final diff3 = (encourage - fun).abs();
    
    if (diff1 < 15 && diff2 < 15 && diff3 < 15) {
      return '🌟 Well-Rounded - Perfect balance! This is ideal!';
    }
    
    // Check for dominant category
    if (wisdom > 50) {
      return '🧠 Intellectual - You love critical thinking!';
    }
    if (encourage > 50) {
      return '💚 Encourager - You support others beautifully!';
    }
    if (fun > 50) {
      return '😂 Entertainer - You spread joy and laughter!';
    }
    
    // Mixed types
    if (wisdom > encourage && wisdom > fun) {
      return '🎓 Truth Seeker - You value facts and critical thinking';
    }
    if (encourage > wisdom && encourage > fun) {
      return '🤝 Community Builder - You bring people together';
    }
    
    return '🌈 Explorer - Finding your unique style!';
  }
  
  // Get neutrality score (0-100, higher is better)
  // Measures resistance to echo chambers
  double getNeutralityScore() {
    if (_userReactions.isEmpty) return 50.0;
    
    final percentages = getBehaviorPercentages();
    final wisdom = percentages['wisdom']!;
    final encourage = percentages['encourage']!;
    final fun = percentages['fun']!;
    
    // Perfect balance is 33.3% each
    final idealBalance = 33.3;
    final wisdomDeviation = (wisdom - idealBalance).abs();
    final encourageDeviation = (encourage - idealBalance).abs();
    final funDeviation = (fun - idealBalance).abs();
    
    final totalDeviation = wisdomDeviation + encourageDeviation + funDeviation;
    
    // Convert deviation to score (less deviation = higher score)
    // Max deviation would be 133.3 (100% in one category)
    final score = 100 - (totalDeviation / 133.3 * 100);
    
    return score.clamp(0, 100);
  }
  
  // Check if user needs intervention (stuck in echo chamber or unhealthy pattern)
  Map<String, dynamic>? checkForIntervention() {
    if (_userReactions.length < 10) return null;
    
    final percentages = getBehaviorPercentages();
    final recentReactions = _userReactions.reversed.take(10).toList();
    
    // Check if user is only using one category
    if (percentages['fun']! > 80) {
      return {
        'type': 'entertainment_only',
        'title': '😂 You love fun content!',
        'message': 'We noticed 80% of your reactions are on entertainment. '
            'Try engaging with educational or motivational content too! '
            'Balanced users have higher wisdom scores and feel more fulfilled.',
        'suggestion': 'Try reacting to 3 Passion Feed posts this week!',
        'reward': '+50 bonus points',
      };
    }
    
    if (percentages['wisdom']! > 80) {
      return {
        'type': 'serious_only',
        'title': '🧠 You\'re very thoughtful!',
        'message': 'You engage deeply with serious topics (80% wisdom reactions). '
            'Remember to balance this with joy and supporting others! '
            'Laughter and encouragement are healthy too.',
        'suggestion': 'Try reacting 😂 to 5 fun posts this week!',
        'reward': '+50 bonus points',
      };
    }
    
    // Check for potential echo chamber (same reaction type repeatedly)
    if (recentReactions.length >= 5) {
      final firstReaction = recentReactions.first.reaction.emoji;
      final sameReactionCount = recentReactions
          .where((r) => r.reaction.emoji == firstReaction)
          .length;
      
      if (sameReactionCount >= 5) {
        return {
          'type': 'echo_chamber',
          'title': '⚠️ Pattern Detected',
          'message': 'You\'ve used the same reaction $firstReaction '
              'repeatedly. This might indicate you\'re in an echo chamber. '
              'Try exploring different perspectives!',
          'suggestion': 'Use varied reactions to show open-mindedness',
          'reward': '+100 points for diversity',
        };
      }
    }
    
    return null;
  }
  
  // Get achievements user has earned
  List<Map<String, dynamic>> getAchievements() {
    final achievements = <Map<String, dynamic>>[];
    
    // Reaction count achievements
    if (_userReactions.length >= 10) {
      achievements.add({
        'emoji': '🎯',
        'title': 'Getting Started',
        'description': 'Reacted 10 times',
        'earned': true,
      });
    }
    
    if (_userReactions.length >= 50) {
      achievements.add({
        'emoji': '⭐',
        'title': 'Active Member',
        'description': 'Reacted 50 times',
        'earned': true,
      });
    }
    
    if (_userReactions.length >= 100) {
      achievements.add({
        'emoji': '💎',
        'title': 'Super Active',
        'description': 'Reacted 100 times',
        'earned': true,
      });
    }
    
    // Wisdom achievements
    final wisdomCount = _userReactions
        .where((r) => r.reaction.category == 'wisdom')
        .length;
    
    if (wisdomCount >= 20) {
      achievements.add({
        'emoji': '🧠',
        'title': 'Critical Thinker',
        'description': 'Used wisdom reactions 20 times',
        'earned': true,
      });
    }
    
    // Encouragement achievements
    final encourageCount = _userReactions
        .where((r) => r.reaction.category == 'encourage')
        .length;
    
    if (encourageCount >= 20) {
      achievements.add({
        'emoji': '💚',
        'title': 'Supporter',
        'description': 'Encouraged others 20 times',
        'earned': true,
      });
    }
    
    // Balance achievement
    final neutrality = getNeutralityScore();
    if (neutrality >= 80 && _userReactions.length >= 30) {
      achievements.add({
        'emoji': '🌟',
        'title': 'Balanced Soul',
        'description': 'Maintained 80%+ neutrality score',
        'earned': true,
      });
    }
    
    return achievements;
  }
  
  // Save to local storage (mock - in real app use SharedPreferences)
  Future<void> _saveToStorage() async {
    // TODO: Implement with SharedPreferences or backend sync
    // For now, just keeping in memory
  }
  
  // Load from local storage
  Future<void> loadFromStorage() async {
    // TODO: Implement with SharedPreferences or backend sync
  }
  
  // Clear all data (for testing)
  void clearAll() {
    _userReactions.clear();
    _postReactionCounts.clear();
    _wisdomPoints = 0;
    notifyListeners();
  }
}