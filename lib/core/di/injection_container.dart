import 'package:blog_app/core/network/supabase/auth_client.dart';
import 'package:blog_app/core/network/supabase/auth_client_impl.dart';
import 'package:blog_app/core/network/supabase/database_client.dart';
import 'package:blog_app/core/network/supabase/database_client_impl.dart';
import 'package:blog_app/core/network/supabase/storage_client.dart';
import 'package:blog_app/core/network/supabase/storage_client_impl.dart';
import 'package:blog_app/features/auth/data/datasources/email_auth_datasource.dart';
import 'package:blog_app/features/auth/data/datasources/email_auth_datasource_impl.dart';
import 'package:blog_app/features/auth/data/datasources/phone_auth_datasource.dart';
import 'package:blog_app/features/auth/data/datasources/phone_auth_datasource_impl.dart';
import 'package:blog_app/features/auth/data/datasources/profile_datasource.dart';
import 'package:blog_app/features/auth/data/datasources/profile_datasource_impl.dart';
import 'package:blog_app/features/auth/data/datasources/session_datasource.dart';
import 'package:blog_app/features/auth/data/datasources/session_datasource_impl.dart';
import 'package:blog_app/features/auth/data/datasources/social_auth_datasource.dart';
import 'package:blog_app/features/auth/data/datasources/social_auth_datasource_impl.dart';
import 'package:blog_app/features/auth/data/repositories/email_auth_repository_impl.dart';
import 'package:blog_app/features/auth/data/repositories/phone_auth_repository_impl.dart';
import 'package:blog_app/features/auth/data/repositories/profile_repository_impl.dart';
import 'package:blog_app/features/auth/data/repositories/session_repository_impl.dart';
import 'package:blog_app/features/auth/data/repositories/social_auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repositories/email_auth_repository.dart';
import 'package:blog_app/features/auth/domain/repositories/phone_auth_repository.dart';
import 'package:blog_app/features/auth/domain/repositories/profile_repository.dart';
import 'package:blog_app/features/auth/domain/repositories/session_repository.dart';
import 'package:blog_app/features/auth/domain/repositories/social_auth_repository.dart';
import 'package:blog_app/features/auth/presentation/bloc/email_auth/email_auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/phone_auth/phone_auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/social_auth/social_auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasources/comment_datasource.dart';
import 'package:blog_app/features/blog/data/datasources/comment_datasource_impl.dart';
import 'package:blog_app/features/blog/data/datasources/post_crud_datasource.dart';
import 'package:blog_app/features/blog/data/datasources/post_crud_datasource_impl.dart';
import 'package:blog_app/features/blog/data/datasources/post_query_datasource.dart';
import 'package:blog_app/features/blog/data/datasources/post_query_datasource_impl.dart';
import 'package:blog_app/features/blog/data/repositories/comment_repository_impl.dart';
import 'package:blog_app/features/blog/data/repositories/post_crud_repository_impl.dart';
import 'package:blog_app/features/blog/data/repositories/post_query_repository_impl.dart';
import 'package:blog_app/features/blog/domain/repositories/comment_repository.dart';
import 'package:blog_app/features/blog/domain/repositories/post_crud_repository.dart';
import 'package:blog_app/features/blog/domain/repositories/post_query_repository.dart';
import 'package:blog_app/features/blog/presentation/bloc/comment/comment_bloc.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_crud/post_crud_bloc.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_query/post_query_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ===== Core =====
  sl.registerLazySingleton<AuthClient>(
    () => AuthClientImpl(
      Supabase.instance.client.auth,
      Supabase.instance.client.functions,
    ),
  );
  sl.registerLazySingleton<StorageClient>(
    () => StorageClientImpl(Supabase.instance.client),
  );
  sl.registerLazySingleton<DatabaseClient>(
    () => DatabaseClientImpl(Supabase.instance.client),
  );

  // ===== Auth DataSources =====
  sl.registerLazySingleton<EmailAuthDataSource>(() => EmailAuthDataSourceImpl(sl()));
  sl.registerLazySingleton<SocialAuthDataSource>(() => SocialAuthDataSourceImpl(sl()));
  sl.registerLazySingleton<PhoneAuthDataSource>(() => PhoneAuthDataSourceImpl(sl()));
  sl.registerLazySingleton<SessionDataSource>(() => SessionDataSourceImpl(sl()));
  sl.registerLazySingleton<ProfileDataSource>(() => ProfileDataSourceImpl(sl(), sl()));

  // ===== Auth Repositories =====
  sl.registerLazySingleton<EmailAuthRepository>(() => EmailAuthRepositoryImpl(emailAuthDataSource: sl()));
  sl.registerLazySingleton<SocialAuthRepository>(() => SocialAuthRepositoryImpl(socialAuthDataSource: sl()));
  sl.registerLazySingleton<PhoneAuthRepository>(() => PhoneAuthRepositoryImpl(phoneAuthDataSource: sl()));
  sl.registerLazySingleton<SessionRepository>(() => SessionRepositoryImpl(sessionDataSource: sl()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(profileDataSource: sl()));

  // ===== Auth BLoCs =====
  sl.registerFactory(() => EmailAuthBloc(emailAuthRepository: sl()));
  sl.registerFactory(() => SocialAuthBloc(socialAuthRepository: sl()));
  sl.registerFactory(() => PhoneAuthBloc(phoneAuthRepository: sl()));
  sl.registerFactory(() => SessionBloc(sessionRepository: sl()));
  sl.registerFactory(() => ProfileBloc(profileRepository: sl()));

  // ===== Blog DataSources =====
  sl.registerLazySingleton<PostCrudDataSource>(() => PostCrudDataSourceImpl(sl()));
  sl.registerLazySingleton<PostQueryDataSource>(() => PostQueryDataSourceImpl(sl()));
  sl.registerLazySingleton<CommentDataSource>(() => CommentDataSourceImpl(sl()));

  // ===== Blog Repositories =====
  sl.registerLazySingleton<PostCrudRepository>(() => PostCrudRepositoryImpl(postCrudDataSource: sl()));
  sl.registerLazySingleton<PostQueryRepository>(() => PostQueryRepositoryImpl(postQueryDataSource: sl()));
  sl.registerLazySingleton<CommentRepository>(() => CommentRepositoryImpl(commentDataSource: sl()));

  // ===== Blog BLoCs =====
  sl.registerFactory(() => PostCrudBloc(postCrudRepository: sl()));
  sl.registerFactory(() => PostQueryBloc(postQueryRepository: sl()));
  sl.registerFactory(() => CommentBloc(commentRepository: sl()));
}
