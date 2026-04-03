import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class Authenticated extends SessionState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends SessionState {}

class SessionError extends SessionState {
  final String message;

  const SessionError(this.message);

  @override
  List<Object?> get props => [message];
}
