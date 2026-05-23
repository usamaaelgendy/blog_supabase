import 'package:blog_app/core/di/injection_container.dart';
import 'package:blog_app/core/network/supabase/supabase_realtime_client.dart';
import 'package:blog_app/core/theme/app_theme.dart';
import 'package:blog_app/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/session/session_event.dart';
import 'package:blog_app/features/auth/presentation/bloc/session/session_state.dart';
import 'package:blog_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:blog_app/features/auth/presentation/screens/login_screen.dart';
import 'package:blog_app/features/auth/presentation/screens/phone_auth_screen.dart';
import 'package:blog_app/features/auth/presentation/screens/profile_screen.dart';
import 'package:blog_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:blog_app/features/blog/domain/entities/post_entity.dart';
import 'package:blog_app/features/blog/presentation/screens/create_post_screen.dart';
import 'package:blog_app/features/blog/presentation/screens/edit_post_screen.dart';
import 'package:blog_app/features/blog/presentation/screens/my_posts_screen.dart';
import 'package:blog_app/features/blog/presentation/screens/post_detail_screen.dart';
import 'package:blog_app/features/blog/presentation/screens/posts_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(url: dotenv.env['SUPABASE_URL']!, anonKey: dotenv.env['SUPABASE_ANON_KEY']!);

  await initDependencies();

  final realtime = sl<SupabaseRealtimeClient>();

  realtime.subscribeToTable(
    channelName: 'testing',
    table: 'posts',
    onChnage: (payload) {
      print(payload);
    },
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SessionBloc>()..add(const CheckAuthStatusEvent()),
      child: MaterialApp(
        title: 'Blog App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginPage());
            case '/signup':
              return MaterialPageRoute(builder: (_) => const SignupPage());
            case '/forgot-password':
              return MaterialPageRoute(builder: (_) => const ForgetPasswordPage());
            case '/phone-auth':
              return MaterialPageRoute(builder: (_) => const PhoneAuthPage());
            case '/home':
              return MaterialPageRoute(builder: (_) => const BlogHomePage());
            case '/profile':
              return MaterialPageRoute(builder: (_) => const ProfilePage());
            case '/create-post':
              return MaterialPageRoute(builder: (_) => const CreatePostPage());
            case '/post-detail':
              final postId = settings.arguments as String;
              return MaterialPageRoute(builder: (_) => PostDetailPage(postId: postId));
            case '/edit-post':
              final post = settings.arguments as PostEntity;
              return MaterialPageRoute(builder: (_) => EditPostPage(post: post));
            case '/my-posts':
              return MaterialPageRoute(builder: (_) => const MyPostsPage());
            default:
              return MaterialPageRoute(builder: (_) => const AuthWrapper());
          }
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        if (state is SessionLoading || state is SessionInitial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (state is Authenticated) {
          return const BlogHomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class BlogHomePage extends StatefulWidget {
  const BlogHomePage({super.key});

  @override
  State<BlogHomePage> createState() => _BlogHomePageState();
}

class _BlogHomePageState extends State<BlogHomePage> {
  int _currentIndex = 0;

  final _pages = const [PostsListPage(), MyPostsPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      },
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Feed'),
            NavigationDestination(
              icon: Icon(Icons.article_outlined),
              selectedIcon: Icon(Icons.article),
              label: 'My Posts',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
