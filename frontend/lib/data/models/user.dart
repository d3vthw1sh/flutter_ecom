class User {
  final String id;
  final String username;
  final String email;
  final bool isAdmin;
  final String? googleId;
  final String? googleImage;
  final String? token;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.isAdmin = false,
    this.googleId,
    this.googleImage,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      googleId: json['googleId'],
      googleImage: json['googleImage'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'isAdmin': isAdmin,
      'googleId': googleId,
      'googleImage': googleImage,
      'token': token,
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    bool? isAdmin,
    String? googleId,
    String? googleImage,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      googleId: googleId ?? this.googleId,
      googleImage: googleImage ?? this.googleImage,
      token: token ?? this.token,
    );
  }
}
