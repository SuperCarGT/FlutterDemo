import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ho/src/utils/LogUtils.dart';
import 'package:video_player/video_player.dart';

typedef videoCallback = void Function();

class VideoDetailWidget extends StatefulWidget {
  final StreamController streamController;

  VideoDetailWidget({@required this.streamController});

  @override
  _VideoDetailWidgetState createState() => _VideoDetailWidgetState();
}

class _VideoDetailWidgetState extends State<VideoDetailWidget> {
  VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // widget.streamControll
  }

  startUpVideoPlayer(videoCallback callback) {
    _controller = VideoPlayerController.asset('assets/video/welcom.mp4');
    _controller.initialize().then((_) {
      LogUtils.e("视频加载完成");
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      // _controller.play();
      callback();
    });
    _controller.setLooping(true);

    _controller.addListener(() {
      if (_isPlaying && !_controller.value.isPlaying) {
        _isPlaying = false;
        setState(() {});
      }
    });
  }

  startPlay() {
    setState(() {
      _isPlaying = true;
      if (widget.streamController != null)
        widget.streamController.add(_controller);

      Duration postion = _controller.value.position;
      Duration duration = _controller.value.duration;
      if (postion == duration) {
        _controller.seekTo(Duration.zero);
      }

      _controller.play();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 第一层视频
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _controller.pause();
                _isPlaying = false;
              });
            },
            child: _controller == null ? Container():buildVideoAspectRatio(),
          ),
        ),

        // 第三层按钮
        buildVideoControlWidget(),
      ],
    );
  }

  AspectRatio buildVideoAspectRatio() {
    return AspectRatio(
            aspectRatio: _controller != null ? _controller.value.aspectRatio:16.0/9.0,
            child: VideoPlayer(_controller),
          );
  }

  Widget buildVideoControlWidget() {
    if (_isPlaying) {
      return Container();
    }

    return Positioned.fill(
      child: Stack(
        children: [
          // 第二层展位图
          Positioned.fill(
            child: Image.asset(
              "assets/images/app_icon.png",
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () {

                if (_controller == null) {
                  startUpVideoPlayer(() {
                    startPlay();
                  });
                } else {
                  startPlay();
                }
              },
              child: Container(
                child: Icon(
                  Icons.play_circle_fill,
                  size: 44,
                ),
                color: Colors.blueGrey.withOpacity(0.7),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
    }
  }
}
