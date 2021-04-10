import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ho/src/utils/LogUtils.dart';
import 'package:video_player/video_player.dart';

import 'find_listItem_widget.dart';

class FindVideoPageWidget extends StatefulWidget {
  final String title;

  FindVideoPageWidget({@required this.title});

  @override
  _FindVideoPageWidgetState createState() => _FindVideoPageWidgetState();
}

class _FindVideoPageWidgetState extends State<FindVideoPageWidget> with AutomaticKeepAliveClientMixin {
  // 创建一个多订阅流
  StreamController<VideoPlayerController> _streamController =
      StreamController.broadcast();

  //当前播放的视频控制器
  VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    // TODO: implement initSta te
    super.initState();
    _streamController.stream.listen((event) {
      LogUtils.e("收到消息 ${event.textureId}");

      if (_videoPlayerController != null &&
          event.textureId != _videoPlayerController.textureId) {
        _videoPlayerController.pause();
      }

      _videoPlayerController = event;
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();
  }
  bool isScroll = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),

      ),

      backgroundColor: Colors.white,
      body: Center(
        child: NotificationListener(
          onNotification: (ScrollNotification notification){
            Type _notificationType = notification.runtimeType;
            if (_notificationType == ScrollStartNotification) {
              LogUtils.e("开始滑动");
              isScroll = true;
            }else if(_notificationType == ScrollEndNotification){
              LogUtils.e("结束滑动");
              isScroll = false;
              // setState(() {
              //
              // });


            }
            return false;
          },
          child: ListView.builder(
            cacheExtent: 0,
            itemCount: 100,
            itemBuilder: (BuildContext context, int index) {
              return FindListItemWidget(
                streamController: _streamController,
                isScroll: isScroll,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
