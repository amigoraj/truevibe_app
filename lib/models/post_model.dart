class PostModel {
  final String id;
  final UserModel author;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final bool isLiked;
  final String? category;
  final String feedType;
  
  PostModel({
    required this.id,
    required this.author,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    this.category,
    this.feedType = 'passion',
  });
  
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      author: UserModel.fromJson(json['author']),
      content: json['content'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      category: json['category'],
      feedType: json['feedType'] ?? 'passion',
    );
  }
}
