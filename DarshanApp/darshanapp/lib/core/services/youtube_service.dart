import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'user_preferences_service.dart';

class YoutubeService {
  final YoutubeExplode _yt;

  final UserPreferencesService _prefs;

  YoutubeService(this._prefs, [YoutubeExplode? yt]) : _yt = yt ?? YoutubeExplode();

  // Constants for Handles
  static const String _kShrinathjiHandle = '@SanskargroupInOfficial';
  static const String _kRamMandirHandle = '@srjbtkshetra';
  static const String _kKashiHandle = '@ShriKashiVishwanathTempleTrust';
  static const String _kSiddhivinayakHandle = '@SiddhivinayakGanapati';
  static const String _kMahakaleshwarHandle = '@mahakaleshwarujjain';
  static const String _kTirupatiHandle = '@SVBCTTD';
  static const String _kGoldenTempleHandle = '@sgpcamritsar';

  Future<String?> getVideoUrl(String templeId) async {
    switch (templeId) {
      case 't_shrinathji':
        return _fetchVideo(
          handle: _kShrinathjiHandle,
          keywords: ['Shrinath Ji Darshan', 'Shreenath Ji Darshan', 'Shrinathji'],
          cacheKey: 'shrinathji',
        );
      case 't_ram_mandir':
        return _fetchVideo(
          handle: _kRamMandirHandle,
          keywords: ['sringaar aarti', 'morning arti', 'ram lalla'],
          cacheKey: 'ram_mandir',
        );
      case 't_001': // Kashi Vishwanath
        return _fetchVideo(
          handle: _kKashiHandle, // Might need to fallback to search if handles are tricky
          keywords: ['mangala aarti', 'live', 'darshan'],
          cacheKey: 'kashi',
        );
        case 't_002': // Siddhivinayak
        return _fetchVideo(
          handle: _kSiddhivinayakHandle,
          keywords: ['kakad aarti', 'live', 'darshan'],
          cacheKey: 'siddhivinayak',
        );
        case 't_003': // Mahakaleshwar
        return _fetchVideo(
          handle: _kMahakaleshwarHandle,
          keywords: ['bhasma aarti', 'live', 'darshan'],
          cacheKey: 'mahakaleshwar',
        );
         case 't_004': // Tirupati Balaji
        return _fetchVideo(
          handle: _kTirupatiHandle,
          keywords: ['suprabhatam', 'kalyanotsavam', 'live'],
          cacheKey: 'tirupati',
        );
         case 't_005': // Golden Temple
        return _fetchVideo(
          handle: _kGoldenTempleHandle,
          keywords: ['hukamnama', 'live', 'kirtan'],
          cacheKey: 'golden_temple',
        );
      default:
        return null;
    }
  }

  // Backwards compatibility if needed, or redirect
  Future<String?> getShrinathjiVideoUrl() => getVideoUrl('t_shrinathji');

  Future<String?> _fetchVideo({
    required String handle,
    required List<String> keywords,
    required String cacheKey,
  }) async {
    // 1. Check cache
    final DateTime? lastFetch = _getLastFetchTime(cacheKey);
    final String? cachedUrl = _getCachedUrl(cacheKey);
    final now = DateTime.now();

    if (lastFetch != null && cachedUrl != null) {
      final difference = now.difference(lastFetch);
      if (difference.inHours < 2) {
        debugPrint('YoutubeService: Cache hit for $cacheKey. Returning: $cachedUrl');
        return cachedUrl;
      }
    }

    // 2. Fetch fresh
    debugPrint('YoutubeService: Fetching fresh video for $handle with keywords: $keywords');
    try {
      // Primary Strategy: Playlist/Channel Scraping
      try {
        String channelId;
        if (handle == _kShrinathjiHandle) {
           channelId = 'UCT_QwW7Tbew5qrYNb2auqAQ';
        } else {
           final channel = await _yt.channels.getByHandle(handle);
           channelId = channel.id.value;
        }
        
        final playlistId = channelId.replaceFirst('UC', 'UU');
        debugPrint('YoutubeService: Attempting playlist fetch: $playlistId');

        final uploads = await _yt.playlists.getVideos(playlistId).take(20).toList();
        
        for (final video in uploads) {
          if (_matchesKeywords(video.title, keywords)) {
            return await _cacheAndReturn(video.url, cacheKey, video.title);
          }
        }
        debugPrint('YoutubeService: No match in playlist. Switching to Search Strategy.');
      } catch (e) {
        debugPrint('YoutubeService: Playlist fetch failed ($e). Switching to Search Strategy.');
      }
        
      // Secondary Strategy: Search
      // Query: "Handle Keyword" (e.g. "@SanskargroupInOfficial Shreenath ji darshan")
      final query = '$handle ${keywords.join(" ")}';
      debugPrint('YoutubeService: Searching with query: "$query"');
      
      final searchResults = await _yt.search.search(query);
      final topVideos = searchResults.take(10).toList();
      
      for (final video in topVideos) {
          debugPrint('YoutubeService: Search Result: "${video.title}" by ${video.author}');
          // Check if it matches keywords AND belongs to the correct channel (approximate check)
          if (_matchesKeywords(video.title, keywords)) {
              return await _cacheAndReturn(video.url, cacheKey, video.title);
          }
      }
      
      debugPrint('YoutubeService: No matching video found for $handle. Returning cached: $cachedUrl');
      return cachedUrl;
    } catch (e) {
      debugPrint('YoutubeService: Critical error in _fetchVideo: $e');
      return cachedUrl;
    }
  }

  bool _matchesKeywords(String title, List<String> keywords) {
    title = title.toLowerCase();
    return keywords.any((k) => title.contains(k.toLowerCase()));
  }

  Future<String> _cacheAndReturn(String url, String cacheKey, String title) async {
    debugPrint('YoutubeService: MATCH FOUND: "$title" -> $url');
    await _setCachedUrl(cacheKey, url);
    await _setLastFetchTime(cacheKey, DateTime.now());
    return url;
  }

  DateTime? _getLastFetchTime(String key) {
    switch (key) {
      case 'shrinathji': return _prefs.lastShrinathjiFetchTime;
      case 'ram_mandir': return _prefs.lastRamMandirFetchTime;
      case 'kashi': return _prefs.lastKashiFetchTime;
      case 'siddhivinayak': return _prefs.lastSiddhivinayakFetchTime;
      case 'mahakaleshwar': return _prefs.lastMahakaleshwarFetchTime;
      case 'tirupati': return _prefs.lastTirupatiFetchTime;
      case 'golden_temple': return _prefs.lastGoldenTempleFetchTime;
      default: return null;
    }
  }

  String? _getCachedUrl(String key) {
    switch (key) {
      case 'shrinathji': return _prefs.cachedShrinathjiVideoUrl;
      case 'ram_mandir': return _prefs.cachedRamMandirVideoUrl;
      case 'kashi': return _prefs.cachedKashiVideoUrl;
      case 'siddhivinayak': return _prefs.cachedSiddhivinayakVideoUrl;
      case 'mahakaleshwar': return _prefs.cachedMahakaleshwarVideoUrl;
      case 'tirupati': return _prefs.cachedTirupatiVideoUrl;
      case 'golden_temple': return _prefs.cachedGoldenTempleVideoUrl;
      default: return null;
    }
  }

  Future<void> _setCachedUrl(String key, String url) async {
     switch (key) {
      case 'shrinathji': await _prefs.setShrinathjiVideoUrl(url); break;
      case 'ram_mandir': await _prefs.setRamMandirVideoUrl(url); break;
      case 'kashi': await _prefs.setKashiVideoUrl(url); break;
      case 'siddhivinayak': await _prefs.setSiddhivinayakVideoUrl(url); break;
      case 'mahakaleshwar': await _prefs.setMahakaleshwarVideoUrl(url); break;
      case 'tirupati': await _prefs.setTirupatiVideoUrl(url); break;
      case 'golden_temple': await _prefs.setGoldenTempleVideoUrl(url); break;
    }
  }
  
  Future<void> _setLastFetchTime(String key, DateTime time) async {
     switch (key) {
      case 'shrinathji': await _prefs.setShrinathjiFetchTime(time); break;
      case 'ram_mandir': await _prefs.setRamMandirFetchTime(time); break;
      case 'kashi': await _prefs.setKashiFetchTime(time); break;
      case 'siddhivinayak': await _prefs.setSiddhivinayakFetchTime(time); break;
      case 'mahakaleshwar': await _prefs.setMahakaleshwarFetchTime(time); break;
      case 'tirupati': await _prefs.setTirupatiFetchTime(time); break;
      case 'golden_temple': await _prefs.setGoldenTempleFetchTime(time); break;
    }
  }

  void dispose() {
    _yt.close();
  }
}
