import 'package:go_router/go_router.dart';
import 'view/admin_dashboard_screen.dart';
import 'view/admin_login_screen.dart';

class AdminRouter {
  static const login = '/admin/login';
  static const dashboard = '/admin/dashboard';

  static final router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: dashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
}
