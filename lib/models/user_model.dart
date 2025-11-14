class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? bio;
  final int followers;
  final int following;
  final List<String> passions;
  final Map<String, int> passionBalance;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.bio,
    this.followers = 0,
    this.following = 0,
    this.passions = const [],
    this.passionBalance = const {},
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      bio: json['bio'],
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      passions: List<String>.from(json['passions'] ?? []),
      passionBalance: Map<String, int>.from(json['passionBalance'] ?? {}),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'bio': bio,
      'followers': followers,
      'following': following,
      'passions': passions,
      'passionBalance': passionBalance,
    };
  }
}
