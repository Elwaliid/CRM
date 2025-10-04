class Settings {
  final String theme;
  final bool notifications;

  Settings({required this.theme, required this.notifications});

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    theme: json['theme'] ?? 'light',
    notifications: json['notifications'] ?? true,
  );

  Map<String, dynamic> toJson() => {
    'theme': theme,
    'notifications': notifications,
  };
}

class UserModel {
  final String? id;
  final String email;
  final String? password;
  final String? name;
  final String? phone;
  final String? avatar;
  final String? googleId;
  final String? authProvider;
  final String? role;
  final Settings? settings;
  final DateTime? createdAt;

  UserModel({
    this.id,
    required this.email,
    this.password,
    this.name,
    this.phone,
    this.avatar,
    this.googleId,
    this.authProvider,
    this.role,
    this.settings,
    this.createdAt,
  });
}
