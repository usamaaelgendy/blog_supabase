import 'package:blog_app/features/auth/presentation/bloc/email_auth/email_auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/email_auth/email_auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class OtpStepWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController otpController;
  final String email;

  const OtpStepWidget({
    super.key,
    required this.formKey,
    required this.otpController,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Text(
              'Enter the 6-digit code sent to $email',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Center(
              child: Pinput(
                length: 8,
                controller: otpController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                errorPinTheme: errorPinTheme,
                onCompleted: (pin) => _verifyOtp(context),
                validator: (value) {
                  if (value == null || value.length != 8) {
                    return 'Please enter 8-digit code';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _verifyOtp(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Verify Code'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.read<EmailAuthBloc>().add(
                      SendPasswordRestOtpEvent(email: email),
                    );
              },
              child: const Text('Resend Code'),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyOtp(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<EmailAuthBloc>().add(
            VerifyPasswordRestOtpEvent(
              email: email,
              otp: otpController.text.trim(),
            ),
          );
    }
  }
}
