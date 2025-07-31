import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/driver_provider.dart';

class DriverApplicationSuccessScreen extends StatelessWidget {
  const DriverApplicationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.applicationSubmitted),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Success Animation Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Success Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      size: 60,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Success Title
                  Text(
                    AppStrings.applicationSuccess,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Success Message
                  Text(
                    AppStrings.applicationUnderReview,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Application Details
            Consumer<DriverProvider>(
              builder: (context, driverProvider, child) {
                final application = driverProvider.currentApplication;
                if (application == null) {
                  return const SizedBox.shrink();
                }

                return Container(
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
                        'Başvuru Detayları',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 16),

                      _buildDetailRow(
                        context,
                        'Başvuru ID',
                        '#${application.id.substring(application.id.length - 6)}',
                      ),
                      const SizedBox(height: 12),

                      _buildDetailRow(
                        context,
                        AppStrings.tcKimlikNo,
                        application.tcKimlikNo,
                      ),
                      const SizedBox(height: 12),

                      _buildDetailRow(
                        context,
                        AppStrings.ehliyetNo,
                        application.ehliyetNo,
                      ),
                      const SizedBox(height: 12),

                      _buildDetailRow(context, 'Durum', 'İncelemede'),
                      const SizedBox(height: 12),

                      _buildDetailRow(
                        context,
                        'Başvuru Tarihi',
                        '${application.createdAt.day.toString().padLeft(2, '0')}/'
                            '${application.createdAt.month.toString().padLeft(2, '0')}/'
                            '${application.createdAt.year}',
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Action Buttons
            Column(
              children: [
                CustomButton(
                  text: 'Ana Sayfaya Dön',
                  onPressed: () => context.go('/home'),
                  icon: Icons.home,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: AppStrings.newApplication,
                  onPressed: () {
                    Provider.of<DriverProvider>(
                      context,
                      listen: false,
                    ).resetApplication();
                    context.go('/driver/application');
                  },
                  outlined: true,
                  icon: Icons.add,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
