import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class BubleWidget extends StatefulWidget {
  final Function() fadeAnimationComplete;

  BubleWidget({Key key, this.fadeAnimationComplete}) : super(key: key);

  @override
  _BubleWidgetState createState() => _BubleWidgetState();
}

class _BubleWidgetState extends State<BubleWidget>
    with TickerProviderStateMixin {
  List<BobbleBean> _list = [];

  //随机数据
  Random _random = new Random(DateTime.now().microsecondsSinceEpoch);

  //气泡的最大半径
  double maxRadius = 80;

  //气泡动画的最大速度
  double maxSpeed = 0.7;

  //气泡计算使用的最大弧度（360度）
  double maxTheta = 2.0 * pi;

  //动画控制器
  AnimationController _animationController;

  //流控制器
  StreamController<double> _streamController = new StreamController();

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 20; i++) {
      BobbleBean particle = new BobbleBean();
      //获取随机透明度的白色颜色
      particle.color = getRandonWhightColor(_random);
      //指定一个位置 每次绘制时还会修改
      particle.postion = Offset(-1, -1);
      //气泡运动速度
      particle.speed = _random.nextDouble() * maxSpeed;
      //随机角度
      particle.theta = _random.nextDouble() * maxTheta;
      //随机半径
      particle.radius = _random.nextDouble() * maxRadius;
      //集合保存
      _list.add(particle);
    }

    //动画控制器
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animationController.repeat();
    //刷新监听
    // _animationController.addListener(() {
    //   //流更新
    //   // _streamController.add(0.0);
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    // 画板
    return CustomPaint(
      size: MediaQuery.of(context).size,
      // 画布
      painter: CustomMyPainter(list: _list, random: _random,controller: _animationController),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();

  }
}

class CustomMyPainter extends CustomPainter {
  List<BobbleBean> list;
  Random random;
  final AnimationController controller;

  CustomMyPainter({this.list, this.random,this.controller}):super(repaint: controller);

  Paint _paint = new Paint()..isAntiAlias = true;

  //绘制
  @override
  void paint(Canvas canvas, Size size) {
    // 绘制前重新计算 每个气泡的位置
    list.forEach((element) {
      Offset newoffset = Offset(element.speed * cos(element.theta),
          element.speed * sin(element.theta));
      double dx = newoffset.dx + element.postion.dx;
      double dy = newoffset.dy + element.postion.dy;
      if (dx < 0 || dx > size.width) {
        dx = random.nextDouble() * size.width;
      }
      if (dy < 0 || dy > size.height) {
        dy = random.nextDouble() * size.height;
      }
      element.postion = Offset(dx, dy);
    });
    list.forEach((element) {
      _paint.color = element.color;
      canvas.drawCircle(element.postion, element.radius, _paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

Color getRandonWhightColor(Random random) {
  int a = random.nextInt(200);
  return Color.fromARGB(a, 255, 255, 255);
}

///气泡属性配置
class BobbleBean {
  //位置
  Offset postion;

  //颜色
  Color color;

  //运动的速度
  double speed;

  //角度
  double theta;

  //半径
  double radius;
}
