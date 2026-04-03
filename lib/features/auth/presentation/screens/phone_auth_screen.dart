import 'package:blog_app/core/di/injection_container.dart';
import 'package:blog_app/features/auth/presentation/bloc/phone_auth/phone_auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/phone_auth/phone_auth_event.dart';
import 'package:blog_app/features/auth/presentation/bloc/phone_auth/phone_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

enum PhoneAuthStep { phone, otp }

class PhoneAuthPage extends StatelessWidget {
  const PhoneAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PhoneAuthBloc>(),
      child: const PhoneAuthView(),
    );
  }
}

class PhoneAuthView extends StatefulWidget {
  const PhoneAuthView({super.key});

  @override
  State<PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  PhoneAuthStep _currentStep = PhoneAuthStep.phone;

  final _phoneFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  String _phoneNumber = '';

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentStep == PhoneAuthStep.phone
              ? 'Phone Authentication'
              : 'Verify Code',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep == PhoneAuthStep.otp) {
              setState(() {
                _currentStep = PhoneAuthStep.phone;
                _otpController.clear();
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
        listener: (context, state) {
          if (state is PhoneAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is OTPSent) {
            setState(() {
              _phoneNumber = _phoneController.text.trim();
              _currentStep = PhoneAuthStep.otp;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('OTP sent successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is PhoneAuthSuccess) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
        builder: (context, state) {
          if (state is PhoneAuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _currentStep == PhoneAuthStep.phone
              ? _buildPhoneStep()
              : _buildOtpStep();
        },
      ),
    );
  }

  Widget _buildPhoneStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _phoneFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Enter your phone number to receive a verification code.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+1234567890',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your phone number';
                }
                if (!RegExp(r'^\+\d{7,15}$').hasMatch(value.trim())) {
                  return 'Enter a valid phone number with country code (e.g. +1234567890)';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _sendOtp,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpStep() {
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
        key: _otpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Text(
              'Enter the 6-digit code sent to $_phoneNumber',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Center(
              child: Pinput(
                length: 6,
                controller: _otpController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                errorPinTheme: errorPinTheme,
                onCompleted: (_) => _verifyOtp(),
                validator: (value) {
                  if (value == null || value.length != 6) {
                    return 'Please enter 6-digit code';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _verifyOtp,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Verify'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.read<PhoneAuthBloc>().add(
                      SendOTPEvent(phoneNumber: _phoneNumber),
                    );
              },
              child: const Text('Resend Code'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendOtp() {
    if (_phoneFormKey.currentState!.validate()) {
      context.read<PhoneAuthBloc>().add(
            SendOTPEvent(phoneNumber: _phoneController.text.trim()),
          );
    }
  }

  void _verifyOtp() {
    if (_otpFormKey.currentState!.validate()) {
      context.read<PhoneAuthBloc>().add(
            VerifyOTPEvent(
              phoneNumber: _phoneNumber,
              otpCode: _otpController.text.trim(),
            ),
          );
    }
  }
}
