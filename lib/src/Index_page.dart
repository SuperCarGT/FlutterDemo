import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ho/src/Page/Common/protocol_Model.dart';
import 'package:flutter_ho/src/user/user_helper.dart';
import 'package:flutter_ho/src/utils/LogUtils.dart';
import 'package:flutter_ho/src/utils/Navigator_Utils.dart';
import 'package:flutter_ho/src/utils/sp_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Page/Common/first_guide_page.dart';
import 'Page/Common/permission_request_Widget.dart';
import 'Page/Common/welcome_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with ProtocolModel {
  List<String> _list = [
    "为了您的更好的用户体验，需要获取您的手机相册存储权限",
    "您已拒绝权限，所以无法保存您的相册，将无法使用APP",
    "您已拒绝权限，请在设置中心同意APP的权限请求",
    "其他错误"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    permissionCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("开始喽"),
      ),
      body: Center(
        child: Image.asset(
          "assets/images/app_icon.png",
          width: 80,
          height: 80,
        ),
      ),
    );
  }

  void permissionCheck() {
    LogUtils.init();
    LogUtils.e("权限申请");
    Future.delayed(Duration.zero, () {
      NavigatorUtils.pushPageByFade(
        context: context,
        targetPage: PermissionRequestWidget(
            permission: Permission.contacts, permissionList: _list),
        dismissCallback: (value) {
          if (value == null || !value) {
            // 权限请求不通过
          } else {
            // 权限请求通过
            LogUtils.e("权限申请成功");
            //
            initProtocolShow();
          }
        },
      );
    });
  }

  // 初始化工具类
  void initProtocolShow() async {
    await SPUtil.init();
    UserHelper.getInstance.init();
    bool isAgreement = await SPUtil.getBool("isAgreement");
    if (isAgreement == null || !isAgreement) {
      isAgreement = await showProtocolFunction(context);
    }

    if (isAgreement) {
      LogUtils.e("同意隐私协议");
      SPUtil.save("isAgreement", true);
      toWelcomePage();
    } else {
      LogUtils.e("不同意协议");
      SPUtil.save("isAgreement", false);
      closeApp();
    }
  }

  void closeApp() async {
    // await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    exit(0);
  }

  void toWelcomePage() async {

    // 判断是不是第一次安装
    bool isFirstInstall = await SPUtil.getBool("flutter-ho-isFrist");

    if (isFirstInstall == null) {
      // 引导页面
      NavigatorUtils.pushPageByFade(
          context: context, targetPage: FirstGuidePage(), isReplace: true);
    }else {
      // 倒计时页面
      NavigatorUtils.pushPageByFade(
          context: context, targetPage: WelcomePage(), isReplace: true);
    }



  }
}
