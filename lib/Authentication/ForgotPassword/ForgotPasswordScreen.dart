import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';
import 'package:spicy_eats_admin/Authentication/widgets/RegisterTextfield.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  static const String routename = '/forgot-password';

  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _otpController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  bool _isSending = false;
  bool _isSubmittingReset = false;
  bool _emailSent = false;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;

  Timer? _resendTimer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _otpController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    setState(() {
      _secondsRemaining = 60;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  Future<void> _handleSendResetLink() async {
    if (!_emailFormKey.currentState!.validate()) return;

    setState(() {
      _isSending = true;
    });

    try {
      final success = await ref
          .read(authControllerProvider)
          .sendPasswordResetEmail(
            email: _emailController.text.trim(),
            context: context,
          );

      if (mounted) {
        if (success) {
          setState(() {
            _emailSent = true;
          });
          _startResendCountdown();
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  Future<void> _handleResetWithOtp() async {
    if (!_otpFormKey.currentState!.validate()) return;

    setState(() {
      _isSubmittingReset = true;
    });

    try {
      final otpSuccess = await ref
          .read(authControllerProvider)
          .verifyPasswordResetOtp(
            email: _emailController.text.trim(),
            otp: _otpController.text.trim(),
            context: context,
          );

      if (!otpSuccess || !mounted) return;

      final updateSuccess = await ref
          .read(authControllerProvider)
          .updatePassword(
            newPassword: _newPasswordController.text,
            context: context,
          );

      if (updateSuccess && mounted) {
        context.go(LoginScreen.routename);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingReset = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColor.primaryBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Image.asset(
                          'lib/assets/SpicyEats.png',
                          height: 60,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Forgot Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MyAppColor.mainPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _emailSent
                            ? 'We sent password reset instructions to ${_emailController.text}. '
                              'Follow the link in your email, or enter the OTP code below to reset immediately.'
                            : 'Enter your registered restaurant account email address to receive password reset instructions.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: MyAppColor.iconGray,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email input form
                      Form(
                        key: _emailFormKey,
                        child: Column(
                          children: [
                            RegisterTextfield(
                              controller: _emailController,
                              labeltext: 'Email Address',
                              onvalidation: (value) {
                                const emailPattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$';
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(emailPattern).hasMatch(value.trim())) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Send / Resend button
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _isSending || _secondsRemaining > 0
                              ? null
                              : _handleSendResetLink,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            disabledBackgroundColor: Colors.black45,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isSending
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _emailSent
                                      ? (_secondsRemaining > 0
                                          ? 'Resend Link in ${_secondsRemaining}s'
                                          : 'Resend Reset Link')
                                      : 'Send Reset Link',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      // Optional OTP + New Password section if email was sent
                      if (_emailSent) ...[
                        const SizedBox(height: 28),
                        Row(
                          children: const [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Or Enter OTP Code',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: MyAppColor.iconGray,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Form(
                          key: _otpFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              RegisterTextfield(
                                controller: _otpController,
                                labeltext: '6-digit OTP Code',
                                onvalidation: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'OTP code is required';
                                  }
                                  if (val.trim().length < 6) {
                                    return 'Enter a valid 6-digit code';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              RegisterTextfield(
                                controller: _newPasswordController,
                                labeltext: 'New Password',
                                isObsecure: _hideNewPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _hideNewPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _hideNewPassword = !_hideNewPassword;
                                    });
                                  },
                                ),
                                onvalidation: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'New password is required';
                                  }
                                  if (val.length < 9) {
                                    return 'Password must be at least 9 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              RegisterTextfield(
                                controller: _confirmPasswordController,
                                labeltext: 'Confirm New Password',
                                isObsecure: _hideConfirmPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _hideConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _hideConfirmPassword =
                                          !_hideConfirmPassword;
                                    });
                                  },
                                ),
                                onvalidation: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (val != _newPasswordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: _isSubmittingReset
                                      ? null
                                      : _handleResetWithOtp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyAppColor.orangePrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: _isSubmittingReset
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Reset Password with OTP',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),
                      Center(
                        child: TextButton.icon(
                          onPressed: () => context.go(LoginScreen.routename),
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 16,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'Back to Login',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
