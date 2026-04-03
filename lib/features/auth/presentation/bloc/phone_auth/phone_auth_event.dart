import 'package:equatable/equatable.dart';

abstract class PhoneAuthEvent extends Equatable {
  const PhoneAuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOTPEvent extends PhoneAuthEvent {
  final String phoneNumber;

  const SendOTPEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOTPEvent extends PhoneAuthEvent {
  final String phoneNumber;
  final String otpCode;

  const VerifyOTPEvent({required this.phoneNumber, required this.otpCode});

  @override
  List<Object?> get props => [phoneNumber, otpCode];
}
