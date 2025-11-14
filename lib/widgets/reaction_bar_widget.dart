// lib/widgets/reaction_bar_widget.dart
// This is the reusable component you add to ANY post to give it reactions!

import 'package:flutter/material.dart';
import '../models/reaction_model.dart';
import '../services/reaction_service.dart';
import 'educational_dialog.dart';

class ReactionBar extends StatefulWidget {
  final String postId;
  final String postType; // 'news', 'motivation', 'funny', 'general'
  final String? suggestedCategory; // Optional: 'wisdom', 'encourage', 'fun'
  
  const ReactionBar({
    Key? key,
    required this.postId,
    required this.postType,
    this.suggestedCategory,
  }) : super(key: key);

  @override
  State<ReactionBar> createState() => _ReactionBarState();
}

class _ReactionBarState extends State<ReactionBar> {
  final ReactionService _reactionService = ReactionService();
  UserReaction? _userReaction;
  PostReactionCounts? _postCounts;
  
  @override
  void initState() {
    super.initState();
    _loadReactionData();
  }
  
  void _loadReactionData() {
    // Check if current user already reacted
    _userReaction = _reactionService.getUserReactionForPost(
      widget.postId,
      'current_user_id', // TODO: Replace with actual user ID from auth
    );
    
    // Load reaction counts for this post
    _postCounts = _reactionService.getPostReactionCounts(widget.postId);
    
    setState(() {});
  }
  
  // Determine which reactions to show based on post type
  List<ReactionType> _getSuggestedReactions() {
    // If specific category suggested, use that
    if (widget.suggestedCategory != null) {
      return Reactions.getByCategory(widget.suggestedCategory!);
    }
    
    // Otherwise, intelligently suggest based on post type
    switch (widget.postType.toLowerCase()) {
      case 'news':
      case 'educational':
      case 'serious':
        return Reactions.wisdom;
      case 'motivation':
      case 'achievement':
      case 'personal':
        return Reactions.encourage;
      case 'funny':
      case 'meme':
      case 'entertainment':
        return Reactions.fun;
      default:
        // For general posts, show all reactions
        return Reactions.all;
    }
  }
  
  // Get category name for display
  String _getCategoryDisplayName() {
    final reactions = _getSuggestedReactions();
    if (reactions == Reactions.wisdom) return 'Wisdom';
    if (reactions == Reactions.encourage) return 'Encouragement';
    if (reactions == Reactions.fun) return 'Fun';
    return 'All';
  }
  
  // Get category color
  Color _getCategoryColor() {
    final reactions = _getSuggestedReactions();
    if (reactions == Reactions.wisdom) return Colors.blue;
    if (reactions == Reactions.encourage) return Colors.green;
    if (reactions == Reactions.fun) return Colors.orange;
    return Colors.grey;
  }
  
  // Handle reaction tap
  Future<void> _handleReactionTap(ReactionType reaction) async {
    // Add the reaction
    await _reactionService.addReaction(
      widget.postId,
      'current_user_id', // TODO: Replace with actual user ID
      reaction,
    );
    
    // Show educational dialog
    if (mounted) {
      await showDialog(
        context: context,
        builder: (context) => EducationalDialog(
          reaction: reaction,
          onClose: () {
            Navigator.of(context).pop();
            _loadReactionData(); // Refresh reaction data
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestedReactions = _getSuggestedReactions();
    final categoryColor = _getCategoryColor();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header showing suggested category
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 16,
                color: categoryColor,
              ),
              const SizedBox(width: 6),
              Text(
                'Suggested: ${_getCategoryDisplayName()} reactions',
                style: TextStyle(
                  fontSize: 12,
                  color: categoryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Reaction buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestedReactions.map((reaction) {
              final count = _postCounts?.getCount(reaction.emoji) ?? 0;
              final isUserReaction = _userReaction?.reaction.emoji == reaction.emoji;
              
              return _ReactionButton(
                reaction: reaction,
                count: count,
                isSelected: isUserReaction,
                categoryColor: categoryColor,
                onTap: () => _handleReactionTap(reaction),
              );
            }).toList(),
          ),
          
          // Show all reactions option (if currently showing specific category)
          if (suggestedReactions.length < Reactions.all.length) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                // TODO: Show bottom sheet with all reactions
                _showAllReactionsBottomSheet();
              },
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('More reactions'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  // Show bottom sheet with all reactions
  void _showAllReactionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Reactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Wisdom reactions
            _buildReactionSection('Wisdom', Reactions.wisdom, Colors.blue),
            const SizedBox(height: 16),
            
            // Encouragement reactions
            _buildReactionSection('Encouragement', Reactions.encourage, Colors.green),
            const SizedBox(height: 16),
            
            // Fun reactions
            _buildReactionSection('Fun', Reactions.fun, Colors.orange),
          ],
        ),
      ),
    );
  }
  
  Widget _buildReactionSection(String title, List<ReactionType> reactions, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: reactions.map((reaction) {
            final count = _postCounts?.getCount(reaction.emoji) ?? 0;
            final isUserReaction = _userReaction?.reaction.emoji == reaction.emoji;
            
            return _ReactionButton(
              reaction: reaction,
              count: count,
              isSelected: isUserReaction,
              categoryColor: color,
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
                _handleReactionTap(reaction);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Individual reaction button widget
class _ReactionButton extends StatelessWidget {
  final ReactionType reaction;
  final int count;
  final bool isSelected;
  final Color categoryColor;
  final VoidCallback onTap;
  
  const _ReactionButton({
    Key? key,
    required this.reaction,
    required this.count,
    required this.isSelected,
    required this.categoryColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? categoryColor.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? categoryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: categoryColor.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              reaction.emoji,
              style: const TextStyle(fontSize: 20),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? categoryColor : Colors.grey[600],
                ),
              ),
            ],
            const SizedBox(width: 4),
            Text(
              reaction.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? categoryColor : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}