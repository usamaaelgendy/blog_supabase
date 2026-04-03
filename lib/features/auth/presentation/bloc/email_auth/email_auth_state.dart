import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class EmailAuthState extends Equatable {
  const EmailAuthState();

  @override
  List<Object?> get props => [];
}

class EmailAuthInitial extends EmailAuthState {}

class EmailAuthLoading extends EmailAuthState {}

class EmailAuthSuccess extends EmailAuthState {
  final UserEntity user;

  const EmailAuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class EmailAuthError extends EmailAuthState {
  final String message;

  const EmailAuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordResetOtpSent extends EmailAuthState {
  final String message;

  const PasswordResetOtpSent(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordResetOtpVerify extends EmailAuthState {}

class PasswordUpdated extends EmailAuthState {}
