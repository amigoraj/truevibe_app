// lib/widgets/educational_dialog.dart
// This dialog appears after every reaction to teach users about their behavior

import 'package:flutter/material.dart';
import '../models/reaction_model.dart';
import '../services/reaction_service.dart';

class EducationalDialog extends StatefulWidget {
  final ReactionType reaction;
  final VoidCallback onClose;
  
  const EducationalDialog({
    Key? key,
    required this.reaction,
    required this.onClose,
  }) : super(key: key);

  @override
  State<EducationalDialog> createState() => _EducationalDialogState();
}

class _EducationalDialogState extends State<EducationalDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  final ReactionService _reactionService = ReactionService();
  
  @override
  void initState() {
    super.initState();
    
    // Setup animations for the dialog
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  // Get color based on reaction category
  Color _getCategoryColor() {
    switch (widget.reaction.category) {
      case 'wisdom':
        return Colors.blue;
      case 'encourage':
        return Colors.green;
      case 'fun':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  // Get category icon
  IconData _getCategoryIcon() {
    switch (widget.reaction.category) {
      case 'wisdom':
        return Icons.psychology;
      case 'encourage':
        return Icons.favorite;
      case 'fun':
        return Icons.celebration;
      default:
        return Icons.emoji_emotions;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();
    final behaviorPercentages = _reactionService.getBehaviorPercentages();
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated emoji
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        categoryColor.withOpacity(0.8),
                        categoryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: categoryColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.reaction.emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Title
              Text(
                'Great Choice!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: categoryColor,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Reaction name
              Text(
                'You reacted with ${widget.reaction.name}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Educational message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: categoryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: categoryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Why this matters:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: categoryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.reaction.educationalMessage,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[800],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Points awarded
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber[400]!,
                      Colors.orange[400]!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.stars,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        Text(
                          '+${widget.reaction.points}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Wisdom Points',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Behavior insights
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Behavior Pattern:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBehaviorBar(
                      'Critical Thinking',
                      behaviorPercentages['wisdom']!,
                      Colors.blue,
                      widget.reaction.category == 'wisdom',
                    ),
                    const SizedBox(height: 6),
                    _buildBehaviorBar(
                      'Supporting Others',
                      behaviorPercentages['encourage']!,
                      Colors.green,
                      widget.reaction.category == 'encourage',
                    ),
                    const SizedBox(height: 6),
                    _buildBehaviorBar(
                      'Joy & Balance',
                      behaviorPercentages['fun']!,
                      Colors.orange,
                      widget.reaction.category == 'fun',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: categoryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue Learning',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildBehaviorBar(String label, double percentage, Color color, bool isGrowing) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              if (isGrowing) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_upward,
                  size: 12,
                  color: color,
                ),
              ],
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.7), color],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}