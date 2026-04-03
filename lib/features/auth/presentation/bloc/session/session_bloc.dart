import 'dart:async';

import 'package:blog_app/features/auth/domain/repositories/session_repository.dart';
import 'package:blog_app/features/auth/presentation/bloc/session/session_event.dart';
import 'package:blog_app/features/auth/presentation/bloc/session/session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final SessionRepository sessionRepository;
  StreamSubscription? _authStateSubscription;

  SessionBloc({required this.sessionRepository}) : super(SessionInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignOutEvent>(_onSignOut);
    on<AuthStateChangedEvent>(_onAuthStateChanged);

    _authStateSubscription = sessionRepository.authStateChanges.listen((user) {
      add(AuthStateChangedEvent(user));
    });
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<SessionState> emit) async {
    emit(SessionLoading());
    final result = await sessionRepository.getCurrentUser();
    result.fold(
      (failure) => emit(SessionError(failure.message)),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<SessionState> emit) async {
    emit(SessionLoading());
    final result = await sessionRepository.signOut();
    result.fold(
      (failure) => emit(SessionError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  void _onAuthStateChanged(AuthStateChangedEvent event, Emitter<SessionState> emit) {
    if (event.user != null) {
      emit(Authenticated(event.user!));
    } else {
      emit(Unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
