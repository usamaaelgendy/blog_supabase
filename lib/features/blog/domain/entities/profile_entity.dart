import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String? name;
  final String? avatarUrl;
  final DateTime createdAt;

  const ProfileEntity({
    required this.id,
    this.name,
    this.avatarUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl, createdAt];
}
