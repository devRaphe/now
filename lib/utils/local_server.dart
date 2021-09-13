import 'dart:async';
import 'dart:io';

import 'app_log.dart';

class LocalServer {
  LocalServer({this.scheme = 'http', this.host = '127.0.0.1', this.port = 8184})
      : assert(scheme != null),
        assert(host != null),
        assert(port != null);

  final String host;
  final int port;
  final String scheme;

  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  Uri get url => Uri(scheme: scheme, host: host, port: port);

  HttpServer _server;

  Future<void> start() async {
    if (_server != null) {
      throw Exception('Server already started on $url');
    }

    await runZonedGuarded(
      () async {
        _server = await HttpServer.bind(host, port, shared: true);
        _server.listen((HttpRequest request) async {
          request.response
            ..statusCode = 200
            ..headers.set("Content-Type", ContentType.html.mimeType)
            ..write("<html><h1><center>You can now close this window.</center></h1></html>");

          _controller.add(request.requestedUri.queryParameters);

          await request.response.close();
        });
      },
      AppLog.e,
    );
  }

  Future<void> close() async {
    if (_server != null) {
      _controller.close();
      await _server.close(force: true);

      _server = null;
    }
  }
}
