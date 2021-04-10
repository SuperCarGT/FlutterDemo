import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class CommonWebview  extends StatefulWidget {

  final String htmlStr;
  final String title;


  CommonWebview({@required this.htmlStr, this.title = ""});

  @override
  _CommonWebviewState createState() => _CommonWebviewState();
}

class _CommonWebviewState extends State<CommonWebview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
      ),
      body: WebView(
        initialUrl: widget.htmlStr,
      ),
    );
  }
}
