import 'package:video_player/video_player.dart';

class VideoService {
  VideoPlayerController? _controller;

  VideoPlayerController? get controller => _controller;

  Future<void> initializeVideo(String url) async {
    await dispose();

    _controller = VideoPlayerController.networkUrl(Uri.parse(url));

    await _controller!.initialize();
  }

  Future<void> play() async {
    await _controller?.play();
  }

  Future<void> pause() async {
    await _controller?.pause();
  }

  Future<void> seek(Duration position) async {
    await _controller?.seekTo(position);
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}
