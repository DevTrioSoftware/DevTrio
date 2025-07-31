import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';

class RouteSelectionScreen extends StatefulWidget {
  const RouteSelectionScreen({super.key});

  @override
  State<RouteSelectionScreen> createState() => _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends State<RouteSelectionScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _routes = [
    {
      'type': 'Karayolu',
      'price': '₺2,150',
      'route': 'İzmir → Ankara (Direkt)',
      'time': '8-10 saat',
      'advantage': 'Güvenli',
      'icon': '🕒',
      'desc': '📦 Güvenli',
      'color': AppColors.primary,
      'timeColor': AppColors.primary,
    },
    {
      'type': 'Kombinasyon',
      'price': '₺1,890',
      'route': 'İzmir → İstanbul (Deniz) → Ankara (Kara)',
      'time': '2-3 gün',
      'advantage': 'Ekonomik',
      'icon': '🕒',
      'desc': '💰 Ekonomik',
      'color': AppColors.secondary,
      'timeColor': AppColors.secondary,
    },
    {
      'type': 'Denizyolu',
      'price': '₺1,650',
      'route': 'İzmir → Samsun → Ankara',
      'time': '4-5 gün',
      'advantage': 'Çevre Dostu',
      'icon': '🕒',
      'desc': '🌿 Çevre Dostu',
      'color': Colors.teal,
      'timeColor': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: const [
            Text(
              'Rota Seçenekleri',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Text(
              'En uygun rotayı seçiniz',
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
          children: [
            ...List.generate(_routes.length, (i) => _buildRouteCard(i)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () {
                  // Seçilen rota ile devam et
                  // Örneğin: Navigator.of(context).pushNamed('/tracking');
                },
                child: const Text(
                  'Seçilen Rotayı Onayla',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
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

  Widget _buildRouteCard(int i) {
    final route = _routes[i];
    final bool selected = _selectedIndex == i;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: selected ? Border.all(color: route['color'], width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: route['color'],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    route['type'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  route['price'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              route['route'],
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(route['icon'], style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 4),
                Text(
                  route['time'],
                  style: TextStyle(
                    fontSize: 14,
                    color: route['timeColor'],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Text(route['desc'], style: const TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
