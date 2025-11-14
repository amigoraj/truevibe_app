import 'package:flutter/material.dart';
import '../../models/wisdom_model.dart';
import '../../widgets/wisdom_badge.dart';

class WisdomDashboardScreen extends StatelessWidget {
  const WisdomDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with real user data
    final wisdom = WisdomModel(
      wisdomPoints: 350,
      trustScore: 75,
      level: WiserThinkerLevel.cautiousThinker,
      badges: ['Question Asker', 'Fact Finder'],
      emotionalReactions: 45,
      thoughtfulReactions: 89,
      factChecks: 23,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8B5CF6),
                      Color(0xFFEC4899),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Wisdom Dashboard',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Track your critical thinking journey',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),
                        WisdomBadge(wisdom: wisdom, showDetails: true),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDailyChallenge(),
                  const SizedBox(height: 20),
                  _buildProgressToNextLevel(wisdom),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Badges',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBadgesGrid(wisdom.badges),
                  const SizedBox(height: 20),
                  const Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLeaderboard(),
                  const SizedBox(height: 20),
                  const Text(
                    'Trust Indicators',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTrustIndicators(wisdom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyChallenge() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Color(0xFF8B5CF6),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Wisdom Challenge',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Complete to earn bonus points',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildChallengeItem('Find 3 facts before reacting', 1, 3, 10),
          const SizedBox(height: 12),
          _buildChallengeItem('Fact-check 1 viral post', 0, 1, 15),
          const SizedBox(height: 12),
          _buildChallengeItem('Use neutral reaction 5 times', 3, 5, 5),
        ],
      ),
    );
  }

  Widget _buildChallengeItem(String title, int current, int total, int points) {
    final isComplete = current >= total;
    return Row(
      children: [
        Icon(
          isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isComplete ? Colors.green : Colors.grey,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  decoration: isComplete ? TextDecoration.lineThrough : null,
                  color: isComplete ? Colors.grey : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: current / total,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$current/$total',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '+$points',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressToNextLevel(WisdomModel wisdom) {
    int nextLevelPoints = 500;
    if (wisdom.level == WiserThinkerLevel.impulsiveReactor) {
      nextLevelPoints = 100;
    } else if (wisdom.level == WiserThinkerLevel.cautiousThinker) {
      nextLevelPoints = 500;
    } else if (wisdom.level == WiserThinkerLevel.criticalAnalyst) {
      nextLevelPoints = 2000;
    }

    final pointsNeeded = nextLevelPoints - wisdom.wisdomPoints;
    final progress = wisdom.wisdomPoints / nextLevelPoints;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.purple.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '🎯',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Next Level Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$pointsNeeded points to Critical Analyst',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% complete',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesGrid(List<String> earnedBadges) {
    final allBadges = [
      {'icon': '🤔', 'name': 'Question Asker', 'desc': 'Asked 10 clarifying questions'},
      {'icon': '🔍', 'name': 'Fact Finder', 'desc': 'Fact-checked 5 posts'},
      {'icon': '🧠', 'name': 'Critical Thinker', 'desc': 'Reached 500 wisdom points'},
      {'icon': '⭐', 'name': 'Community Educator', 'desc': 'Helped 20 people learn'},
      {'icon': '🎓', 'name': 'Truth Seeker', 'desc': 'Verified 10 claims'},
      {'icon': '🏆', 'name': 'Wisdom Master', 'desc': 'Reached Wiser Thinker level'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: allBadges.length,
      itemBuilder: (context, index) {
        final badge = allBadges[index];
        final isEarned = earnedBadges.contains(badge['name']);
        return _buildBadgeCard(
          badge['icon']!,
          badge['name']!,
          badge['desc']!,
          isEarned,
        );
      },
    );
  }

  Widget _buildBadgeCard(String icon, String name, String desc, bool isEarned) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEarned ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEarned ? const Color(0xFF8B5CF6) : Colors.grey.shade300,
          width: isEarned ? 2 : 1,
        ),
        boxShadow: isEarned
            ? [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: TextStyle(
              fontSize: 32,
              color: isEarned ? null : Colors.grey.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isEarned ? Colors.black : Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    final topUsers = [
      {'name': 'Sarah Chen', 'points': 2450, 'level': '🧠', 'rank': 1},
      {'name': 'John Martinez', 'points': 1850, 'level': '🔍', 'rank': 2},
      {'name': 'Emma Wilson', 'points': 1620, 'level': '🔍', 'rank': 3},
      {'name': 'You', 'points': 350, 'level': '🤔', 'rank': 47},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: topUsers.map((user) {
          final isCurrentUser = user['name'] == 'You';
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCurrentUser ? const Color(0xFF8B5CF6).withOpacity(0.1) : null,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: user['rank'] == 1
                        ? Colors.amber
                        : user['rank'] == 2
                            ? Colors.grey.shade400
                            : user['rank'] == 3
                                ? Colors.brown.shade400
                                : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '#${user['rank']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  user['level'] as String,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user['name'] as String,
                    style: TextStyle(
                      fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  '${user['points']} pts',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTrustIndicators(WisdomModel wisdom) {
    final indicators = [
      {'icon': Icons.check_circle, 'text': 'Fact-checks before sharing', 'active': true},
      {'icon': Icons.source, 'text': 'Provides sources', 'active': true},
      {'icon': Icons.edit, 'text': 'Corrects own mistakes', 'active': false},
      {'icon': Icons.school, 'text': 'Educates community', 'active': true},
      {'icon': Icons.sentiment_neutral, 'text': 'Uses neutral reactions', 'active': false},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: indicators.map((indicator) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  indicator['icon'] as IconData,
                  color: indicator['active'] as bool ? Colors.green : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    indicator['text'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: indicator['active'] as bool ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                if (indicator['active'] as bool)
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 18,
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}