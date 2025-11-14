// lib/widgets/social_post_with_reactions.dart
// EXAMPLE: Complete post component with reactions integrated

import 'package:flutter/material.dart';
import 'reaction_bar.dart';
import '../services/reaction_service.dart';

class SocialPostWithReactions extends StatelessWidget {
  final String postId;
  final String userName;
  final String userAvatar;
  final String content;
  final String? imageUrl;
  final String feedType; // 'fun', 'passion', or 'news'
  final DateTime timestamp;
  final int commentCount;
  final int shareCount;

  const SocialPostWithReactions({
    Key? key,
    required this.postId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.imageUrl,
    required this.feedType,
    required this.timestamp,
    this.commentCount = 0,
    this.shareCount = 0,
  }) : super(key: key);

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _getFeedIcon() {
    switch (feedType) {
      case 'fun':
        return '😂';
      case 'passion':
        return '💪';
      case 'news':
        return '📰';
      default:
        return '📱';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          _buildHeader(),

          // Post Content
          _buildContent(),

          // Post Image (if any)
          if (imageUrl != null) _buildImage(),

          const SizedBox(height: 8),

          // ⭐⭐⭐ REACTIONS BAR ⭐⭐⭐
          ReactionBar(
            postId: postId,
            feedType: feedType,
            showCounts: true,
          ),

          const Divider(height: 1),

          // Action Buttons (Comment, Share)
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // User Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: Text(
              userAvatar,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      _getTimeAgo(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getFeedIcon(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // More Options
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        content,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 200,
          width: double.infinity,
          color: Colors.grey.shade300,
          child: Center(
            child: Text(
              imageUrl!,
              style: TextStyle(
                fontSize: 48,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Comment Button
          TextButton.icon(
            icon: const Icon(Icons.comment_outlined),
            label: Text(commentCount > 0 ? '$commentCount' : 'Comment'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
            ),
            onPressed: () {
              // Open comments
              _showComments(context);
            },
          ),

          // Share Button
          TextButton.icon(
            icon: const Icon(Icons.share_outlined),
            label: Text(shareCount > 0 ? '$shareCount' : 'Share'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
            ),
            onPressed: () {
              // Share post
              _showShareOptions(context);
            },
          ),

          // View Personality Button (Optional)
          TextButton.icon(
            icon: const Icon(Icons.insights_outlined),
            label: const Text('Insights'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
            ),
            onPressed: () {
              // Show reaction insights for this post
              _showPostInsights(context);
            },
          ),
        ],
      ),
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Comments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Comments feature coming soon!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share Post',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Link'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Share via Message'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPostInsights(BuildContext context) {
    final reactionService = ReactionService();
    final postReactions = reactionService.getPostReactions(postId);
    final distribution = postReactions.getCategoryDistribution();

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Post Reaction Insights',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text('Total Reactions: ${postReactions.totalReactions}'),
            const SizedBox(height: 12),
            Text(
              '📚 Wisdom: ${distribution[ReactionCategory.wisdom] ?? 0}',
            ),
            Text(
              '💪 Encouragement: ${distribution[ReactionCategory.encouragement] ?? 0}',
            ),
            Text(
              '😂 Fun: ${distribution[ReactionCategory.fun] ?? 0}',
            ),
            const SizedBox(height: 20),
            if (postReactions.mostPopular != null) ...[
              Text(
                'Most Popular: ${ReactionData.reactions[postReactions.mostPopular]!.emoji} ${ReactionData.reactions[postReactions.mostPopular]!.label}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ========================================
// EXAMPLE USAGE IN YOUR APP
// ========================================

/*

// In your feed screen:

import 'widgets/social_post_with_reactions.dart';

class MyFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Example Fun Post
        SocialPostWithReactions(
          postId: '1',
          userName: 'John Doe',
          userAvatar: '😎',
          content: 'Just had the funniest experience at the coffee shop! ☕',
          feedType: 'fun',
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
          commentCount: 24,
          shareCount: 5,
        ),
        
        // Example Passion Post
        SocialPostWithReactions(
          postId: '2',
          userName: 'Sarah Smith',
          userAvatar: '💪',
          content: 'Completed my first marathon today! Never give up on your dreams! 🏃‍♀️',
          feedType: 'passion',
          timestamp: DateTime.now().subtract(Duration(hours: 5)),
          commentCount: 156,
          shareCount: 43,
        ),
        
        // Example News Post
        SocialPostWithReactions(
          postId: '3',
          userName: 'News Bot',
          userAvatar: '📰',
          content: 'New study shows interesting findings about climate change...',
          feedType: 'news',
          timestamp: DateTime.now().subtract(Duration(minutes: 30)),
          commentCount: 89,
          shareCount: 234,
        ),
      ],
    );
  }
}

*/