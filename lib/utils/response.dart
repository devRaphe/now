import 'dart:convert';
import 'dart:io';

import 'package:borome/constants.dart';
import 'package:borome/services.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'app_log.dart';

typedef TransformFunction<T> = T Function(dynamic data, _Status status, String message);

class Response<T> {
  factory Response(
    http.Response _response, {
    @required bool isDev,
    TransformFunction<T> onTransform,
    bool shouldThrow = true,
  }) {
    final _status = _Status(_response.statusCode);
    try {
      final dynamic response = json.decode(_response.body);
      if (response == null || (response is! Map && response is! List)) {
        throw ResponseException(_status.code, _response.reasonPhrase);
      }

      final String status = response is Map && response.containsKey('status') ? response['status'] : _status.status;

      final String message = response is Map && response.containsKey('message') && response['message'] != null
          ? response['message']
          : isDev
              ? _response.reasonPhrase
              : AppStrings.errorMessage;

      if (_status.isNotOk && onTransform == null) {
        throw ResponseException(_status.code, status, message);
      }

      final dynamic rawData = response is Map && response.containsKey('data') ? response['data'] : response;

      return Response._(
        status: _status,
        message: message,
        rawData: rawData,
        data: onTransform != null ? onTransform(rawData, _status, message) : null,
      );
    } catch (e, st) {
      final message = _status.code == HttpStatus.badGateway && !isDev
          ? AppStrings.errorMessage
          : (e is ResponseException ? e.message : e.toString());

      if (shouldThrow) {
        if ([
          isDev,
          _status.isForbidden,
          _status.isNotAuthorized,
          _status.isNotFound,
          _status.isConflict,
          _status.code >= 500,
        ].contains(true)) {
          AppLog.e(e, st);
        }

        if (_status.isForbidden) {
          throw ForbiddenException(_status.status, message);
        }

        if (_status.isNotAuthorized) {
          throw UnAuthorisedException(_status.status, message);
        }

        if (_status.isBadRequest) {
          throw BadRequestException(_status.status, message);
        }

        throw ResponseException(_status.code, _status.status, message);
      }

      return Response._(status: _status, rawData: null, message: message);
    }
  }

  Response._({@required this.status, @required this.message, @required this.rawData, this.data});

  final _Status status;
  final String message;
  final dynamic rawData;
  final T data;

  @override
  String toString() => {'status': status.code, 'message': message, 'data': data?.toString()}.toString();
}

class _Status {
  _Status(this.code);

  final int code;

  String get status => isOk ? 'success' : 'error';

  bool get isOk => code >= HttpStatus.ok && code < HttpStatus.multipleChoices;

  bool get isNotOk => !isOk;

  bool get isBadRequest => code == HttpStatus.badRequest;

  bool get isNotFound => code == HttpStatus.notFound;

  bool get isNotAuthorized => code == HttpStatus.unauthorized;

  bool get isConflict => code == HttpStatus.conflict;

  bool get isForbidden => code == HttpStatus.forbidden;
}
