import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PromotionWidget extends StatefulWidget {
  @override
  _PromotionWidgetState createState() => _PromotionWidgetState();
}

class _PromotionWidgetState extends State<PromotionWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Initialize the video player controller
    _controller = VideoPlayerController.asset(
      'images/video.mp4',
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Dispose the video player controller
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set the desired width and height for the video
      width: 300,
      height: 200,
      child: Stack(
        children: [
          // Video Player
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          // Play Button
          Positioned.fill(
            child: IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 50,
                color: Colors.transparent,
              ),
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

