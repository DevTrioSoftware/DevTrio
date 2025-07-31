import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/custom_button.dart';

import '../providers/driver_provider.dart';
import '../../../core/models/driver_model.dart';

class DriverTrackingScreen extends StatefulWidget {
  const DriverTrackingScreen({super.key});

  @override
  State<DriverTrackingScreen> createState() => _DriverTrackingScreenState();
}

class _DriverTrackingScreenState extends State<DriverTrackingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadApplicationStatus();
    });
  }

  void _loadApplicationStatus() {
    Provider.of<DriverProvider>(context, listen: false).getApplicationStatus();
  }

  void _simulateStatusChange() {
    Provider.of<DriverProvider>(context, listen: false).simulateStatusChange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.applicationTracking),
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
      body: Consumer<DriverProvider>(
        builder: (context, driverProvider, child) {
          if (driverProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          if (driverProvider.currentApplication == null) {
            return _buildNoApplicationWidget(context);
          }

          return _buildApplicationStatusWidget(
            context,
            driverProvider.currentApplication!,
            driverProvider,
          );
        },
      ),
    );
  }

  Widget _buildNoApplicationWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.search_off,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.noApplicationFound,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Şoför olmak için bir başvuru yapmanız gerekmektedir.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: AppStrings.driverApplication,
              onPressed: () => context.go('/driver/application'),
              icon: Icons.add,
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: AppStrings.goHome,
              onPressed: () => context.go('/home'),
              outlined: true,
              icon: Icons.home,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationStatusWidget(
    BuildContext context,
    DriverApplication application,
    DriverProvider driverProvider,
  ) {
    final statusColor = driverProvider.getStatusColor(application.status);
    final statusText = driverProvider.getStatusText(application.status);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
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
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    _getStatusIcon(application.status),
                    size: 40,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.applicationStatus,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Application Details
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
                  'Başvuru Detayları',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                _buildDetailRow(
                  context,
                  AppStrings.applicationId,
                  '#${application.id.substring(application.id.length - 6)}',
                  Icons.confirmation_number,
                ),
                const SizedBox(height: 12),

                _buildDetailRow(
                  context,
                  AppStrings.tcKimlikNo,
                  application.tcKimlikNo,
                  Icons.badge,
                ),
                const SizedBox(height: 12),

                _buildDetailRow(
                  context,
                  AppStrings.ehliyetNo,
                  application.ehliyetNo,
                  Icons.credit_card,
                ),
                const SizedBox(height: 12),

                _buildDetailRow(
                  context,
                  AppStrings.applicationDate,
                  '${application.createdAt.day.toString().padLeft(2, '0')}/'
                  '${application.createdAt.month.toString().padLeft(2, '0')}/'
                  '${application.createdAt.year}',
                  Icons.calendar_today,
                ),

                if (application.updatedAt != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    context,
                    AppStrings.updateDate,
                    '${application.updatedAt!.day.toString().padLeft(2, '0')}/'
                    '${application.updatedAt!.month.toString().padLeft(2, '0')}/'
                    '${application.updatedAt!.year}',
                    Icons.update,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Status Message
          if (application.status == 'pending')
            _buildStatusMessageCard(
              context,
              'Başvurunuz İnceleniyor',
              'Başvurunuz inceleme sürecindedir. Sonuç hakkında en kısa sürede bilgilendirileceksiniz.',
              AppColors.warning,
              Icons.schedule,
            )
          else if (application.status == 'approved')
            _buildStatusMessageCard(
              context,
              'Başvurunuz Onaylandı!',
              'Tebrikler! Şoför başvurunuz onaylanmıştır. Artık sistemde şoför olarak yer alabilirsiniz.',
              AppColors.success,
              Icons.check_circle,
            )
          else if (application.status == 'rejected')
            _buildStatusMessageCard(
              context,
              'Başvurunuz Reddedildi',
              'Maalesef başvurunuz reddedilmiştir. Yeni bir başvuru yapabilir veya detaylar için iletişime geçebilirsiniz.',
              AppColors.error,
              Icons.cancel,
            ),

          const SizedBox(height: 24),

          // Action Buttons
          Column(
            children: [
              CustomButton(
                text: AppStrings.refreshStatus,
                onPressed: _loadApplicationStatus,
                icon: Icons.refresh,
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: AppStrings.simulateStatusChange,
                onPressed: _simulateStatusChange,
                outlined: true,
                icon: Icons.sync_alt,
              ),
              const SizedBox(height: 12),
              if (application.status == 'rejected')
                CustomButton(
                  text: AppStrings.newApplication,
                  onPressed: () {
                    driverProvider.resetApplication();
                    context.go('/driver/application');
                  },
                  backgroundColor: AppColors.secondary,
                  icon: Icons.add,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMessageCard(
    BuildContext context,
    String title,
    String message,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
