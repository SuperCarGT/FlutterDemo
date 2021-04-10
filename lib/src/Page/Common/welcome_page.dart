import 'package:flutter/material.dart';
import 'package:flutter_ho/src/Page/Main/App_Home_Page.dart';
import 'package:flutter_ho/src/custom_widget/Count_Timer_Widget.dart';
import 'package:flutter_ho/src/custom_widget/Welcome_video_widget.dart';
import 'package:flutter_ho/src/utils/LogUtils.dart';
import 'package:flutter_ho/src/utils/Navigator_Utils.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // 第一层背景可以是视频也可以是图片
            Positioned.fill(child: WelcomeVideoWidget()),
            // 第二层倒计时
            Positioned(
              child: WelcomeTimerWidget(callback: (){
                LogUtils.e("返回首页");
                goToHomePage();
              },),
              bottom: 50,
              right: 30,
            ),
          ],
        ),
      ),
    );
  }

  void goToHomePage() {
    NavigatorUtils.pushPageByFade(context: context, targetPage: HomePage(),isReplace: true);
  }
}
