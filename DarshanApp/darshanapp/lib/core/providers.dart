import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/user_preferences_service.dart';
import 'services/notification_service.dart';
import 'services/youtube_service.dart';
import '../../features/darshan/domain/repositories/i_temple_repository.dart';
import '../../features/darshan/data/repositories/json_temple_repository.dart';
import '../../features/darshan/domain/entities/temple.dart';

// Services
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

final userPreferencesServiceProvider = Provider<UserPreferencesService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return UserPreferencesService(prefs);
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final youtubeServiceProvider = Provider<YoutubeService>((ref) {
  final userPrefs = ref.watch(userPreferencesServiceProvider);
  return YoutubeService(userPrefs);
});

// Repositories
final templeRepositoryProvider = Provider<ITempleRepository>((ref) {
  return JsonTempleRepository();
});

final templesProvider = FutureProvider<List<Temple>>((ref) async {
  final repository = ref.watch(templeRepositoryProvider);
  return repository.getTemples();
});
