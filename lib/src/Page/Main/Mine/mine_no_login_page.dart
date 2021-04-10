import 'package:flutter/material.dart';
import 'package:flutter_ho/src/Page/Main/Login/login_page.dart';
import 'package:flutter_ho/src/utils/LogUtils.dart';
import 'package:flutter_ho/src/utils/Navigator_Utils.dart';
import 'dart:math';

class MineNoLoginPage extends StatefulWidget {
  MineNoLoginPage({Key key}) : super(key: key);

  @override
  _MineNoLoginPageState createState() => _MineNoLoginPageState();
}

class _MineNoLoginPageState extends State<MineNoLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFCDDEEC),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
            ),
            GestureDetector(
              onTap: () {
                // 进入登录页面
                NavigatorUtils.pushPageByFade(
                    context: context,
                    targetPage: LoginPage(),
                    millSecond: 1000);
              },
              child: Hero(
                tag: "logo",
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    alignment: Alignment.center,
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(33)),
                      color: Colors.redAccent,
                    ),
                    child: Text(
                      "登录",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            // FLow小组件
            Container(
              child: DemoFlowPopMenu(),
              height: 200,
            ),
            Container(
              child: DemoFlowMenu(),
              height: 200,
            ),
          ],
        ),
        // child: DemoFlowPopMenu(),
        // width: ,
      ),
    );
  }
}

class DemoFlowPopMenu extends StatefulWidget {
  @override
  _DemoFlowPopMenuState createState() => _DemoFlowPopMenuState();
}

class _DemoFlowPopMenuState extends State<DemoFlowPopMenu>
    with SingleTickerProviderStateMixin {
  //动画必须要with这个类
  AnimationController _ctrlAnimationPopMenu; //定义动画的变量
  IconData lastTapped = Icons.notifications;
  final List<IconData> menuItems = <IconData>[
    //菜单的icon
    Icons.home,
    Icons.new_releases,
    Icons.notifications,
    Icons.settings,
    Icons.menu,
  ];

  void _updateMenu(IconData icon) {
    if (icon != Icons.menu) {
      setState(() => lastTapped = icon);
    } else {
      _ctrlAnimationPopMenu.status == AnimationStatus.completed
          ? _ctrlAnimationPopMenu.reverse() //展开和收拢的效果
          : _ctrlAnimationPopMenu.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    _ctrlAnimationPopMenu = AnimationController(
      //必须初始化动画变量
      duration: const Duration(milliseconds: 250), //动画时长250毫秒
      vsync: this, //SingleTickerProviderStateMixin的作用
    );
  }

//生成Popmenu数据
  Widget flowMenuItem(IconData icon) {
    final double buttonDiameter =
        MediaQuery.of(context).size.width * 2 / (menuItems.length * 3);
    LogUtils.e("FLow 每个button 高度 $buttonDiameter");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: RawMaterialButton(
        fillColor: lastTapped == icon ? Colors.amber[700] : Colors.blue,
        splashColor: Colors.amber[100],
        shape: CircleBorder(),
        constraints: BoxConstraints.tight(Size(buttonDiameter, buttonDiameter)),
        onPressed: () {
          _updateMenu(icon);
        },
        child: Icon(icon, color: Colors.white, size: 30.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(animation: _ctrlAnimationPopMenu),
      children:
          menuItems.map<Widget>((IconData icon) => flowMenuItem(icon)).toList(),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({this.animation}) : super(repaint: animation);
  final Animation<double> animation;

  @override
  void paintChildren(FlowPaintingContext context) {
    double x = 10.0; //起始位置
    double y = 10.0; //横向展开,y不变
    for (int i = 0; i < context.childCount; ++i) {
      x = context.getChildSize(i).width * i * animation.value;
      LogUtils.e(
          "X坐标$x,图标大小${context.getChildSize(i).width}，动画值${animation.value},第$i个图标");
      context.paintChild(
        i,
        transform: Matrix4.translationValues(x, y, 0),
      );
    }
  }

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) =>
      animation != oldDelegate.animation;
}

class DemoFlowMenu extends StatefulWidget {
  @override
  _DemoFlowMenuState createState() => _DemoFlowMenuState();
}

class _DemoFlowMenuState extends State<DemoFlowMenu>
    with TickerProviderStateMixin {
  //动画需要这个类来混合
  //动画变量,以及初始化和销毁
  AnimationController _ctrlAnimationCircle;

  @override
  void initState() {
    super.initState();
    _ctrlAnimationCircle = AnimationController(
        //初始化动画变量
        lowerBound: 0,
        upperBound: 80,
        duration: Duration(milliseconds: 300),
        vsync: this);
    _ctrlAnimationCircle.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrlAnimationCircle.dispose(); //销毁变量,释放资源
    super.dispose();
  }

  //生成Flow的数据
  List<Widget> _buildFlowChildren() {
    return List.generate(
      5,
      (index) => Container(
        child: Icon(
          index.isEven ? Icons.timer : Icons.ac_unit,
          color: Colors.primaries[index % Colors.primaries.length],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Flow(
            delegate: FlowAnimatedCircle(_ctrlAnimationCircle),
            children: _buildFlowChildren(),
          ),
        ),
        Positioned.fill(
          child: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              setState(() {
                //点击后让动画可前行或回退
                _ctrlAnimationCircle.status == AnimationStatus.completed
                    ? _ctrlAnimationCircle.reverse()
                    : _ctrlAnimationCircle.forward();
              });
            },
          ),
        ),
      ],
    );
  }
}

class FlowAnimatedCircle extends FlowDelegate {
  final Animation<double> radius; //绑定半径,让圆动起来
  FlowAnimatedCircle(this.radius):super(repaint:radius);

  @override
  void paintChildren(FlowPaintingContext context) {
    if (radius.value == 0) {
      return;
    }
    double x = 0; //开始(0,0)在父组件的中心
    double y = 0;
    for (int i = 0; i < context.childCount; i++) {
      x = radius.value * cos(i * pi / (context.childCount - 1)); //根据数学得出坐标
      y = radius.value * sin(i * pi / (context.childCount - 1)); //根据数学得出坐标
      context.paintChild(i, transform: Matrix4.translationValues(x, -y, 0));
    } //使用Matrix定位每个子组件
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) => true;
}
