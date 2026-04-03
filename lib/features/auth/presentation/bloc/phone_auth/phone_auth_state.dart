import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class PhoneAuthState extends Equatable {
  const PhoneAuthState();

  @override
  List<Object?> get props => [];
}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class OTPSent extends PhoneAuthState {}

class PhoneAuthSuccess extends PhoneAuthState {
  final UserEntity user;

  const PhoneAuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class PhoneAuthError extends PhoneAuthState {
  final String message;

  const PhoneAuthError(this.message);

  @override
  List<Object?> get props => [message];
}
