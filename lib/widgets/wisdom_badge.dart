import 'package:flutter/material.dart';
import '../models/wisdom_model.dart';

class WisdomBadge extends StatelessWidget {
  final WisdomModel wisdom;
  final bool showDetails;
  
  const WisdomBadge({
    Key? key,
    required this.wisdom,
    this.showDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showDetails) {
      return _buildCompactBadge();
    }
    return _buildDetailedBadge(context);
  }

  Widget _buildCompactBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: _getLevelGradient(),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getLevelColor().withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            wisdom.levelEmoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 6),
          Text(
            '${wisdom.wisdomPoints}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: _getLevelGradient(),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getLevelColor().withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                wisdom.levelEmoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wisdom.levelTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${wisdom.wisdomPoints} Wisdom Points',
                      style: const TextStyle(
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
            'Trust Score',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: wisdom.trustScorePercentage,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${wisdom.trustScore}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('🤔', '${wisdom.thoughtfulReactions}', 'Thoughtful'),
              _buildStat('🔍', '${wisdom.factChecks}', 'Fact Checks'),
              _buildStat('⚡', '${wisdom.emotionalReactions}', 'Emotional'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String emoji, String value, String label) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  LinearGradient _getLevelGradient() {
    switch (wisdom.level) {
      case WiserThinkerLevel.impulsiveReactor:
        return LinearGradient(
          colors: [Colors.grey.shade600, Colors.grey.shade800],
        );
      case WiserThinkerLevel.cautiousThinker:
        return const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
        );
      case WiserThinkerLevel.criticalAnalyst:
        return const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
        );
      case WiserThinkerLevel.wiserThinker:
        return const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
        );
    }
  }

  Color _getLevelColor() {
    switch (wisdom.level) {
      case WiserThinkerLevel.impulsiveReactor:
        return Colors.grey.shade700;
      case WiserThinkerLevel.cautiousThinker:
        return const Color(0xFF3B82F6);
      case WiserThinkerLevel.criticalAnalyst:
        return const Color(0xFF8B5CF6);
      case WiserThinkerLevel.wiserThinker:
        return const Color(0xFFEC4899);
    }
  }
}