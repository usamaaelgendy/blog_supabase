import 'package:blog_app/core/di/injection_container.dart';
import 'package:blog_app/features/auth/presentation/bloc/email_auth/email_auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/email_auth/email_auth_event.dart';
import 'package:blog_app/features/auth/presentation/bloc/email_auth/email_auth_state.dart';
import 'package:blog_app/features/auth/presentation/bloc/social_auth/social_auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/social_auth/social_auth_event.dart';
import 'package:blog_app/features/auth/presentation/bloc/social_auth/social_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<EmailAuthBloc>()),
        BlocProvider(create: (context) => sl<SocialAuthBloc>()),
      ],
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<EmailAuthBloc, EmailAuthState>(
            listener: (context, state) {
              if (state is EmailAuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              } else if (state is EmailAuthSuccess) {
                Navigator.of(context).pushReplacementNamed('/home');
              }
            },
          ),
          BlocListener<SocialAuthBloc, SocialAuthState>(
            listener: (context, state) {
              if (state is SocialAuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              } else if (state is SocialAuthSuccess) {
                Navigator.of(context).pushReplacementNamed('/home');
              }
            },
          ),
        ],
        child: BlocBuilder<EmailAuthBloc, EmailAuthState>(
          builder: (context, emailState) {
            final isLoading = emailState is EmailAuthLoading ||
                context.watch<SocialAuthBloc>().state is SocialAuthLoading;

            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      Icon(Icons.article_outlined, size: 80, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 16),
                      Text('Blog App', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Sign in to continue', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your email';
                          if (!value.contains('@')) return 'Please enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outlined)),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your password';
                          if (value.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pushNamed('/forgot-password'),
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<EmailAuthBloc>().add(
                              SignInWithEmailEvent(email: _emailController.text.trim(), password: _passwordController.text),
                            );
                          }
                        },
                        child: const Text('Sign In'),
                      ),
                      const SizedBox(height: 24),
                      const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('OR')), Expanded(child: Divider())]),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: () => context.read<SocialAuthBloc>().add(const SignInWithGoogleEvent()),
                        icon: const Icon(Icons.g_mobiledata, size: 28),
                        label: const Text('Continue with Google'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => context.read<SocialAuthBloc>().add(const SignInWithGitHubEvent()),
                        icon: const Icon(Icons.code, size: 24),
                        label: const Text('Continue with GitHub'),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(onPressed: () => Navigator.of(context).pushNamed('/signup'), child: const Text('Sign Up')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
