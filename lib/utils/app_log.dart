import 'dart:async' as async;
import 'dart:io' as io;

import 'package:borome/services.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:platform/platform.dart';

bool isTesting = LocalPlatform().environment.containsKey('FLUTTER_TEST');

class AppLog {
  AppLog._();

  static void e(Object error, StackTrace stackTrace, {Object message}) {
    Logger.root.log(Level.SEVERE, message ?? error.toString(), error, stackTrace);
  }

  static void i(Object message) {
    Logger.root.info(message);
  }
}

void _debugLog(Object object) {
  if (isTesting || !kDebugMode) {
    return;
  }

  debugPrint(object.toString());
}

typedef ReleaseModeExceptionLogger = void Function(Object error, StackTrace stackTrace, Object extra);

void Function(LogRecord) logListener({
  @required ReleaseModeExceptionLogger onReleaseModeException,
}) {
  const ignoreTypes = [
    io.SocketException,
    io.HandshakeException,
    http.ClientException,
    async.TimeoutException,
    NoInternetException,
    TimeOutException,
  ];
  return (LogRecord record) {
    if (record.level != Level.SEVERE) {
      _debugLog(record.message);
      return;
    }

    _debugLog(record.error);
    _debugLog(record.stackTrace);

    if (kDebugMode || ignoreTypes.contains(record.error.runtimeType)) {
      return;
    }

    onReleaseModeException(record.error, record.stackTrace, record.object ?? <String, dynamic>{});
  };
}
