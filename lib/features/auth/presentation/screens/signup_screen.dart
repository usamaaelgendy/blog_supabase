import 'package:blog_app/core/di/injection_container.dart';
import 'package:blog_app/features/auth/presentation/bloc/email_auth/email_auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/email_auth/email_auth_event.dart';
import 'package:blog_app/features/auth/presentation/bloc/email_auth/email_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => sl<EmailAuthBloc>(), child: const SignupView());
  }
}

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: BlocConsumer<EmailAuthBloc, EmailAuthState>(
        listener: (context, state) {
          if (state is EmailAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          } else if (state is EmailAuthSuccess) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
        builder: (context, state) {
          if (state is EmailAuthLoading) return const Center(child: CircularProgressIndicator());
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outlined)),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 16),
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
                      if (value == null || value.isEmpty) return 'Please enter a password';
                      if (value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock_outline)),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please confirm your password';
                      if (value != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<EmailAuthBloc>().add(
                          SignUpWithEmailEvent(email: _emailController.text.trim(), password: _passwordController.text, name: _nameController.text.trim()),
                        );
                      }
                    },
                    child: const Text('Create Account'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Sign In')),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
