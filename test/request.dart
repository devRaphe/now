import 'dart:io';

import 'package:borome/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockRequestImpl {
  Future<http.Response> get(String url) async {
    return http.Response("{}", 200, reasonPhrase: "");
  }

  Future<http.Response> post(String url) async {
    return http.Response("{}", 200, reasonPhrase: "");
  }

  Future<http.Response> delete(String url) async {
    return http.Response("{}", 200, reasonPhrase: "");
  }

  Future<http.Response> form(String url) async {
    return http.Response("{}", 200, reasonPhrase: "");
  }
}

class MockRequest extends Mock implements Request {
  MockRequest(this.impl);

  final MockRequestImpl impl;

  @override
  Future<http.Response> get(String url, {Map<String, String> headers, Options options}) async {
    return impl.get(url);
  }

  @override
  Future<http.Response> post(String url, Map<String, dynamic> data,
      {Map<String, String> headers, Options options}) async {
    return impl.post(url);
  }

  @override
  Future<http.Response> delete(String url, {Map<String, String> headers, Options options}) async {
    return impl.delete(url);
  }

  @override
  Future<http.Response> form(
    String url, {
    Map<String, dynamic> data = const <String, dynamic>{},
    Map<String, File> files = const {},
    Map<String, String> headers,
    Options options = const Options(timeout: Duration(seconds: 60)),
  }) async {
    return impl.form(url);
  }
}
