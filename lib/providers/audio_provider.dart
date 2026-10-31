import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../data/audio_playlist.dart';
import '../models/audio_track_model.dart';
import '../services/audio_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();

  final List<AudioTrackModel> _playlist = audioPlaylist;

  int _currentIndex = 0;

  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  List<AudioTrackModel> get playlist => _playlist;

  int get currentIndex => _currentIndex;

  AudioTrackModel get currentTrack => _playlist[_currentIndex];

  Stream<PlayerState> get playerStateStream => _audioService.playerStateStream;

  Stream<Duration> get positionStream => _audioService.positionStream;

  Stream<Duration?> get durationStream => _audioService.durationStream;

  Stream<Duration> get bufferedPositionStream =>
      _audioService.bufferedPositionStream;

  Future<void> loadAudio(String url) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      await _audioService.loadAudio(url);
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Unable to load audio. Please try again.';
      debugPrint('Audio loading error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> playTrack(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    notifyListeners();

    await loadAudio(currentTrack.audioUrl);

    if (!_hasError) {
      await play();
    }
  }

  Future<void> nextTrack() async {
    final nextIndex = (_currentIndex + 1) % _playlist.length;
    await playTrack(nextIndex);
  }

  Future<void> previousTrack() async {
    final previousIndex =
        (_currentIndex - 1 + _playlist.length) % _playlist.length;

    await playTrack(previousIndex);
  }

  Future<void> play() async {
    try {
      await _audioService.play();
    } catch (e) {
      _setError('Unable to play audio.');
      debugPrint('Audio play error: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioService.pause();
    } catch (e) {
      _setError('Unable to pause audio.');
      debugPrint('Audio pause error: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioService.seek(position);
    } catch (e) {
      _setError('Unable to seek audio.');
      debugPrint('Audio seek error: $e');
    }
  }

  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
