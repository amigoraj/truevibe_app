// lib/models/reaction_model.dart
// This defines the structure of our revolutionary emotion-teaching reactions

class ReactionType {
  final String emoji;
  final String name;
  final String category; // 'wisdom', 'encourage', or 'fun'
  final int points;
  final String educationalMessage;
  
  const ReactionType({
    required this.emoji,
    required this.name,
    required this.category,
    required this.points,
    required this.educationalMessage,
  });
}

// All 15 reactions organized by category
class Reactions {
  // WISDOM REACTIONS - For news, educational content, serious topics
  // These teach critical thinking and fight misinformation
  static const List<ReactionType> wisdom = [
    ReactionType(
      emoji: '🤔',
      name: 'Thinking',
      category: 'wisdom',
      points: 5,
      educationalMessage: 'Shows thoughtfulness - you\'re considering multiple perspectives! This is how we combat echo chambers.',
    ),
    ReactionType(
      emoji: '✅',
      name: 'Verified',
      category: 'wisdom',
      points: 10,
      educationalMessage: 'Great! You fact-checked before reacting. This builds trust and fights fake news!',
    ),
    ReactionType(
      emoji: '🤝',
      name: 'Both Sides',
      category: 'wisdom',
      points: 15,
      educationalMessage: 'Amazing! Seeing both perspectives is rare. You\'re fighting echo chambers and building bridges!',
    ),
    ReactionType(
      emoji: '🚨',
      name: 'Question',
      category: 'wisdom',
      points: 5,
      educationalMessage: 'Good catch! Questioning suspicious content helps protect the community from misinformation.',
    ),
  ];

  // ENCOURAGEMENT REACTIONS - For motivational, personal achievement posts
  // These teach empathy and build supportive community
  static const List<ReactionType> encourage = [
    ReactionType(
      emoji: '💪',
      name: 'Strong',
      category: 'encourage',
      points: 5,
      educationalMessage: 'You\'re supporting others - this builds positive community! Your encouragement matters.',
    ),
    ReactionType(
      emoji: '🙏',
      name: 'Support',
      category: 'encourage',
      points: 5,
      educationalMessage: 'Showing empathy strengthens connections! You\'re making someone\'s day better.',
    ),
    ReactionType(
      emoji: '👏',
      name: 'Applause',
      category: 'encourage',
      points: 5,
      educationalMessage: 'Celebrating others creates a culture of encouragement! This is what healthy social media looks like.',
    ),
    ReactionType(
      emoji: '🌟',
      name: 'Inspiring',
      category: 'encourage',
      points: 7,
      educationalMessage: 'You\'re spreading positivity - keep it up! Inspiration is contagious.',
    ),
    ReactionType(
      emoji: '❤️',
      name: 'Love',
      category: 'encourage',
      points: 5,
      educationalMessage: 'Love and support make communities thrive! You\'re building meaningful connections.',
    ),
  ];

  // FUN REACTIONS - For entertainment, memes, lighthearted content
  // These teach balance and joy
  static const List<ReactionType> fun = [
    ReactionType(
      emoji: '😂',
      name: 'Haha',
      category: 'fun',
      points: 3,
      educationalMessage: 'Laughter is healthy! You\'re balanced and joyful. Keep enjoying life!',
    ),
    ReactionType(
      emoji: '🤣',
      name: 'LOL',
      category: 'fun',
      points: 3,
      educationalMessage: 'Enjoying fun content keeps you balanced! All work and no play isn\'t healthy.',
    ),
    ReactionType(
      emoji: '😅',
      name: 'Relatable',
      category: 'fun',
      points: 3,
      educationalMessage: 'Finding humor in shared experiences builds connection! We\'re all human.',
    ),
    ReactionType(
      emoji: '🔥',
      name: 'Fire',
      category: 'fun',
      points: 4,
      educationalMessage: 'Showing enthusiasm! You appreciate quality content and aren\'t afraid to express it.',
    ),
    ReactionType(
      emoji: '💯',
      name: 'Perfect',
      category: 'fun',
      points: 4,
      educationalMessage: 'You recognize excellence - great taste! Supporting quality content helps it spread.',
    ),
  ];

  // Get all reactions as a flat list
  static List<ReactionType> get all => [...wisdom, ...encourage, ...fun];
  
  // Get reactions by category name
  static List<ReactionType> getByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'wisdom':
        return wisdom;
      case 'encourage':
        return encourage;
      case 'fun':
        return fun;
      default:
        return all;
    }
  }
}

// Model to track a user's reaction to a post
class UserReaction {
  final String postId;
  final String userId;
  final ReactionType reaction;
  final DateTime timestamp;
  
  UserReaction({
    required this.postId,
    required this.userId,
    required this.reaction,
    required this.timestamp,
  });
  
  Map<String, dynamic> toJson() => {
    'postId': postId,
    'userId': userId,
    'reactionEmoji': reaction.emoji,
    'reactionName': reaction.name,
    'reactionCategory': reaction.category,
    'points': reaction.points,
    'timestamp': timestamp.toIso8601String(),
  };
  
  factory UserReaction.fromJson(Map<String, dynamic> json) {
    // Find matching reaction from our predefined list
    final matchingReaction = Reactions.all.firstWhere(
      (r) => r.emoji == json['reactionEmoji'],
      orElse: () => Reactions.fun[0], // Default fallback
    );
    
    return UserReaction(
      postId: json['postId'],
      userId: json['userId'],
      reaction: matchingReaction,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

// Model to track reaction counts on a post
class PostReactionCounts {
  final String postId;
  final Map<String, int> counts; // emoji -> count
  
  PostReactionCounts({
    required this.postId,
    required this.counts,
  });
  
  // Get total reaction count
  int get total => counts.values.fold(0, (sum, count) => sum + count);
  
  // Get count for specific emoji
  int getCount(String emoji) => counts[emoji] ?? 0;
}