import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class HomeCircleWidget extends StatefulWidget {

  final StreamController streamController;


  HomeCircleWidget({Key key,@required this.streamController}) : super(key: key);

  @override
  _HomeCircleWidgetState createState() => _HomeCircleWidgetState();
}

class _HomeCircleWidgetState extends State<HomeCircleWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  Animation<double> _bgAnimation;
  Animation<double> _progressAnimation;
  Animation<double> _numberAnimation;

  //定义数据模型
  List _list = [
    {"title": "生活费", "number": 200, "color": Colors.lightBlueAccent,"startRectangle":0.0,"endRectangle":0.0},
    {"title": "交通费", "number": 200, "color": Colors.green,"startRectangle":0.0,"endRectangle":0.0},
    {"title": "贷款费", "number": 400, "color": Colors.amber,"startRectangle":0.0,"endRectangle":0.0},
    {"title": "游玩费", "number": 100, "color": Colors.orange,"startRectangle":0.0,"endRectangle":0.0},
    {"title": "电话费", "number": 100, "color": Colors.deepOrangeAccent,"startRectangle":0.0,"endRectangle":0.0},
  ];

  double _total = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.streamController.stream.listen((event) {
      _animationController.reset();
      _animationController.forward();
    });



    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    // _animationController.addListener(() {
    //   setState(() {});
    // });

    _bgAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.5, curve: Curves.bounceInOut),
    ));

    _progressAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
    ));

    _numberAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.7, 1.0, curve: Curves.bounceInOut),
    ));


    _list.forEach((element) {
      _total += element["number"];
    });

    _animationController.forward();
  }



  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity,double.infinity),
      painter: CustomHomeCirclePainter(list: _list,total: _total,progress: _progressAnimation.value,repaint:_progressAnimation),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }
}

class CustomHomeCirclePainter extends CustomPainter {


  //定义数据模型
  final List list;

  final double total;

  final double progress;

  final Animation<double> repaint;

  CustomHomeCirclePainter({this.repaint, @required this.list,@required this.total,@required this.progress}):super(repaint: repaint);

  Paint _paint = Paint()..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2,size.height/2);
    double startRectangle = 0.0;
    final double fontSize = 12.0;
    
    final padding = 20;
    final itemWidth = (size.width-padding*4)/3;
    final itemHeight = (size.height-padding*6)/5;
    
    double dx = 0;
    double dy = 0;
    for (int x=1;x<4;x++){
      // X轴坐标
      dx = x*(padding+itemWidth/2)+(x-1)*itemWidth/2;
      for (int y=1;y<6;y++){
        dy = y*(padding+itemHeight/2)+(y-1)*itemHeight/2;
        paintSubView(canvas,Size(itemWidth, itemHeight),Offset(dx, dy));
      }
    }

  }
  
  void paintSubView(Canvas canvas,Size size,Offset offset){
    Offset center = offset;
    double radius = min(size.width/2,size.height/2);
    double startRectangle = 0.0;
    final double fontSize = 12.0;

    for(int i=0;i<list.length;i++) {
      var item = list[i];
      double flag = item["number"]/total;
      double sweepradius = flag*2*pi*repaint.value;
      _paint.color = item["color"];
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startRectangle, sweepradius, true, _paint);

      // 绘制文字
      final radians = startRectangle + sweepradius / 2;
      // 根据三角函数计算中出标识文字的 x 和 y 位置，需要加上宽和高的一半适配 Canvas 的坐标
      double x = cos(radians) * (radius + 20) + center.dx - fontSize;
      double y = sin(radians) * (radius + 20) + center.dy;
      final offset = Offset(x, y);

      // 使用 TextPainter 绘制文字标识
      TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: item["title"],
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(
          minWidth: 0,
          maxWidth: size.width,
        )
        ..paint(canvas, offset);

      startRectangle += sweepradius;
    }
  }

  @override
  bool shouldRepaint(covariant CustomHomeCirclePainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return oldDelegate.repaint != repaint;
  }
}
