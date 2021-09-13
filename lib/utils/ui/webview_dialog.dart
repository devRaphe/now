import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebviewDialog extends StatelessWidget {
  const WebviewDialog({
    Key key,
    @required this.url,
    @required this.title,
  }) : super(key: key);

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      userAgent:
          'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36',
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        leading: const AppCloseButton(color: kTextBaseColor),
        title: Text(title, style: ThemeProvider.of(context).display1),
      ),
      resizeToAvoidBottomInset: true,
      withZoom: false,
      withLocalStorage: true,
      hidden: true,
      initialChild: Material(
        color: Colors.white70,
        child: Center(child: LoadingSpinner.circle()),
      ),
    );
  }
}
