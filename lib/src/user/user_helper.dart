
import 'package:flutter_ho/src/user/user_bean.dart';
import 'package:flutter_ho/src/utils/sp_utils.dart';

class UserHelper {
  //私有化构造函数
  UserHelper._();
  //创建全局单例对象
  static UserHelper getInstance = UserHelper._();

  UserBean _userBean;

  //是否登录
  bool get isLogin => _userBean != null;

  set userBean(UserBean bean) {
    _userBean = bean;
    SPUtil.saveObject("user_bean", _userBean);
  }

  get userBean=>_userBean;


  void init() async {
    Map<String, dynamic> map = await SPUtil.getObject("user_bean");
    if(map!=null){
      //加载缓存
      _userBean= UserBean.fromMap(map);

    }
  }

  void clear(){
    _userBean = null;
    SPUtil.remove("user_bean");
  }

}
