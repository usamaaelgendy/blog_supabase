import 'package:blog_app/features/auth/domain/repositories/profile_repository.dart';
import 'package:blog_app/features/auth/presentation/bloc/profile/profile_event.dart';
import 'package:blog_app/features/auth/presentation/bloc/profile/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UploadProfilePictureEvent>(_onUploadProfilePicture);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await profileRepository.updateProfile(name: event.name, avatarUrl: event.avatarUrl);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileUpdated(user)),
    );
  }

  Future<void> _onUploadProfilePicture(UploadProfilePictureEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await profileRepository.uploadProfilePicture(filePath: event.filePath);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (url) => emit(ProfilePictureUploaded(url)),
    );
  }

  Future<void> _onDeleteAccount(DeleteAccountEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await profileRepository.deleteAccount();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => emit(AccountDeleted()),
    );
  }
}
