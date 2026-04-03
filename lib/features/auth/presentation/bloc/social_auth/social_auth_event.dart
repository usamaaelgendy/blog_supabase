import 'package:equatable/equatable.dart';

abstract class SocialAuthEvent extends Equatable {
  const SocialAuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInWithGoogleEvent extends SocialAuthEvent {
  const SignInWithGoogleEvent();
}

class SignInWithAppleEvent extends SocialAuthEvent {
  const SignInWithAppleEvent();
}

class SignInWithGitHubEvent extends SocialAuthEvent {
  const SignInWithGitHubEvent();
}
