import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/user_preferences_service.dart';
import 'core/services/notification_service.dart';
import 'core/providers.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Services
  final prefs = await SharedPreferences.getInstance();
  final userPreferences = UserPreferencesService(prefs);
  await NotificationService().initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: MyApp(hasCompletedOnboarding: userPreferences.hasCompletedOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool hasCompletedOnboarding;
  
  const MyApp({super.key, required this.hasCompletedOnboarding});

  @override
  Widget build(BuildContext context) {
    final  router = createRouter(hasCompletedOnboarding ? '/home' : '/onboarding');
    
    return MaterialApp.router(
      title: 'Daily Darshan',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
