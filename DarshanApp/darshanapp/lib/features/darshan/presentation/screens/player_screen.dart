import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/providers.dart';
import '../../domain/entities/temple.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final String templeId;
  const PlayerScreen({super.key, required this.templeId});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  YoutubePlayerController? _controller;
  bool _isPlayerReady = false;

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _initializePlayer(String videoUrl) {
    debugPrint('PlayerScreen: Initializing player with URL: $videoUrl');
    if (_controller != null) return;
    
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    debugPrint('PlayerScreen: Extracted Video ID: $videoId');
    if (videoId == null) return;

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        isLive: true, // Optimistic assumption for this MVP/spec, handled by flags usually
        forceHD: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
      //
    }
  }

  Future<void> _launchYoutubeUrl(String url) async {
    debugPrint('PlayerScreen: Launching external URL: $url');
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch YouTube')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(templeRepositoryProvider);
    
    return FutureBuilder(
      future: repo.getTempleById(widget.templeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Could not load temple data')),
          );
        }

        final temple = snapshot.data!;
        
        // Use FutureBuilder for dynamic video fetching
        return FutureBuilder<String?>(
          future: _getVideoUrl(ref, temple),
          builder: (context, urlSnapshot) {
            if (urlSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Fetching latest darshan...'),
                    ],
                  ),
                ),
              );
            }
            
            final videoUrl = urlSnapshot.data ?? temple.videoUrl;
            _initializePlayer(videoUrl);

            if (_controller == null) {
                 return Scaffold(
                    appBar: AppBar(title: Text(temple.name)),
                    body: const Center(child: Text('Invalid Video URL or No Video Found')),
                 );
            }

            return _buildPlayerUI(temple, videoUrl);
          }
        );
      },
    );
  }

  Future<String?> _getVideoUrl(WidgetRef ref, Temple temple) async {
    final youtubeService = ref.read(youtubeServiceProvider);
    // Try to get dynamic URL first
    final dynamicUrl = await youtubeService.getVideoUrl(temple.id);
    // Fallback to static URL from JSON if dynamic fetching fails or returns null
    return dynamicUrl ?? temple.videoUrl;
  }

  Widget _buildPlayerUI(Temple temple, String videoUrl) {
    return YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            onReady: () {
              _isPlayerReady = true;
            },
          ),
          builder: (context, player) {
            return Scaffold(
              appBar: AppBar(
                title: Text(temple.name),
                leading: const BackButton(),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.open_in_new),
                    tooltip: 'Open in YouTube',
                    onPressed: () => _launchYoutubeUrl(videoUrl),
                  ),
                ],
              ),
              body: Column(
                children: [
                   player,

                   Expanded(
                     child: SingleChildScrollView(
                       padding: const EdgeInsets.all(16),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             temple.name,
                             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           const SizedBox(height: 8),
                            Text(
                             temple.location,
                             style: Theme.of(context).textTheme.titleMedium?.copyWith(
                               color: Colors.grey,
                             ),
                           ),
                           const SizedBox(height: 16),
                           const Divider(),
                           const SizedBox(height: 16),
                           Text(
                             'Description',
                             style: Theme.of(context).textTheme.titleMedium?.copyWith(
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                            const SizedBox(height: 8),
                           Text(temple.description),
                         ],
                       ),
                     ),
                   ),
                ],
              ),
            );
          }
        );
  }
}
