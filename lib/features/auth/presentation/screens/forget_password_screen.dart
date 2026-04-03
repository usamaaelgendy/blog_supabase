import 'package:blog_app/core/di/injection_container.dart';
import 'package:blog_app/features/auth/presentation/bloc/email_auth/email_auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/email_auth/email_auth_state.dart';
import 'package:blog_app/features/auth/presentation/screens/components/forget_password/email_step_widget.dart';
import 'package:blog_app/features/auth/presentation/screens/components/forget_password/new_password_step_widget.dart';
import 'package:blog_app/features/auth/presentation/screens/components/forget_password/otp_step_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ForgetPasswordStep { email, otp, newPassword }

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EmailAuthBloc>(),
      child: const ForgetPasswordView(),
    );
  }
}

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  ForgetPasswordStep _currentStep = ForgetPasswordStep.email;
  String _email = '';

  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        leading: _currentStep != ForgetPasswordStep.email
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goToPreviousStep,
              )
            : null,
      ),
      body: BlocConsumer<EmailAuthBloc, EmailAuthState>(
        listener: (context, state) {
          if (state is EmailAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PasswordResetOtpSent) {
            if (_currentStep == ForgetPasswordStep.email) {
              setState(() {
                _email = _emailController.text.trim();
                _currentStep = ForgetPasswordStep.otp;
              });
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is PasswordResetOtpVerify) {
            setState(() {
              _currentStep = ForgetPasswordStep.newPassword;
            });
          } else if (state is PasswordUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is EmailAuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildCurrentStep();
        },
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentStep) {
      case ForgetPasswordStep.email:
        return 'Forgot Password';
      case ForgetPasswordStep.otp:
        return 'Verify Code';
      case ForgetPasswordStep.newPassword:
        return 'New Password';
    }
  }

  void _goToPreviousStep() {
    setState(() {
      switch (_currentStep) {
        case ForgetPasswordStep.otp:
          _currentStep = ForgetPasswordStep.email;
          _otpController.clear();
          break;
        case ForgetPasswordStep.newPassword:
          _currentStep = ForgetPasswordStep.otp;
          _passwordController.clear();
          _confirmPasswordController.clear();
          break;
        case ForgetPasswordStep.email:
          Navigator.of(context).pop();
          break;
      }
    });
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case ForgetPasswordStep.email:
        return EmailStepWidget(
          formKey: _emailFormKey,
          emailController: _emailController,
        );
      case ForgetPasswordStep.otp:
        return OtpStepWidget(
          formKey: _otpFormKey,
          otpController: _otpController,
          email: _email,
        );
      case ForgetPasswordStep.newPassword:
        return NewPasswordStepWidget(
          formKey: _passwordFormKey,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
        );
    }
  }
}
