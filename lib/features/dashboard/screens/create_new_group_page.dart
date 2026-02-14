import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../viewmodels/group_viewmodel.dart';
import '../../auth/widgets/auth_form_widgets.dart';

class CreateNewGroupPage extends StatefulWidget {
  const CreateNewGroupPage({super.key});

  @override
  State<CreateNewGroupPage> createState() => _CreateNewGroupPageState();
}

class _CreateNewGroupPageState extends State<CreateNewGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedFrequency;

  static const _frequencies = ['Daily', 'Weekly', 'Monthly'];

  /// Maps UI frequency to API value (lowercase).
  static String _frequencyToApi(String value) {
    return value.toLowerCase();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onCreate() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final viewModel = context.read<GroupViewModel>();
    final amount = int.tryParse(
      _amountController.text.replaceAll(RegExp(r'[^\d]'), ''),
    ) ?? 0;
    final response = await viewModel.createGroup(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      frequency: _frequencyToApi(_selectedFrequency!),
      amount: amount,
    );
    if (!mounted) return;
    if (response != null) {
      final message = response.metadata?.isNotEmpty == true
          ? response.metadata!
          : 'Group successfully created';
      await context.read<GroupViewModel>().getGroups();
      if (!mounted) return;
      Navigator.of(context).pop(message);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Failed to create group'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Create new group',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.ancient,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B5E20).withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.greenAccent.shade200,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You must have a minimum balance of UGX 5,000 in your wallet to create a group. This is not fees for creating a group and shall not be deducted from your wallet.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.ancient.withValues(alpha: 0.9),
                                height: 1.4,
                                fontSize: 15,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: authInputDecoration(
                    hintText: 'Group name',
                    prefixIcon: Icons.group_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a group name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedFrequency,
                  decoration: authInputDecoration(
                    hintText: 'CashRound frequency',
                    prefixIcon: Icons.calendar_today_outlined,
                  ),
                  dropdownColor: AppColors.ancient,
                  hint: Text(
                    'Select frequency',
                    style: TextStyle(
                      color: AppColors.secondary.withValues(alpha: 0.6),
                      fontSize: 16,
                    ),
                  ),
                  items: _frequencies
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedFrequency = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a frequency';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: authInputDecoration(
                    hintText: 'Amount',
                    prefixIcon: Icons.currency_exchange,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: authInputDecoration(
                    hintText: 'Description (optional)',
                    prefixIcon: Icons.description_outlined,
                  ),
                ),
                const SizedBox(height: 32),
                Consumer<GroupViewModel>(
                  builder: (context, viewModel, _) {
                    return FilledButton(
                      onPressed: viewModel.isLoading ? null : _onCreate,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.ancient,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: viewModel.isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.ancient,
                              ),
                            )
                          : const Text('Create group'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
