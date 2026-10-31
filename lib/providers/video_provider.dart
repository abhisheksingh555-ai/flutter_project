import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../services/video_service.dart';

class VideoProvider extends ChangeNotifier {
  final VideoService _videoService = VideoService();

  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  VideoPlayerController? get controller => _videoService.controller;

  Future<void> initializeVideo(String url) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      await _videoService.initializeVideo(url);

      controller?.addListener(_onVideoChanged);
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Unable to load video. Please try again.';
      debugPrint('Video initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onVideoChanged() {
    notifyListeners();
  }

  Future<void> play() async {
    try {
      await _videoService.play();
    } catch (e) {
      debugPrint('Video play error: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _videoService.pause();
    } catch (e) {
      debugPrint('Video pause error: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _videoService.seek(position);
    } catch (e) {
      debugPrint('Video seek error: $e');
    }
  }

  @override
  void dispose() {
    _videoService.dispose();
    super.dispose();
  }
}
