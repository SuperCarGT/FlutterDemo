import 'package:flutter/material.dart';
import 'package:flutter_ho/src/Page/Main/App_Home_Page.dart';
import 'package:flutter_ho/src/utils/LogUtils.dart';
import 'package:flutter_ho/src/utils/Navigator_Utils.dart';
import 'package:provider/provider.dart';

class PageOffSet extends ChangeNotifier {
  double _pageoffset = 0.0;

  double get pageoffset => _pageoffset;

  set pageoffset(double value) {
    _pageoffset = value;
    notifyListeners();
  }
}

class PageInt extends ChangeNotifier {
  int _pageInt = 0;

  int get pageInt => _pageInt;

  set pageInt(int value) {
    _pageInt = value;
    notifyListeners();
  }
}

class FirstGuidePage extends StatefulWidget {
  @override
  _FirstGuidePageState createState() => _FirstGuidePageState();
}

class _FirstGuidePageState extends State<FirstGuidePage> {
  PageController _pageController = PageController();

  // page偏移量

  PageOffSet _offSet = PageOffSet();

  // page整数时
  PageInt _currentPage = PageInt();

  Widget homeButton;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController.addListener(() {
      // setState(() {
      /// _offSet 偏移量
      _offSet.pageoffset =
          _pageController.offset / MediaQuery.of(context).size.width;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              onPageChanged: (page) {
                // if (page >= 3) {
                _currentPage.pageInt = page;
                // }
              },
              controller: _pageController,
              children: [
                Image.asset(
                  "assets/images/sp01.png",
                  width: width,
                  height: height,
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  "assets/images/sp02.png",
                  width: width,
                  height: height,
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  "assets/images/sp03.png",
                  width: width,
                  height: height,
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  "assets/images/sp05.png",
                  width: width,
                  height: height,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 60,
            height: 44,
            left: 0,
            right: 0,
            child: ChangeNotifierProvider<PageOffSet>.value(
              value: _offSet,
              child: Builder(
                builder: (context) {
                  return Consumer<PageOffSet>(
                    builder: (context, offset, child) {
                      return buildRedPoint(offset.pageoffset);
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 180,
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChangeNotifierProvider<PageInt>.value(
                  value: _currentPage,
                  child: Consumer<PageInt>(
                    builder: (context, currentPage, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: currentPage.pageInt >= 3 ? 120 : 0,
                        height: 44,
                        child: ElevatedButton(
                          child: Text("去首页"),
                          onPressed: () {
                            LogUtils.e("点击去首页");
                            NavigatorUtils.pushPageByFade(
                                context: context,
                                targetPage: HomePage(),
                                isReplace: true);
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Row buildRedPoint(double page) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildOneRedPoint(page),
        buildOneRedPoint(page - 1),
        buildOneRedPoint(page - 2),
        buildOneRedPoint(page - 3),
      ],
    );
  }

  AnimatedContainer buildOneRedPoint(double page) {
    double realWidth = 20;

    if (page >= 0 && page <= 1) {
      realWidth = 20 * (1 - page) + 20;
    }

    if (page <= 0 && page >= -1) {
      realWidth = 20 * (1 + page) + 20;
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: 12,
      width: realWidth,
      margin: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.redAccent,
      ),
    );
  }
}
