import 'package:flutter/material.dart';
import 'package:flutter_ho/src/Page/Main/Home/Home_PageView_Widget.dart';

import 'Art/home_art_list_page.dart';
import 'Find/find_video_page.dart';
import 'Mine/mine_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: PageView(

          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomeSubPageView(flag: 0, title: "首页"),
            FindVideoPageWidget(title: "发现"),
            HomeArtListPage(),
            MinePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(pageController: _pageController,),
    );
  }
}

class BottomBar extends StatefulWidget {

  // final int currentIndex;
  final PageController pageController;

  BottomBar({this.pageController});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (int value){
        setState(() {
          _currentIndex = value;
          widget.pageController.jumpToPage(value);
        });
      },
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.blue,
      selectedItemColor: Colors.redAccent,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: "首页"),
        BottomNavigationBarItem(icon: Icon(Icons.five_g),label: "发现"),
        BottomNavigationBarItem(icon: Icon(Icons.message),label: "消息"),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: "我的"),
      ],
    );
  }
}

