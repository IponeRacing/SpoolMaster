/// Modèle utilisateur
class UserModel {

  const UserModel({
    required this.userId,
    required this.email,
    required this.provider, this.name,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      provider: json['provider'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
  final String userId;
  final String email;
  final String? name;
  final String provider; // 'apple' ou 'google'
  final String? avatarUrl;

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'name': name,
      'provider': provider,
      'avatar_url': avatarUrl,
    };
  }
}

/// Modèle de réponse d'authentification
class AuthResponse {

  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AuthResponse(
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
      expiresIn: data['expires_in'] as int,
    );
  }
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
}
