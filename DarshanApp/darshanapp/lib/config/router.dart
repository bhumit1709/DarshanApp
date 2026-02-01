import 'package:go_router/go_router.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/darshan/presentation/screens/home_screen.dart';
import '../features/darshan/presentation/screens/player_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/settings/presentation/screens/manage_temples_screen.dart';

GoRouter createRouter(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/player/:templeId',
        builder: (context, state) {
          final templeId = state.pathParameters['templeId']!;
          return PlayerScreen(templeId: templeId);
        },
      ),
      GoRoute(
        path: '/manage-temples',
        builder: (context, state) => const ManageTemplesScreen(),
      ),
    ],
  );
}
