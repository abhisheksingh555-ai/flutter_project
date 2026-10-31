import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Audio stream getters
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  Stream<Duration> get bufferedPositionStream =>
      _audioPlayer.bufferedPositionStream;

  // Current position
  Duration get position => _audioPlayer.position;

  // Audio duration
  Duration? get duration => _audioPlayer.duration;

  // Load audio from URL
  Future<void> loadAudio(String url) async {
    await _audioPlayer.setUrl(url);
  }

  // Play audio
  Future<void> play() async {
    await _audioPlayer.play();
  }

  // Pause audio
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  // Stop audio
  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  // Seek audio
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Dispose player
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
