import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/cargo/screens/cargo_form_screen.dart';
import '../../features/cargo/screens/route_selection_screen.dart';
import '../../features/tracking/screens/tracking_screen.dart';
import '../../features/driver/screens/driver_application_screen.dart';
import '../../features/driver/screens/driver_application_success_screen.dart';
import '../../features/driver/screens/driver_tracking_screen.dart';
import '../../features/driver/screens/driver_map_screen.dart';
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/admin/screens/driver_applications_management_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/profile_edit_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/cargo',
        builder: (context, state) => const CargoFormScreen(),
      ),
      GoRoute(
        path: '/routes',
        builder: (context, state) => const RouteSelectionScreen(),
      ),
      GoRoute(
        path: '/tracking',
        builder: (context, state) => const TrackingScreen(),
      ),
      GoRoute(
        path: '/driver/application',
        builder: (context, state) => const DriverApplicationScreen(),
      ),
      GoRoute(
        path: '/driver/success',
        builder: (context, state) => const DriverApplicationSuccessScreen(),
      ),
      GoRoute(
        path: '/driver/tracking',
        builder: (context, state) => const DriverTrackingScreen(),
      ),
      GoRoute(
        path: '/driver/map',
        builder: (context, state) => const DriverMapScreen(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/driver-applications',
        builder: (context, state) => const DriverApplicationsManagementScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const ProfileEditScreen(),
      ),
    ],
  );
}
