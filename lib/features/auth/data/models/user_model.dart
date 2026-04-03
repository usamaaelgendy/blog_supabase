import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.phoneNumber,
    required super.isEmailVerified,
    required super.createdAt,
  });

  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      isEmailVerified: user.confirmationSentAt != null,
      createdAt: DateTime.parse(user.createdAt),
      displayName: user.userMetadata?['name'],
      phoneNumber: user.phone,
      photoUrl: user.userMetadata?['avatar_url'] ?? user.userMetadata?['photo'],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      photoUrl: json['photo_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'is_email_verified': isEmailVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    bool? isEmailVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
