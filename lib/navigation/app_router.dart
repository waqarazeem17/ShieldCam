import 'package:go_router/go_router.dart';
import 'package:shieldcam/features/app_lock/app_lock_screen.dart';
import 'package:shieldcam/features/dashboard/dashboard_screen.dart';
import 'package:shieldcam/features/event_detail/event_detail_screen.dart';
import 'package:shieldcam/features/gallery/gallery_screen.dart';
import 'package:shieldcam/features/home/home_shell.dart';
import 'package:shieldcam/features/onboarding/onboarding_screen.dart';
import 'package:shieldcam/features/permissions/permission_request_screen.dart';
import 'package:shieldcam/features/settings/settings_screen.dart';
import 'package:shieldcam/features/settings/widgets/about_screen.dart';
import 'package:shieldcam/features/settings/widgets/battery_guide_screen.dart';
import 'package:shieldcam/features/settings/widgets/permission_manager_screen.dart';
import 'package:shieldcam/features/settings/widgets/privacy_policy_screen.dart';
import 'package:shieldcam/features/splash/splash_screen.dart';

/// Route names (typed route identifiers for future deep-link support).
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String permissions = '/permissions';
  static const String home = '/home';
  static const String dashboard = '/home/dashboard';
  static const String gallery = '/home/gallery';
  static const String settings = '/home/settings';
  static const String eventDetail = '/event/:id';
  static const String appLock = '/app-lock';

  static String eventDetailFor(int id) => '/event/$id';
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.permissions,
        name: 'permissions',
        builder: (context, state) => const PermissionRequestScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                name: 'dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.gallery,
                name: 'gallery',
                builder: (context, state) => const GalleryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.eventDetail,
        name: 'eventDetail',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return EventDetailScreen(eventId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.appLock,
        name: 'appLock',
        builder: (context, state) => const AppLockScreen(),
      ),
      GoRoute(
        path: '/settings/permissions',
        name: 'permissionsManager',
        builder: (context, state) => const PermissionManagerScreen(),
      ),
      GoRoute(
        path: '/settings/battery',
        name: 'batteryGuide',
        builder: (context, state) => const BatteryGuideScreen(),
      ),
      GoRoute(
        path: '/settings/privacy',
        name: 'privacyPolicy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/settings/about',
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
}
