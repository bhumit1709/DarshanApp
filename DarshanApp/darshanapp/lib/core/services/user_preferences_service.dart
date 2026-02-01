import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _kOnboardingCompleted = 'onboarding_completed';
  static const String _kSelectedTemples = 'selected_temples';
  static const String _kNotificationsEnabled = 'notifications_enabled';
  
  final SharedPreferences _prefs;

  UserPreferencesService(this._prefs);

  static Future<UserPreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return UserPreferencesService(prefs);
  }

  bool get hasCompletedOnboarding => _prefs.getBool(_kOnboardingCompleted) ?? false;
  
  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(_kOnboardingCompleted, value);
  }

  List<String> get selectedTempleIds => _prefs.getStringList(_kSelectedTemples) ?? [];

  Future<void> setSelectedTemples(List<String> ids) async {
    await _prefs.setStringList(_kSelectedTemples, ids);
  }

  bool get areNotificationsEnabled => _prefs.getBool(_kNotificationsEnabled) ?? false;

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(_kNotificationsEnabled, value);
  }
  static const String _kShrinathjiVideoUrl = 'shrinathji_video_url';
  static const String _kShrinathjiFetchTimestamp = 'shrinathji_fetch_timestamp';

  String? get cachedShrinathjiVideoUrl => _prefs.getString(_kShrinathjiVideoUrl);

  Future<void> setShrinathjiVideoUrl(String url) async {
    await _prefs.setString(_kShrinathjiVideoUrl, url);
  }

  DateTime? get lastShrinathjiFetchTime {
    final timestamp = _prefs.getInt(_kShrinathjiFetchTimestamp);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<void> setShrinathjiFetchTime(DateTime time) async {
    await _prefs.setInt(_kShrinathjiFetchTimestamp, time.millisecondsSinceEpoch);
  }

  static const String _kRamMandirVideoUrl = 'ram_mandir_video_url';
  static const String _kRamMandirFetchTimestamp = 'ram_mandir_fetch_timestamp';

  String? get cachedRamMandirVideoUrl => _prefs.getString(_kRamMandirVideoUrl);

  Future<void> setRamMandirVideoUrl(String url) async {
    await _prefs.setString(_kRamMandirVideoUrl, url);
  }

  DateTime? get lastRamMandirFetchTime {
    final timestamp = _prefs.getInt(_kRamMandirFetchTimestamp);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<void> setRamMandirFetchTime(DateTime time) async {
    await _prefs.setInt(_kRamMandirFetchTimestamp, time.millisecondsSinceEpoch);
  }

  // Kashi Vishwanath
  static const String _kKashiVideoUrl = 'kashi_video_url';
  static const String _kKashiFetchTimestamp = 'kashi_fetch_timestamp';
  String? get cachedKashiVideoUrl => _prefs.getString(_kKashiVideoUrl);
  Future<void> setKashiVideoUrl(String url) async => await _prefs.setString(_kKashiVideoUrl, url);
  DateTime? get lastKashiFetchTime {
    final timestamp = _prefs.getInt(_kKashiFetchTimestamp);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }
  Future<void> setKashiFetchTime(DateTime time) async => await _prefs.setInt(_kKashiFetchTimestamp, time.millisecondsSinceEpoch);

  // Siddhivinayak
  static const String _kSiddhivinayakVideoUrl = 'siddhivinayak_video_url';
  static const String _kSiddhivinayakFetchTimestamp = 'siddhivinayak_fetch_timestamp';
  String? get cachedSiddhivinayakVideoUrl => _prefs.getString(_kSiddhivinayakVideoUrl);
  Future<void> setSiddhivinayakVideoUrl(String url) async => await _prefs.setString(_kSiddhivinayakVideoUrl, url);
  DateTime? get lastSiddhivinayakFetchTime {
    final timestamp = _prefs.getInt(_kSiddhivinayakFetchTimestamp);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }
  Future<void> setSiddhivinayakFetchTime(DateTime time) async => await _prefs.setInt(_kSiddhivinayakFetchTimestamp, time.millisecondsSinceEpoch);

  // Mahakaleshwar
  static const String _kMahakaleshwarVideoUrl = 'mahakaleshwar_video_url';
  static const String _kMahakaleshwarFetchTimestamp = 'mahakaleshwar_fetch_timestamp';
  String? get cachedMahakaleshwarVideoUrl => _prefs.getString(_kMahakaleshwarVideoUrl);
  Future<void> setMahakaleshwarVideoUrl(String url) async => await _prefs.setString(_kMahakaleshwarVideoUrl, url);
  DateTime? get lastMahakaleshwarFetchTime {
    final timestamp = _prefs.getInt(_kMahakaleshwarFetchTimestamp);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }
  Future<void> setMahakaleshwarFetchTime(DateTime time) async => await _prefs.setInt(_kMahakaleshwarFetchTimestamp, time.millisecondsSinceEpoch);

  // Tirupati Balaji
  static const String _kTirupatiVideoUrl = 'tirupati_video_url';
  static const String _kTirupatiFetchTimestamp = 'tirupati_fetch_timestamp';
  String? get cachedTirupatiVideoUrl => _prefs.getString(_kTirupatiVideoUrl);
  Future<void> setTirupatiVideoUrl(String url) async => await _prefs.setString(_kTirupatiVideoUrl, url);
  DateTime? get lastTirupatiFetchTime {
    final timestamp = _prefs.getInt(_kTirupatiFetchTimestamp);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }
  Future<void> setTirupatiFetchTime(DateTime time) async => await _prefs.setInt(_kTirupatiFetchTimestamp, time.millisecondsSinceEpoch);

  // Golden Temple
  static const String _kGoldenTempleVideoUrl = 'golden_temple_video_url';
  static const String _kGoldenTempleFetchTimestamp = 'golden_temple_fetch_timestamp';
  String? get cachedGoldenTempleVideoUrl => _prefs.getString(_kGoldenTempleVideoUrl);
  Future<void> setGoldenTempleVideoUrl(String url) async => await _prefs.setString(_kGoldenTempleVideoUrl, url);
  DateTime? get lastGoldenTempleFetchTime {
    final timestamp = _prefs.getInt(_kGoldenTempleFetchTimestamp);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }
  Future<void> setGoldenTempleFetchTime(DateTime time) async => await _prefs.setInt(_kGoldenTempleFetchTimestamp, time.millisecondsSinceEpoch);
}
