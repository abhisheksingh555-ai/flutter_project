import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../providers/video_provider.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  static const String _videoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _isInitialized = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<VideoProvider>().initializeVideo(_videoUrl);
        }
      });
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VideoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Video Player'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: provider.isLoading
              ? const CircularProgressIndicator()
              : provider.hasError
              ? _buildErrorView(provider)
              : _buildVideoPlayer(provider),
        ),
      ),
    );
  }

  Widget _buildErrorView(VideoProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, size: 60, color: Colors.red),
        const SizedBox(height: 16),
        Text(provider.errorMessage ?? 'Unable to load video'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => provider.initializeVideo(_videoUrl),
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer(VideoProvider provider) {
    final controller = provider.controller;

    if (controller == null || !controller.value.isInitialized) {
      return const Text('Video is not available');
    }

    final videoValue = controller.value;
    final duration = videoValue.duration;
    final position = videoValue.position;

    final maxValue = duration.inMilliseconds.toDouble();

    final currentValue = position.inMilliseconds.toDouble().clamp(
      0.0,
      maxValue > 0 ? maxValue : 1.0,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: videoValue.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),

        const SizedBox(height: 24),

        Text('Sample Video', style: Theme.of(context).textTheme.headlineSmall),

        const SizedBox(height: 16),

        Slider(
          min: 0,
          max: maxValue > 0 ? maxValue : 1,
          value: currentValue,
          onChanged: (value) {
            provider.seek(Duration(milliseconds: value.round()));
          },
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDuration(position)),
            Text(_formatDuration(duration)),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 36,
              onPressed: () => provider.seek(Duration.zero),
              icon: const Icon(Icons.replay),
            ),

            const SizedBox(width: 24),

            IconButton.filled(
              iconSize: 42,
              onPressed: () {
                if (videoValue.isPlaying) {
                  provider.pause();
                } else {
                  if (videoValue.isCompleted) {
                    provider.seek(Duration.zero).then((_) {
                      provider.play();
                    });
                  } else {
                    provider.play();
                  }
                }
              },
              icon: Icon(videoValue.isPlaying ? Icons.pause : Icons.play_arrow),
            ),

            const SizedBox(width: 24),

            IconButton(
              iconSize: 36,
              onPressed: () {
                provider.pause();
                provider.seek(Duration.zero);
              },
              icon: const Icon(Icons.stop),
            ),
          ],
        ),
      ],
    );
  }
}
