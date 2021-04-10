import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ho/src/Page/Common/buble_widget.dart';
import 'package:flutter_ho/src/Page/Common/toast_utils.dart';
import 'package:flutter_ho/src/Page/Main/Mine/mine_no_login_page.dart';
import 'package:flutter_ho/src/Page/Main/Mine/mine_page.dart';
import 'package:flutter_ho/src/user/user_bean.dart';
import 'package:flutter_ho/src/user/user_helper.dart';

// import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:flutter_ho/src/utils/dio_utils.dart';
import 'package:flutter_ho/src/utils/login_stream.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  AnimationController _fadeAnimationController;

  FocusNode _userNameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _passwordIsShow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1800),
    );
    _fadeAnimationController.forward();
    // _fadeAnimationController.add
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: GestureDetector(
          onTap: () {
            _userNameFocusNode.unfocus();
            _passwordFocusNode.unfocus();
          },
          child: Stack(
            children: [
              // 第一层背景
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.lightBlue.withOpacity(0.3),
                        Colors.blue.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
              // 第二层气泡
              Positioned.fill(child: BubleWidget()),
              // 第三层高斯模糊
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
                  child: Container(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
              // 顶部文字
              Positioned(
                left: 0,
                right: 0,
                top: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "logo",
                      child: Material(
                        color: Colors.transparent,
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/app_icon.png",
                            width: 33,
                            height: 33,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "欢迎登录",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: Colors.blue),
                    )
                  ],
                ),
              ),
              // 底部输入框
              Positioned(
                left: 40,
                right: 40,
                bottom: 84,
                child: FadeTransition(
                  opacity: _fadeAnimationController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 自定义一个文本输入框
                      TextFieldWidget(
                        obscureText: false,
                        labelText: "账号",
                        prefixIconData: Icons.phone_android_outlined,
                        controller: _userNameController,
                        focusNode: _userNameFocusNode,
                        onSubmitted: (value) {
                          if (value.length != 11) {
                            ToastUtils.showToast("请输入11位手机号");
                            //手机号输入框重新获取焦点
                            FocusScope.of(context)
                                .requestFocus(_userNameFocusNode);
                            return;
                          }
                          //手机号输入框失去焦点
                          _userNameFocusNode.unfocus();
                          //密码输入框获取焦点
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget(
                        obscureText: _passwordIsShow,
                        labelText: "密码",
                        prefixIconData: Icons.lock_outline,
                        suffixIcon: _passwordIsShow
                            ? Icons.visibility
                            : Icons.visibility_off,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        onTap: () {
                          setState(() {
                            _passwordIsShow = !_passwordIsShow;
                          });
                        },
                        onSubmitted: (value) {
                          if (value.length < 6) {
                            ToastUtils.showToast("请输入6位以上密码");
                            //密码输入框获取焦点
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                            return;
                          }
                          //手机号输入框失去焦点
                          _userNameFocusNode.unfocus();
                          //密码输入框失去焦点
                          _passwordFocusNode.unfocus();
                          submitFunction();
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "忘记密码",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        height: 44,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            submitFunction();
                          },
                          child: Text("登录"),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        height: 44,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("注册"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 40,
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop(false);
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.black26,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void submitFunction() async {
    //获取用户名
    String userName = _userNameController.text;
    //获取密码
    String password = _passwordController.text;

    if (userName.trim().length != 11) {
      ToastUtils.showToast("请输入11位手机号");
      return;
    }
    if (password.trim().length < 6) {
      ToastUtils.showToast("请输入6位以上密码");
      return;
    }
    Map<String, dynamic> map = {
      "mobile": userName,
      "password": password,
    };

    //网络请求 发起 post 请求
    // ResponseInfo responseInfo = await DioUtils.instance.postRequest(
    //   //请求地址
    //   url: HttpHelper.login,
    //   //请求参数
    //   formDataMap: map,
    // );
    //模拟登录成功
    ResponseInfo userinfo =
        await Future.delayed(Duration(milliseconds: 1000), () {
      return ResponseInfo(data: {
        "userName": "测试数据",
        "age": 22,
      });
    });
    //响应成功
    if (userinfo.success) {
      //解析数据
      UserBean userBean = UserBean.fromMap(userinfo.data);
      //内存保存数据
      UserHelper.getInstance.userBean = userBean;
      //提示框
      ToastUtils.showToast("登录成功");
      //关闭当前页面
      Navigator.of(context).pop(true);
      //发送消息更新我的页面显示内容
      loginStreamController.add(0);
    } else {
      //登录失败页面小提示
      ToastUtils.showToast("${userinfo.message}");
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _fadeAnimationController.dispose();
  }
}

class TextFieldWidget extends StatelessWidget {
  final Function(String value) onTextChange;
  final bool obscureText;
  final String labelText;
  final IconData prefixIconData;
  final IconData suffixIcon;
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function() onTap;
  final ValueChanged<String> onSubmitted;

  TextFieldWidget(
      {this.labelText,
      this.onTextChange,
      this.obscureText = false,
      this.prefixIconData,
      this.suffixIcon,
      this.focusNode,
      this.controller,
      this.onTap,
      this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      // onTap: onTap,
      controller: controller,
      focusNode: focusNode,
      onChanged: onTextChange,
      obscureText: obscureText,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        filled: true,
        labelText: labelText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.blue),
        ),
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: Colors.blue,
        ),
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Icon(
            suffixIcon,
            size: 18,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
