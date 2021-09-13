import 'dart:async';

import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CardPaymentPage extends StatefulWidget {
  const CardPaymentPage({
    Key key,
    @required this.loan,
    @required this.payUrl,
    @required this.amount,
  }) : super(key: key);

  final LoanModel loan;
  final String payUrl;
  final double amount;

  @override
  _CardPaymentPageState createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  FlutterWebviewPlugin _webView;
  LocalServer _localServer;
  StreamSubscription _localServerSubscription;

  @override
  void initState() {
    _webView = FlutterWebviewPlugin();
    _startServer();
    super.initState();
  }

  @override
  void dispose() {
    _webView.dispose();
    _localServerSubscription?.cancel();
    _localServer.close();
    super.dispose();
  }

  void _startServer() async {
    _localServer = LocalServer();
    _localServerSubscription = _localServer.stream.listen((data) {
      if (mounted) {
        _onCallbackData(data);
      }
    });
    await _localServer.start();
  }

  void _onCallbackData(Map<String, dynamic> data) {
    _webView.close();
    context.dispatchAction(DashboardActions.fetch());
    Registry.di.coordinator.payments.popUntil(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: Uri.parse('${widget.payUrl}?callback_url=${_localServer.url}').toString(),
      appBar: ClearAppBar(leading: AppCloseButton(), title: 'Card Payment'),
      withZoom: false,
      withLocalStorage: false,
      withJavascript: true,
      hidden: true,
      initialChild: Center(child: LoadingSpinner.circle()),
    );
  }
}
