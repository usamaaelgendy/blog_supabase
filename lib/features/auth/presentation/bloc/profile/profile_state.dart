import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final UserEntity user;

  const ProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfilePictureUploaded extends ProfileState {
  final String url;

  const ProfilePictureUploaded(this.url);

  @override
  List<Object?> get props => [url];
}

class AccountDeleted extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
