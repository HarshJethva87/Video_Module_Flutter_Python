import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class SingleVideoDisplayScreen extends StatefulWidget {
  @override
  _SingleVideoDisplayScreenState createState() => _SingleVideoDisplayScreenState();
}

class _SingleVideoDisplayScreenState extends State<SingleVideoDisplayScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController = ChewieController(
    videoPlayerController: VideoPlayerController.network(''),
  );
  String _videoUrl = 'https://fdce-14-139-122-17.ngrok-free.app/watch';

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.network(_videoUrl);
    await _videoPlayerController.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
      );
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: _chewieController.videoPlayerController.value.isInitialized
          ? Chewie(controller: _chewieController)
          : Center(child: CircularProgressIndicator()),
    );
  }
}
