import 'package:flutter/material.dart';
import 'package:flutter_ho/src/utils/Navigator_Utils.dart';

import 'Setting/mine_setting_page.dart';

class MineUserinfoPage extends StatefulWidget {
  MineUserinfoPage({Key key}) : super(key: key);

  @override
  _MineUserinfoPageState createState() => _MineUserinfoPageState();
}

class _MineUserinfoPageState extends State<MineUserinfoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFCDDEEC),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // 进入设置页面
              // NavigatorUtils.pushPageByFade(
              //     context: context, targetPage: LoginPage(), millSecond: 1000);
            },
            child: GestureDetector(
              onTap: (){
                NavigatorUtils.pushPage(context: context, targetPage: MineSettingPage());
              },
              child: Container(
                alignment: Alignment.center,
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.lightBlue.withOpacity(0.3),
                      Colors.blue.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(33)),
                  // color: Colors.redAccent,
                ),
                child: Text(
                  "设置",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}