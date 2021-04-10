import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ho/src/Page/Common/home_circle_widget.dart';
import 'package:flutter_ho/src/Page/Main/Home/Home_Page_ListItem_Widget.dart';
import 'package:flutter_ho/src/utils/LogUtils.dart';
import 'package:video_player/video_player.dart';

class HomeSubPageView extends StatefulWidget {
  final int flag;
  final String title;

  HomeSubPageView({@required this.flag, @required this.title});

  @override
  _HomeSubPageViewState createState() => _HomeSubPageViewState();
}

class _HomeSubPageViewState extends State<HomeSubPageView> with AutomaticKeepAliveClientMixin {

  StreamController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = StreamController.broadcast();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("饼状图"),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: HomeCircleWidget(streamController: _controller,),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _controller.add(0);
        },
        tooltip: 'rebuild',
        child: const Icon(Icons.refresh),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.close();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
