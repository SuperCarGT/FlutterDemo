import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavigatorUtils {
  ///普通打开页面
  ///[context] 上下文对象
  ///[targetPage] 目标页面
  ///[dismissCallback] 返回回调
  static void pushPage({
    @required BuildContext context,
    @required Widget targetPage,
    bool isReplace = false,
    Function(dynamic value) dismissCallback,
  }) {
    PageRoute pageRoute;
    if (Platform.isIOS) {
      pageRoute = CupertinoPageRoute(builder: (BuildContext context) {
        return targetPage;
      });
    } else {
      pageRoute = MaterialPageRoute(builder: (BuildContext context) {
        return targetPage;
      });
    }

    if (isReplace) {
      Navigator.of(context).pushReplacement(pageRoute).then((value) {
        if (dismissCallback != null) {
          dismissCallback(value);
        }
      });
    } else {
      Navigator.of(context).push(pageRoute).then((value) {
        if (dismissCallback != null) {
          dismissCallback(value);
        }
      });
    }
  }

  ///渐变打开页面
  ///[context] 上下文对象
  ///[targetPage] 目标页面
  ///[dismissCallback] 返回回调
  ///[opaque] 是否以背景透明的方式打开
  static void pushPageByFade({
    @required BuildContext context,
    @required Widget targetPage,
    bool isReplace = false,
    bool opaque = false,
    int millSecond = 400,
    Function(dynamic value) dismissCallback,
  }) {
    PageRoute pageRoute = PageRouteBuilder(
      transitionDuration: Duration(milliseconds: millSecond),
      opaque: opaque,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return targetPage;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
    if (isReplace) {
      Navigator.of(context).pushReplacement(pageRoute).then((value) {
        if (dismissCallback != null) {
          dismissCallback(value);
        }
      });
    } else {
      Navigator.of(context).push(pageRoute).then((value) {
        if (dismissCallback != null) {
          dismissCallback(value);
        }
      });
    }
  }
}
