import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class LoansTermsConditionsPage extends StatefulWidget {
  const LoansTermsConditionsPage({super.key});

  @override
  State<LoansTermsConditionsPage> createState() =>
      _LoansTermsConditionsPageState();
}

class _LoansTermsConditionsPageState extends State<LoansTermsConditionsPage> {
  bool _agreedToTerms = false;

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Loans Terms and Conditions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.ancient,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please read these terms and conditions carefully before applying for a loan through CashRound.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.ancient.withValues(alpha: 0.9),
                  ),
            ),
            const SizedBox(height: 24),
            _TermsSection(
              title: '1. Eligibility',
              content:
                  'To be eligible for a quick loan, you must be a registered member of CashRound, have an active wallet, and meet the minimum account age and activity requirements.',
            ),
            const SizedBox(height: 20),
            _TermsSection(
              title: '2. Loan Amount and Limits',
              content:
                  'Loan amounts and limits are determined based on your account standing and may vary. CashRound reserves the right to approve or decline loan applications at its discretion.',
            ),
            const SizedBox(height: 20),
            _TermsSection(
              title: '3. Repayment',
              content:
                  'You agree to repay the loan amount plus any applicable fees and interest by the due date. Failure to repay on time may result in additional charges and affect your eligibility for future loans.',
            ),
            const SizedBox(height: 20),
            _TermsSection(
              title: '4. Interest and Fees',
              content:
                  'Interest rates and fees will be clearly communicated before you accept a loan. By proceeding, you agree to the terms presented at the time of application.',
            ),
            const SizedBox(height: 20),
            _TermsSection(
              title: '5. Data and Privacy',
              content:
                  'Your personal and financial information will be used in accordance with our Privacy Policy to assess your loan application and manage your account.',
            ),
            const SizedBox(height: 20),
            _TermsSection(
              title: '6. Changes',
              content:
                  'CashRound may update these terms from time to time. Continued use of the loan service after changes constitutes acceptance of the updated terms.',
            ),
            const SizedBox(height: 32),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreedToTerms,
                          onChanged: (v) =>
                              setState(() => _agreedToTerms = v ?? false),
                          activeColor: AppColors.primary,
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.primary;
                            }
                            return AppColors.ancient.withValues(alpha: 0.3);
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'I agree to the loans terms and conditions',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.ancient.withValues(alpha: 0.9),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _agreedToTerms
                    ? () {
                        // TODO: Navigate to loan application screen
                        Navigator.of(context).pop();
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.ancient,
                  disabledBackgroundColor:
                      AppColors.primary.withValues(alpha: 0.4),
                  disabledForegroundColor:
                      AppColors.ancient.withValues(alpha: 0.6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Proceed'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.ancient.withValues(alpha: 0.85),
                height: 1.5,
              ),
        ),
      ],
    );
  }
}
