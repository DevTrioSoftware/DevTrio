import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: const [
            Text(
              'Gönderi Takibi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Text(
              'TR-2025-001234',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStep(
              icon: Icons.check_circle,
              color: AppColors.success,
              title: 'Yük Teslim Alındı',
              date: '04.07.2025 - 09:30',
              done: true,
            ),
            _buildStep(
              icon: Icons.check_circle,
              color: AppColors.success,
              title: 'Depodan Çıktı',
              date: '04.07.2025 - 11:45',
              done: true,
            ),
            _buildStep(
              icon: Icons.local_shipping,
              color: AppColors.primary,
              title: 'Yolda',
              date: 'Manisa - Ankara arası',
              done: false,
            ),
            _buildStep(
              icon: Icons.location_on,
              color: AppColors.secondary,
              title: 'Ankara Dağıtım Merkezine Ulaştı',
              date: 'Beklenen: 05.07.2025',
              done: false,
            ),
            _buildStep(
              icon: Icons.inventory_2,
              color: Colors.brown,
              title: 'Teslim Edildi',
              date: 'Beklenen: 05.07.2025',
              done: false,
            ),
            const SizedBox(height: 24),
            Text(
              'Taşıyıcı Bilgileri',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hızlı Lojistik A.Ş.'),
                  Text('Şoför: Mehmet Yılmaz'),
                  Text('Plaka: 35 ABC 123'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/cargo');
              break;
            case 2:
              context.go('/routes');
              break;
            case 3:
              context.go('/tracking');
              break;
          }
        },
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required Color color,
    required String title,
    required String date,
    required bool done,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
