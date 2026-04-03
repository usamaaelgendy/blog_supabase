import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileEvent extends ProfileEvent {
  final String? name;
  final String? avatarUrl;

  const UpdateProfileEvent({this.name, this.avatarUrl});

  @override
  List<Object?> get props => [name, avatarUrl];
}

class UploadProfilePictureEvent extends ProfileEvent {
  final String filePath;

  const UploadProfilePictureEvent({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class DeleteAccountEvent extends ProfileEvent {
  const DeleteAccountEvent();
}
