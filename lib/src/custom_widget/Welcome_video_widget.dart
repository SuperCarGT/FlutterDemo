import 'package:flutter/material.dart';
import 'package:flutter_ho/src/utils/LogUtils.dart';
import 'package:video_player/video_player.dart';

class WelcomeVideoWidget extends StatefulWidget {
  @override
  _WelcomeVideoWidgetState createState() => _WelcomeVideoWidgetState();
}

class _WelcomeVideoWidgetState extends State<WelcomeVideoWidget> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/welcomeVideo.mp4')
      ..initialize().then((_) {
        LogUtils.e("视频加载完成");
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller.play();
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.initialized
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          )
        : Container();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
