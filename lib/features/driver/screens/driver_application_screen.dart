import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/driver_provider.dart';

class DriverApplicationScreen extends StatefulWidget {
  const DriverApplicationScreen({super.key});

  @override
  State<DriverApplicationScreen> createState() =>
      _DriverApplicationScreenState();
}

class _DriverApplicationScreenState extends State<DriverApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tcKimlikController = TextEditingController();
  final _ehliyetController = TextEditingController();

  @override
  void dispose() {
    _tcKimlikController.dispose();
    _ehliyetController.dispose();
    super.dispose();
  }

  void _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      final driverProvider = Provider.of<DriverProvider>(
        context,
        listen: false,
      );

      final success = await driverProvider.submitDriverApplication(
        tcKimlikNo: _tcKimlikController.text,
        ehliyetNo: _ehliyetController.text,
      );

      if (success && mounted) {
        context.go('/driver/success');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(driverProvider.errorMessage ?? 'Bir hata oluştu'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.driverApplication),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/home'),
            tooltip: AppStrings.goHome,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_shipping,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.becomeDriver,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.driverRequirements,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.driverApplicationDesc,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // TC Kimlik No Field
                    CustomTextField(
                      label: AppStrings.tcKimlikNo,
                      hint: '12345678901',
                      controller: _tcKimlikController,
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixIcon: const Icon(
                        Icons.badge,
                        color: AppColors.primary,
                      ),
                      validator: Provider.of<DriverProvider>(
                        context,
                        listen: false,
                      ).validateTcKimlikNo,
                    ),
                    const SizedBox(height: 20),

                    // Ehliyet No Field
                    CustomTextField(
                      label: AppStrings.ehliyetNo,
                      hint: 'A12345',
                      controller: _ehliyetController,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(
                        Icons.credit_card,
                        color: AppColors.primary,
                      ),
                      validator: Provider.of<DriverProvider>(
                        context,
                        listen: false,
                      ).validateEhliyetNo,
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    Consumer<DriverProvider>(
                      builder: (context, driverProvider, child) {
                        return CustomButton(
                          text: AppStrings.submitApplication,
                          isLoading: driverProvider.isLoading,
                          onPressed: driverProvider.isLoading
                              ? null
                              : _submitApplication,
                          icon: Icons.send,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
