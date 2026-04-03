import 'package:blog_app/features/auth/presentation/bloc/email_auth/email_auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/email_auth/email_auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailStepWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;

  const EmailStepWidget({
    super.key,
    required this.formKey,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Enter your email address and we\'ll send you a code to reset your password.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<EmailAuthBloc>().add(
                        SendPasswordRestOtpEvent(
                          email: emailController.text.trim(),
                        ),
                      );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Send Reset Code'),
            ),
          ],
        ),
      ),
    );
  }
}
