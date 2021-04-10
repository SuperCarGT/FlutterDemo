import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限请求模板
class PermissionRequestWidget extends StatefulWidget {
  final Permission permission;
  final List<String> permissionList;
  final bool isCloseApp;
  final String leftButtonString;

  PermissionRequestWidget(
      {@required this.permission,
      @required this.permissionList,
      this.isCloseApp = false,
      this.leftButtonString = "再考虑一下"});

  @override
  _PermissionRequestWidgetState createState() =>
      _PermissionRequestWidgetState();
}

class _PermissionRequestWidgetState extends State<PermissionRequestWidget>
    with WidgetsBindingObserver {
  // 页面的初始化函数 判断权限状态
  @override
  void initState() {
    checkPermission();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.resumed && _isGotoSetting) {
      checkPermission();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
    );
  }

  void checkPermission({PermissionStatus status}) async {
    // 权限状态
    if (status == null) {
      status = await widget.permission.status;
    }

    //判断状态
    if (status.isUndetermined) {
      // 第一次申请
      showPermissionAlert(widget.permissionList[0], "同意", widget.permission);
    } else if (status.isDenied) {
      // 第一次申请拒绝
      // 安卓可以重试  iOS上不能重试 只能去设置中心
      if (Platform.isIOS) {
        showPermissionAlert(
            widget.permissionList[2], "去设置中心", widget.permission,
            gotoSetting: true);
      } else if (Platform.isAndroid) {
        showPermissionAlert(widget.permissionList[1], "重试", widget.permission);
      }
    } else if (status.isPermanentlyDenied) {
      // 第二次申请拒绝
      showPermissionAlert(widget.permissionList[2], "去设置中心", widget.permission,
          gotoSetting: true);
    } else {
      // 通过
      Navigator.of(context).pop(true);
    }
  }

  bool _isGotoSetting = false;

  void showPermissionAlert(
      String message, String rightStr, Permission permission,
      {bool gotoSetting = false}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("温馨提示"),
            content: Container(
              padding: EdgeInsets.all(12),
              child: Text(message),
            ),
            actions: [
              // 左边的按钮
              CupertinoDialogAction(
                child: Text("${widget.leftButtonString}"),
                onPressed: () {
                  if (widget.isCloseApp) {
                    closeApp();
                  }else {
                    Navigator.of(context).pop(false);
                  }

                },
              ),
              // 右边的按钮
              CupertinoDialogAction(
                child: Text(rightStr),
                onPressed: () {
                  // 关闭弹框
                  Navigator.of(context).pop();

                  if (gotoSetting) {
                    _isGotoSetting = true;
                    openAppSettings();
                  } else {
                    requestPermission(permission);
                  }
                },
              ),
            ],
          );
        });
  }

  void requestPermission(Permission permission) async {
    // 发起权限申请
    PermissionStatus status = await permission.request();
    checkPermission(status: status);
  }

  void closeApp() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    // exit(0);
  }
}
