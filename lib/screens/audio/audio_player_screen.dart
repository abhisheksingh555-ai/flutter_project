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
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _isInitialized = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final provider = context.read<AudioProvider>();
          provider.loadAudio(provider.currentTrack.audioUrl);
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
    final provider = context.watch<AudioProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Music Player'), centerTitle: true),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.hasError
          ? _buildErrorView(provider)
          : _buildPlayer(provider),
    );
  }

  Widget _buildErrorView(AudioProvider provider) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(provider.errorMessage ?? 'Unable to load audio'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              provider.loadAudio(provider.currentTrack.audioUrl);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer(AudioProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.music_note,
              size: 90,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            provider.currentTrack.title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          Text(
            provider.currentTrack.artist,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 20),

          StreamBuilder<Duration>(
            stream: provider.positionStream,
            builder: (context, positionSnapshot) {
              final position = positionSnapshot.data ?? Duration.zero;

              return StreamBuilder<Duration?>(
                stream: provider.durationStream,
                builder: (context, durationSnapshot) {
                  final duration = durationSnapshot.data ?? Duration.zero;
                  final maxValue = duration.inMilliseconds.toDouble();

                  final currentValue = position.inMilliseconds.toDouble().clamp(
                    0.0,
                    maxValue > 0 ? maxValue : 1.0,
                  );

                  return Column(
                    children: [
                      Slider(
                        min: 0,
                        max: maxValue > 0 ? maxValue : 1,
                        value: currentValue,
                        onChanged: maxValue > 0
                            ? (value) {
                                provider.seek(
                                  Duration(milliseconds: value.round()),
                                );
                              }
                            : null,
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

          const SizedBox(height: 16),

          StreamBuilder<PlayerState>(
            stream: provider.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final isPlaying = playerState?.playing ?? false;
              final isCompleted =
                  playerState?.processingState == ProcessingState.completed;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 32,
                    onPressed: provider.previousTrack,
                    icon: const Icon(Icons.skip_previous),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    iconSize: 40,
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
                  const SizedBox(width: 12),
                  IconButton(
                    iconSize: 32,
                    onPressed: provider.nextTrack,
                    icon: const Icon(Icons.skip_next),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 28),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'My Playlist',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          const SizedBox(height: 12),

          ...List.generate(provider.playlist.length, (index) {
            final track = provider.playlist[index];
            final isSelected = provider.currentIndex == index;

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(isSelected ? Icons.equalizer : Icons.music_note),
                ),
                title: Text(track.title),
                subtitle: Text(track.artist),
                trailing: isSelected
                    ? const Icon(Icons.graphic_eq)
                    : const Icon(Icons.play_arrow),
                selected: isSelected,
                onTap: () {
                  provider.playTrack(index);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
