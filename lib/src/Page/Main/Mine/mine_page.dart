import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ho/src/user/user_helper.dart';
import 'package:flutter_ho/src/utils/login_stream.dart';

import 'mine_no_login_page.dart';
import 'mine_userinfo_page.dart';

class MinePage extends StatefulWidget {
  MinePage({Key key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginStreamController.stream.listen((event) {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      child: buildMainBody(),
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Color(0xFFCDDEEC),
      ),
    );
  }

  buildMainBody() {
    if (UserHelper.getInstance.isLogin) {
      return MineUserinfoPage();
    } else {
      return MineNoLoginPage();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    loginStreamController.close();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
