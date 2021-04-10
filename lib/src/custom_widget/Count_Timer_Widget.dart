import 'dart:async';

import 'package:flutter/material.dart';

class WelcomeTimerWidget extends StatefulWidget {
  final void Function() callback;

  const WelcomeTimerWidget({Key key, @required this.callback})
      : super(key: key);

  @override
  _WelcomeTimerWidgetState createState() => _WelcomeTimerWidgetState();
}

class _WelcomeTimerWidgetState extends State<WelcomeTimerWidget> {
  int currentCount = 5;
  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      currentCount--;

      if (currentCount < 0) {
        // 计时结束
        _timer.cancel();
        widget.callback();
        // 返回首页
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    if (_timer.isActive) {
      _timer.cancel();
    }

    super.dispose();

    // _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: buildContainer(),
      onTap: () {
        if (_timer.isActive) {
          _timer.cancel();
        }
        widget.callback();
      },
    );
  }

  Container buildContainer() {
    return Container(
      child: Text("${currentCount}s"),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      // color: Colors.blue,
      alignment: Alignment.center,
      width: 40,
      height: 40,
    );
  }
}
