import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/admin_provider.dart';
import '../../../core/models/driver_model.dart';

class DriverApplicationsManagementScreen extends StatefulWidget {
  const DriverApplicationsManagementScreen({super.key});

  @override
  State<DriverApplicationsManagementScreen> createState() =>
      _DriverApplicationsManagementScreenState();
}

class _DriverApplicationsManagementScreenState
    extends State<DriverApplicationsManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(
        context,
        listen: false,
      ).loadDriverApplications();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.driverApplications),
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
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<AdminProvider>(
                context,
                listen: false,
              ).loadDriverApplications();
            },
            tooltip: 'Yenile',
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => context.go('/admin/dashboard'),
            tooltip: 'Admin Panel',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              icon: const Icon(Icons.schedule),
              text: AppStrings.pendingApplications.replaceAll(
                ' Başvurular',
                '',
              ),
            ),
            Tab(
              icon: const Icon(Icons.check_circle),
              text: AppStrings.approvedApplications.replaceAll(
                ' Başvurular',
                '',
              ),
            ),
            Tab(
              icon: const Icon(Icons.cancel),
              text: AppStrings.rejectedApplications.replaceAll(
                ' Başvurular',
                '',
              ),
            ),
          ],
        ),
      ),
      body: Consumer<AdminProvider>(
        builder: (context, adminProvider, child) {
          if (adminProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildApplicationsList(
                context,
                adminProvider.pendingApplications,
                adminProvider,
              ),
              _buildApplicationsList(
                context,
                adminProvider.approvedApplications,
                adminProvider,
              ),
              _buildApplicationsList(
                context,
                adminProvider.rejectedApplications,
                adminProvider,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildApplicationsList(
    BuildContext context,
    List<DriverApplication> applications,
    AdminProvider adminProvider,
  ) {
    if (applications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Bu kategoride başvuru bulunmuyor',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];
        return _buildApplicationCard(context, application, adminProvider);
      },
    );
  }

  Widget _buildApplicationCard(
    BuildContext context,
    DriverApplication application,
    AdminProvider adminProvider,
  ) {
    final statusColor = adminProvider.getStatusColor(application.status);
    final statusText = adminProvider.getStatusText(application.status);
    final statusIcon = adminProvider.getStatusIcon(application.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header with status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Başvuru #${application.id.substring(application.id.length - 4)}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showApplicationDetails(context, application),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Application details
          _buildDetailRow(
            context,
            AppStrings.tcKimlikNo,
            application.tcKimlikNo,
            Icons.badge,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            context,
            AppStrings.ehliyetNo,
            application.ehliyetNo,
            Icons.credit_card,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            context,
            AppStrings.applicationDate,
            _formatDate(application.createdAt),
            Icons.calendar_today,
          ),
          if (application.updatedAt != null) ...[
            const SizedBox(height: 8),
            _buildDetailRow(
              context,
              AppStrings.updateDate,
              _formatDate(application.updatedAt!),
              Icons.update,
            ),
          ],

          const SizedBox(height: 16),

          // Action buttons
          if (application.status == 'pending') ...[
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: AppStrings.approve,
                    backgroundColor: AppColors.success,
                    onPressed: () => _showConfirmationDialog(
                      context,
                      AppStrings.confirmApproval,
                      () => _approveApplication(
                        context,
                        application.id,
                        adminProvider,
                      ),
                    ),
                    icon: Icons.check,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: AppStrings.reject,
                    backgroundColor: AppColors.error,
                    onPressed: () => _showConfirmationDialog(
                      context,
                      AppStrings.confirmRejection,
                      () => _rejectApplication(
                        context,
                        application.id,
                        adminProvider,
                      ),
                    ),
                    icon: Icons.close,
                    height: 40,
                  ),
                ),
              ],
            ),
          ] else ...[
            CustomButton(
              text: AppStrings.viewDetails,
              outlined: true,
              onPressed: () => _showApplicationDetails(context, application),
              icon: Icons.visibility,
              height: 40,
            ),
          ],
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
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void _showConfirmationDialog(
    BuildContext context,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Onay'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text('Evet'),
            ),
          ],
        );
      },
    );
  }

  void _approveApplication(
    BuildContext context,
    String applicationId,
    AdminProvider adminProvider,
  ) async {
    final success = await adminProvider.approveApplication(applicationId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.applicationApproved),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(adminProvider.errorMessage ?? 'Bir hata oluştu'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _rejectApplication(
    BuildContext context,
    String applicationId,
    AdminProvider adminProvider,
  ) async {
    final success = await adminProvider.rejectApplication(applicationId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.applicationRejected),
          backgroundColor: AppColors.error,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(adminProvider.errorMessage ?? 'Bir hata oluştu'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showApplicationDetails(
    BuildContext context,
    DriverApplication application,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildApplicationDetailsModal(context, application),
    );
  }

  Widget _buildApplicationDetailsModal(
    BuildContext context,
    DriverApplication application,
  ) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final statusColor = adminProvider.getStatusColor(application.status);
    final statusText = adminProvider.getStatusText(application.status);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          adminProvider.getStatusIcon(application.status),
                          color: statusColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Başvuru Detayları',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                            Text(
                              '#${application.id}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Details
                  _buildModalDetailRow(
                    context,
                    AppStrings.tcKimlikNo,
                    application.tcKimlikNo,
                  ),
                  _buildModalDetailRow(
                    context,
                    AppStrings.ehliyetNo,
                    application.ehliyetNo,
                  ),
                  _buildModalDetailRow(
                    context,
                    AppStrings.applicationDate,
                    _formatDate(application.createdAt),
                  ),
                  if (application.updatedAt != null)
                    _buildModalDetailRow(
                      context,
                      AppStrings.updateDate,
                      _formatDate(application.updatedAt!),
                    ),

                  const Spacer(),

                  // Actions
                  if (application.status == 'pending') ...[
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: AppStrings.approve,
                            backgroundColor: AppColors.success,
                            onPressed: () {
                              Navigator.pop(context);
                              _showConfirmationDialog(
                                context,
                                AppStrings.confirmApproval,
                                () => _approveApplication(
                                  context,
                                  application.id,
                                  adminProvider,
                                ),
                              );
                            },
                            icon: Icons.check,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: AppStrings.reject,
                            backgroundColor: AppColors.error,
                            onPressed: () {
                              Navigator.pop(context);
                              _showConfirmationDialog(
                                context,
                                AppStrings.confirmRejection,
                                () => _rejectApplication(
                                  context,
                                  application.id,
                                  adminProvider,
                                ),
                              );
                            },
                            icon: Icons.close,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    CustomButton(
                      text: 'Kapat',
                      outlined: true,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModalDetailRow(
    BuildContext context,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
