import 'dart:async' show Future, TimeoutException;
import 'dart:convert' show json;
import 'dart:io' show File, HandshakeException, SocketException;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_extensions/http_extensions.dart';
import 'package:meta/meta.dart';

import 'exceptions.dart';
import 'http_extensions/http_extensions.dart';

class Request {
  Request({
    @required this.baseUrl,
    @required Duration timeout,
    @required ValueNotifier<String> token,
    bool logger = false,
  })  : assert(baseUrl != null && timeout != null && token != null),
        _http = ExtendedClient(
          inner: http.Client(),
          extensions: buildExtensions(timeout: timeout, token: token, logger: logger),
        );

  @visibleForTesting
  Request.test(ExtendedClient http)
      : _http = http,
        baseUrl = "";

  final ExtendedClient _http;

  final String baseUrl;

  Future<http.Response> get(String url, {Map<String, String> headers, Options options}) =>
      _request(_HttpMethod.get, url, headers: headers, options: options);

  Future<http.Response> post(String url, Map<String, dynamic> data, {Map<String, String> headers, Options options}) =>
      _request(_HttpMethod.post, url, data: data, headers: headers, options: options);

  Future<http.Response> delete(String url, {Map<String, String> headers, Options options}) =>
      _request(_HttpMethod.delete, url, headers: headers, options: options);

  Future<http.Response> form(
    String url, {
    Map<String, dynamic> data = const <String, dynamic>{},
    Map<String, File> files = const {},
    Map<String, String> headers,
    Options options = const Options(timeout: Duration(seconds: 60)),
  }) {
    return _request(
      _HttpMethod.form,
      url,
      data: data,
      files: files,
      headers: headers,
      options: options.copyWith(cache: false),
    );
  }

  Future<http.Response> _request(
    _HttpMethod method,
    String url, {
    Map<String, dynamic> data,
    Map<String, File> files,
    Map<String, String> headers,
    Options options,
  }) async {
    assert(method != null && url != null);

    final _options = buildExtensionOptions(options ?? const Options());

    try {
      final endpoint = baseUrl + url;
      final _headers = headers ?? <String, String>{};
      switch (method) {
        case _HttpMethod.form:
          assert(data != null);
          final _files = <http.MultipartFile>[];
          if (files != null) {
            for (final item in files.entries) {
              if (item.value?.path != null) {
                _files.add(await http.MultipartFile.fromPath(item.key, item.value.path));
              }
            }
          }
          return await _http.formWithOptions(endpoint, headers: _headers, body: data, files: _files, options: _options);
        case _HttpMethod.post:
          assert(data != null);
          return await _http.postWithOptions(endpoint, headers: _headers, body: json.encode(data), options: _options);
        case _HttpMethod.delete:
          return await _http.deleteWithOptions(endpoint, headers: _headers, options: _options);
        case _HttpMethod.get:
        default:
          return await _http.getWithOptions(endpoint, headers: _headers, options: _options);
      }
    } on SocketException catch (_) {
      throw NoInternetException();
    } on HandshakeException catch (_) {
      throw NoInternetException();
    } on TimeoutException catch (_) {
      throw TimeOutException();
    }
  }
}

enum _HttpMethod {
  get,
  post,
  delete,
  form,
}
