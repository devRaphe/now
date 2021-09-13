import "dart:async" as async;
import "dart:io" as io;

import 'package:borome/constants.dart';
import 'package:borome/registry.dart';
import 'package:borome/services.dart';
import 'package:http/http.dart' as http;

String errorToString(dynamic error) {
  if (Registry.di.session.isDev) {
    return "$error";
  }

  if ([
    io.SocketException,
    io.HandshakeException,
    http.ClientException,
  ].contains(error.runtimeType)) {
    return AppStrings.networkError;
  }

  if (error is async.TimeoutException) {
    return AppStrings.timeoutError;
  }

  try {
    if (error is AppException || error is Exception) {
      return error.message;
    }
  } catch (e) {
    // Intentionally left empty
  }

  return AppStrings.errorMessage;
}
