import 'package:flutter/material.dart';
import 'package:flutter_ho/src/Page/Common/toast_utils.dart';
import 'package:flutter_ho/src/utils/LogUtils.dart';
import 'package:flutter_ho/src/utils/dio_utils.dart';

import 'bean_art.dart';
import 'home_art_list_item_widget.dart';

class HomeArtListPage extends StatefulWidget {
  HomeArtListPage({Key key}) : super(key: key);

  @override
  _HomeArtListPageState createState() => _HomeArtListPageState();
}

class _HomeArtListPageState extends State<HomeArtListPage> with AutomaticKeepAliveClientMixin {
  //列表数据
  List<ArtBean> _artBeanList = [];
  int _pageIndex = 1;
  int _pageSize = 10;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("文章"),
      ),

      backgroundColor: Colors.white,
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (ScrollNotification notification) {
          LogUtils.e("滑动结束了了了");
          //在滑动结束的时候 判断下如果滑动了 2/3数据
          //就自动加载下一页数据
          //获取滑动的距离
          //ScrollMetrics 是保存就滑动相关的信息
          // pixels
          ScrollMetrics scrollMetrics = notification.metrics;
          //获取滑动的距离
          double pixels = scrollMetrics.pixels;
          //获取最大滑动的距离
          double maxPixels = scrollMetrics.maxScrollExtent;
          //获取滑动的方向
          AxisDirection axisDirection = scrollMetrics.axisDirection;

          if (pixels >= maxPixels / 3 * 2) {
            //加载更多
            _loadMore();
          }

          //返回true 阻止再向上发送通知
          return true;
        },
        child: RefreshIndicator(
          onRefresh: (){
            return _loadData();
          },
          child: ListView.builder(
            //列表的个数
            itemCount: _artBeanList.length,
            //列表的每个子Item 的样式
            itemBuilder: (BuildContext context, int index) {
              ArtBean artBean = _artBeanList[index];
              return HomeItemArtWidget(artBean: artBean);
            },
          ),
        ),
      ),
    );
  }
  //加载更多
  void _loadMore() {
    if (!_isLoading) {
      _isLoading = true;
      _pageIndex++;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    /*
    {
    "code": 200,
    "data": [
        {
            "id": 3,
            "title": "JS 雪花飘落效果 玩转 canvas 绘图 码农的每日积累 -匠心之作",
            "url": "https://zhuanlan.zhihu.com/p/327699543",
            "image": "https://img-blog.csdnimg.cn/20201128105150457.gif#pic_center",
            "readCount": 232,
            "pariseCount": 111,
            "createTime": "2020-01-09T21:17:49.000+0000"
        },
      ],
    }
     */

    //添加一下分页请求信息
    Map<String, dynamic> map = new Map();
    //当前页数
    map["pageIndex"] = _pageIndex;
    //每页大小
    map["pageSize"] = _pageSize;

    //发起一个get 请求
    // ResponseInfo responseInfo = await DioUtils.instance.getRequest(
    //   url: HttpHelper.artList,
    //   queryParameters: map,
    // );
    //使用模拟数据
    ResponseInfo responseInfo =
        await Future.delayed(Duration(milliseconds: 1000), () {
      List list = [];

      for (int i = 0; i < 10; i++) {
        list.add({
          "title": "测试数据$i",
          "artInfo": "这里是测试数据的简介",
          "readCount": 100,
          "pariseCount": 120,
        });
      }

      return ResponseInfo(data: list);
    });
    //加载结束标识
    _isLoading = false;
    if (responseInfo.success) {
      List list = responseInfo.data;
      //无数据时 更新索引
      if (list.length == 0 && _pageIndex != 1) {
        _pageIndex--;
      }
      if (_pageIndex == 1) {
        //清空一下数据
        _artBeanList = [];
      }
      list.forEach((element) {
        _artBeanList.add(ArtBean.fromMap(element));
      });
      setState(() {});
    } else {
      ToastUtils.showToast("请求失败");
    }
  }

  int _preLoadingTime = 0;

  //下拉刷新
  Future<bool> onRefresh() async {
    //重置页数
    _pageIndex = 1;
    //记录开始加载的时间
    _preLoadingTime = DateTime.now().microsecond;
    //加载数据
    await _loadData();
    //加载完的时间
    int current = DateTime.now().microsecond;
    //时间差
    int flagTime = current - _preLoadingTime;
    //最少显示1秒
    if (flagTime < 1000) {
      await Future.delayed(Duration(milliseconds: 1000 - flagTime));
    }
    ToastUtils.showToast("已刷新");
    return true;
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
