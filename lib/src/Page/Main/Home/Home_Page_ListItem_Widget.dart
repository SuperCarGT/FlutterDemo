import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ho/src/Page/Main/Home/video_detail_widget.dart';
import 'package:flutter_ho/src/utils/LogUtils.dart';
import 'package:video_player/video_player.dart';

class HomeListItemWidget extends StatefulWidget {
  final StreamController streamController;
  final bool isScroll;

  HomeListItemWidget({@required this.streamController, this.isScroll = false});

  @override
  _HomeListItemWidgetState createState() => _HomeListItemWidgetState();
}

class _HomeListItemWidgetState extends State<HomeListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5))),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(top: 2),
      padding: EdgeInsets.all(8),
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [Icon(Icons.label), Text("SuperGT")],
            ),
          ),
          Container(
            height: 220,
            child: buildVideoWidget(),
          )
        ],
      ),
    );
  }

  Widget buildVideoWidget() {
    // if (widget.isScroll) {
    //   return Container(
    //     width: MediaQuery.of(context).size.width,
    //     child: Image.asset("assets/images/app_icon.png",fit: BoxFit.fitHeight,),
    //   );
    // } else {
      return VideoDetailWidget(streamController: widget.streamController);
    // }
  }
}
