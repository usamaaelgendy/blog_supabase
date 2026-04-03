import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class SocialAuthState extends Equatable {
  const SocialAuthState();

  @override
  List<Object?> get props => [];
}

class SocialAuthInitial extends SocialAuthState {}

class SocialAuthLoading extends SocialAuthState {}

class SocialAuthSuccess extends SocialAuthState {
  final UserEntity user;

  const SocialAuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SocialAuthError extends SocialAuthState {
  final String message;

  const SocialAuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class SocialAuthLaunched extends SocialAuthState {}
