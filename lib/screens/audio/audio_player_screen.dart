import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';

import '../../providers/audio_provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  static const String _audioUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<AudioProvider>().loadAudio(_audioUrl);
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
    final audioProvider = context.watch<AudioProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Music Player'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: audioProvider.isLoading
              ? const CircularProgressIndicator()
              : audioProvider.hasError
              ? _buildErrorView(audioProvider)
              : _buildPlayer(audioProvider),
        ),
      ),
    );
  }

  Widget _buildErrorView(AudioProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, size: 60, color: Colors.red),
        const SizedBox(height: 16),
        Text(provider.errorMessage ?? 'Something went wrong'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => provider.loadAudio(_audioUrl),
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _buildPlayer(AudioProvider provider) {
    return StreamBuilder<PlayerState>(
      stream: provider.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;
        final isCompleted =
            playerState?.processingState == ProcessingState.completed;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 240,
              width: 240,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.music_note,
                size: 120,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'SoundHelix Song 1',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Sample Audio Track',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            StreamBuilder<Duration>(
              stream: provider.positionStream,
              builder: (context, positionSnapshot) {
                final position = positionSnapshot.data ?? Duration.zero;

                return StreamBuilder<Duration?>(
                  stream: provider.durationStream,
                  builder: (context, durationSnapshot) {
                    final duration = durationSnapshot.data ?? Duration.zero;

                    final maxValue = duration.inMilliseconds.toDouble();
                    final currentValue = position.inMilliseconds
                        .toDouble()
                        .clamp(0.0, maxValue > 0 ? maxValue : 1.0);

                    return Column(
                      children: [
                        Slider(
                          min: 0,
                          max: maxValue > 0 ? maxValue : 1,
                          value: currentValue,
                          onChanged: duration == Duration.zero
                              ? null
                              : (value) {
                                  provider.seek(
                                    Duration(milliseconds: value.round()),
                                  );
                                },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(position)),
                            Text(_formatDuration(duration)),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
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
                    if (isCompleted) {
                      provider.seek(Duration.zero).then((_) {
                        provider.play();
                      });
                    } else if (isPlaying) {
                      provider.pause();
                    } else {
                      provider.play();
                    }
                  },
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                ),
                const SizedBox(width: 24),
                IconButton(
                  iconSize: 36,
                  onPressed: () => provider.seek(Duration.zero),
                  icon: const Icon(Icons.stop),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
