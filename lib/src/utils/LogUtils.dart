
class LogUtils {
  static bool _isLog = true;
  static String _logFlag = "Flutter Ho";

  static init({String logFlag = "Flutter Ho"}){
    _isLog = !bool.fromEnvironment("dart.vm.product");
    _logFlag = logFlag;
    if (_isLog) {
      
    }
  }

  static void e(String message) {
    if (_isLog) {
      print("$_logFlag | $message");
    }
  }
}