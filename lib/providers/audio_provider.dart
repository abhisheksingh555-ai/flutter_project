import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../services/audio_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();

  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

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
