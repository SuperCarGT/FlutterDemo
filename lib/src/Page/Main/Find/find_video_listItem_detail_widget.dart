import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ho/src/utils/LogUtils.dart';
import 'package:video_player/video_player.dart';

typedef videoCallback = void Function();

class FindListVideoDetailWidget extends StatefulWidget {
  final StreamController streamController;

  FindListVideoDetailWidget({@required this.streamController});

  @override
  _FindListVideoDetailWidgetState createState() =>
      _FindListVideoDetailWidgetState();
}

class _FindListVideoDetailWidgetState extends State<FindListVideoDetailWidget> {
  StreamController<UserInterfaceStreamModel> UserInherfaceStream;

  VideoPlayerController _controller;
  bool _isFirst = true;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    UserInherfaceStream =
        StreamController<UserInterfaceStreamModel>.broadcast();
    // widget.streamControll
  }

  startUpVideoPlayer(videoCallback callback) async {
    _controller = VideoPlayerController.asset('assets/video/welcom.mp4');
    _controller.initialize().then((_) {
      LogUtils.e("视频加载完成");
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      // _controller.play();
      callback();
    });
    _controller.setLooping(true);

    // _controller.addListener(() {
    //
    // });
  }

  startPlay() {
    _isFirst = false;
    setState(() {
      _isPlaying = true;
      if (widget.streamController != null)
        widget.streamController.add(_controller);
      //
      // Duration postion = _controller.value.position;
      // Duration duration = _controller.value.duration;
      // if (postion == duration) {
      //   _controller.seekTo(Duration.zero);
      // }
      //
      _controller.play();
      UserInherfaceStream.add(UserInterfaceStreamModel(isPlaying: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 第一层视频
        Positioned.fill(
          child: _controller == null ? Container() : buildVideoAspectRatio(),
        ),

        // 第二层按钮 如果是一开始播放的显示占位图和开始  如果是暂停的是另外一组UI
        _isFirst ? buildVideoControlWidget() : buildPlayingControlWidget(),
      ],
    );
  }

  /// 视频渲染层
  AspectRatio buildVideoAspectRatio() {
    return AspectRatio(
      aspectRatio:
          _controller != null ? _controller.value.aspectRatio : 16.0 / 9.0,
      child: VideoPlayer(_controller),
    );
  }

  /// 占位图层
  Widget buildVideoControlWidget() {
    return Positioned.fill(
      child: Stack(
        children: [
          /// 第二层占位图
          Positioned.fill(
            child: Image.asset(
              "assets/images/app_icon.png",
              fit: BoxFit.fitWidth,
            ),
          ),

          /// 第三层控制层
          Positioned.fill(
            child: Container(
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
                child: Theme(
                  data: ThemeData(
                    iconTheme: IconThemeData(color: Colors.blue),
                  ),
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 44,
                  ),
                ),
              ),
              color: Colors.blueGrey.withOpacity(0.7),
            ),
          )
        ],
      ),
    );
  }

  double _opacity = 1.0;
  Timer _timer;

  /// 当点击播放时 显示的控制层 包括时间、进度条、全屏
  Widget buildPlayingControlWidget() {
    if (_controller.value.isPlaying) {
      if (_timer != null && _timer.isActive) {
        _timer.cancel();
      }
      _timer = Timer(Duration(seconds: 3), () {
        setState(() {
          _opacity = 0.0;
        });
      });
    }

    return StreamBuilder<UserInterfaceStreamModel>(
      initialData: UserInterfaceStreamModel(isPlaying: true),
      stream: UserInherfaceStream.stream,
      builder: (BuildContext context,
          AsyncSnapshot<UserInterfaceStreamModel> snapshot) {
        return Positioned.fill(
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 1200),
            opacity: _opacity,
            child: GestureDetector(
              // onTapDown: (TapDownDetails e){
              //
              // },
              onTap: () {
                LogUtils.e("点击视频空白处 显示进度条");
                if (_timer.isActive) {
                  _timer.cancel();
                }

                if (_opacity == 0.0) {
                  setState(() {
                    _opacity = 1.0;
                  });
                }
              },
              child: Stack(
                children: [
                  /// 顶部文本
                  const Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    height: 44,
                    child: Text(
                      "发现世界",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {
                          LogUtils.e("点击播放或者暂停");
                          if (_controller.value.isPlaying) {
                            stopPlay();
                            if (_timer.isActive) {
                              _timer.cancel();
                            }
                          } else {
                            startPlay();
                            if (_timer.isActive) {
                              _timer.cancel();
                            }
                            _timer = Timer(Duration(seconds: 2), () {
                              setState(() {
                                _opacity = 0.0;
                              });
                            });
                          }
                        },
                        child: Theme(
                          data: ThemeData(
                            iconTheme: IconThemeData(color: Colors.blue),
                          ),
                          child: Icon(
                            PlayOrPauseIcon(snapshot),
                            size: 44,
                          ),
                        ),
                      ),
                      // color: Colors.blueGrey.withOpacity(0.7),
                    ),
                  ),

                  /// 底部滑动条
                  Positioned(
                    bottom: 0,
                    left: 10,
                    right: 10,
                    height: 40,
                    child: VideoSlider(
                      controller: _controller,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData PlayOrPauseIcon(AsyncSnapshot<UserInterfaceStreamModel> snapshot) {
    if (snapshot.data != null && snapshot.data.isPlaying) {
      return Icons.pause;
    } else {
      return Icons.play_circle_fill;
    }

    // return snapshot.data
    //                     ? Icons.pause
    //                     : Icons.play_circle_fill;
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
      UserInherfaceStream.close();
    }
  }

  void stopPlay() {
    UserInherfaceStream.add(UserInterfaceStreamModel(isPlaying: false));
    _isPlaying = false;
    _controller.pause();
  }
}

class VideoSlider extends StatefulWidget {
  final VideoPlayerController controller;

  VideoSlider({@required this.controller});

  @override
  _VideoSliderState createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider> {
  double currentvalue = 0.0;

  // final
  Duration _videopostion;
  Duration _videodurtion;

  Duration get videopostion => widget.controller.value.position;

  Duration get videodurtion => widget.controller.value.duration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        LogUtils.e("进度条刷新");
        currentvalue =
            videopostion.inMilliseconds / videodurtion.inMilliseconds;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          buildStartText(),
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
        Expanded(
          child: Slider(
            value: currentvalue,
            onChanged: (value) {
              setState(() {
                LogUtils.e("拖拽进度条");
                currentvalue = value;
                widget.controller.seekTo(videodurtion * value);
              });
            },
            min: 0.0,
            max: 1.0,
            inactiveColor: Colors.white,
            activeColor: Colors.redAccent,
          ),
        ),
        Text(
          buildEndText(),
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }

  String buildStartText() {
    Duration postion = videopostion;
    int m = postion.inMinutes;
    int s = postion.inSeconds;
    String mstr = "$m";
    if (m < 10) {
      mstr = "0$m";
    }
    String sstr = "$s";
    if (s < 10) {
      sstr = "0$s";
    }

    return "$mstr:$sstr";
  }

  String buildEndText() {
    Duration postion = videodurtion;
    int m = postion.inMinutes;
    int s = postion.inSeconds;
    String mstr = "$m";
    if (m < 10) {
      mstr = "0$m";
    }
    String sstr = "$s";
    if (s < 10) {
      sstr = "0$s";
    }

    return "$mstr:$sstr";
  }
}

class UserInterfaceStreamModel {
  bool isPlaying = false;

  // double currentValue = 0.0;
  // String startTime = '';
  // String endTime = '';

  UserInterfaceStreamModel({@required this.isPlaying});
}
