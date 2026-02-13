import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/widgets/auth_form_widgets.dart';

/// UI screen shown after user taps "Approve" on group details. User enters the
/// OTP sent to their phone; on Verify the route pops with `true` (no API).
class ApproveOtpPage extends StatefulWidget {
  const ApproveOtpPage({
    super.key,
    required this.maskedPhoneNumber,
    required this.role,
  });

  /// Masked display string, e.g. "+254 *** *** 678".
  final String maskedPhoneNumber;
  /// Role being approved (e.g. Chairperson, Secretary).
  final String role;

  @override
  State<ApproveOtpPage> createState() => _ApproveOtpPageState();
}

class _ApproveOtpPageState extends State<ApproveOtpPage> {
  final _codeController = TextEditingController();
  bool _isVerifying = false;
  String? _errorText;
  bool _canResend = true;
  int _resendCooldown = 0;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onVerify() {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => _errorText = 'Please enter the 6-digit code');
      return;
    }
    setState(() {
      _errorText = null;
      _isVerifying = true;
    });
    // UI only: accept any 6-digit code and pop success
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _isVerifying = false);
      Navigator.of(context).pop(true);
    });
  }

  void _onResend() {
    if (!_canResend || _resendCooldown > 0) return;
    setState(() {
      _errorText = null;
      _canResend = false;
      _resendCooldown = 60;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code resent')),
    );
    _startResendCooldown();
  }

  void _startResendCooldown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _resendCooldown--;
        if (_resendCooldown <= 0) _canResend = true;
      });
      return _resendCooldown > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.ancient,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.sms_outlined,
                    size: 80,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Verify with OTP',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.ancient,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Approve as ${widget.role}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.ancient.withValues(alpha: 0.9),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'We sent a 6-digit code to',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.ancient.withValues(alpha: 0.9),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.maskedPhoneNumber,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    onChanged: (_) => setState(() => _errorText = null),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: authInputDecoration(
                      hintText: 'Enter 6-digit code',
                      prefixIcon: Icons.pin_outlined,
                    ).copyWith(
                      errorText: _errorText,
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: _isVerifying ? null : _onVerify,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.ancient,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isVerifying
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.ancient,
                            ),
                          )
                        : const Text('Verify'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: (_canResend && _resendCooldown == 0) ? _onResend : null,
                    child: _resendCooldown > 0
                        ? Text(
                            'Resend code in ${_resendCooldown}s',
                            style: TextStyle(
                              color: AppColors.ancient.withValues(alpha: 0.6),
                            ),
                          )
                        : const Text(
                            'Resend code',
                            style: TextStyle(color: AppColors.primary),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
