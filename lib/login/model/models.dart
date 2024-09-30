class User {
  final String userId;
  final String mailId;
  final String password;

  User({
    required this.userId,
    required this.mailId,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      mailId: json['mailId'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'mailId': mailId,
      'password': password,
    };
  }
}
