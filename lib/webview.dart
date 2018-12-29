import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatefulWidget {
  final String title;
  final String url;

  WebView(this.title, this.url);

  @override
  _WebViewState createState() => _WebViewState(url);
}

class _WebViewState extends State<WebView> {
  _WebViewState(String url);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      url: widget.url,
    );
  }
}
