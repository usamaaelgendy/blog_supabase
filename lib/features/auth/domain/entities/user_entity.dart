import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final bool isEmailVerified;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    required this.isEmailVerified,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, phoneNumber, isEmailVerified, createdAt];
}
