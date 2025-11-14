class WisdomModel {
  final int wisdomPoints;
  final int trustScore;
  final WiserThinkerLevel level;
  final List<String> badges;
  final int emotionalReactions;
  final int thoughtfulReactions;
  final int factChecks;
  
  WisdomModel({
    this.wisdomPoints = 0,
    this.trustScore = 50,
    this.level = WiserThinkerLevel.impulsiveReactor,
    this.badges = const [],
    this.emotionalReactions = 0,
    this.thoughtfulReactions = 0,
    this.factChecks = 0,
  });
  
  double get trustScorePercentage => trustScore / 100;
  
  String get levelTitle {
    switch (level) {
      case WiserThinkerLevel.impulsiveReactor:
        return 'Impulsive Reactor';
      case WiserThinkerLevel.cautiousThinker:
        return 'Cautious Thinker';
      case WiserThinkerLevel.criticalAnalyst:
        return 'Critical Analyst';
      case WiserThinkerLevel.wiserThinker:
        return 'Wiser Thinker';
    }
  }
  
  String get levelEmoji {
    switch (level) {
      case WiserThinkerLevel.impulsiveReactor:
        return '⚡';
      case WiserThinkerLevel.cautiousThinker:
        return '🤔';
      case WiserThinkerLevel.criticalAnalyst:
        return '🔍';
      case WiserThinkerLevel.wiserThinker:
        return '🧠';
    }
  }
  
  WisdomModel copyWith({
    int? wisdomPoints,
    int? trustScore,
    WiserThinkerLevel? level,
    List<String>? badges,
    int? emotionalReactions,
    int? thoughtfulReactions,
    int? factChecks,
  }) {
    return WisdomModel(
      wisdomPoints: wisdomPoints ?? this.wisdomPoints,
      trustScore: trustScore ?? this.trustScore,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      emotionalReactions: emotionalReactions ?? this.emotionalReactions,
      thoughtfulReactions: thoughtfulReactions ?? this.thoughtfulReactions,
      factChecks: factChecks ?? this.factChecks,
    );
  }
}

enum WiserThinkerLevel {
  impulsiveReactor,    // 0-100 points
  cautiousThinker,     // 100-500 points
  criticalAnalyst,     // 500-2000 points
  wiserThinker,        // 2000+ points
}

enum ReactionType {
  emotional,  // Costs energy
  neutral,    // Earns wisdom
  factCheck,  // Earns more wisdom
}

class Reaction {
  final String emoji;
  final String label;
  final ReactionType type;
  final int wisdomPoints;
  
  const Reaction({
    required this.emoji,
    required this.label,
    required this.type,
    this.wisdomPoints = 0,
  });
}

class ReactionOptions {
  // Emotional reactions (cost energy)
  static const emotional = [
    Reaction(emoji: '😍', label: 'Love it', type: ReactionType.emotional),
    Reaction(emoji: '😂', label: 'Funny', type: ReactionType.emotional),
    Reaction(emoji: '😡', label: 'Angry', type: ReactionType.emotional),
    Reaction(emoji: '😢', label: 'Sad', type: ReactionType.emotional),
  ];
  
  // Neutral reactions (earn wisdom)
  static const neutral = [
    Reaction(emoji: '🤔', label: 'Need more info', type: ReactionType.neutral, wisdomPoints: 3),
    Reaction(emoji: '📚', label: 'Want to learn', type: ReactionType.neutral, wisdomPoints: 3),
    Reaction(emoji: '💭', label: 'Let me think', type: ReactionType.neutral, wisdomPoints: 5),
  ];
  
  // Fact-checking reactions (earn more wisdom)
  static const factCheck = [
    Reaction(emoji: '🔍', label: 'Fact-checking', type: ReactionType.factCheck, wisdomPoints: 10),
    Reaction(emoji: '✅', label: 'Verified True', type: ReactionType.factCheck, wisdomPoints: 15),
    Reaction(emoji: '❌', label: 'This is False', type: ReactionType.factCheck, wisdomPoints: 15),
    Reaction(emoji: '⚠️', label: 'Misleading', type: ReactionType.factCheck, wisdomPoints: 10),
  ];
}