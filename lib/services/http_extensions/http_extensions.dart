import 'dart:async' as async show TimeoutException;
import 'dart:convert';
import 'dart:io' as io show HttpHeaders, HttpStatus, HandshakeException, SocketException, Directory;

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_extensions/http_extensions.dart';
import 'package:http_extensions_cache/http_extensions_cache.dart';
import 'package:http_extensions_headers/http_extensions_headers.dart';
import 'package:http_extensions_log/http_extensions_log.dart';
import 'package:http_extensions_retry/http_extensions_retry.dart';
import 'package:logging/logging.dart';

import 'extensions.dart';
import 'file_cache_store.dart';

export 'extensions.dart';

enum CacheType {
  file,
  memory,
}

final _defaultCacheStore = MemoryCacheStore();

List<Extension> buildExtensions({
  @required Duration timeout,
  @required ValueNotifier<String> token,
  bool logger = false,
}) {
  return <Extension>[
    TimeoutExtension(TimeoutOptions(timeout)),
    RetryExtension(
      logger: logger ? Logger("Retry") : null,
      defaultOptions: RetryOptions(
        retries: 3,
        retryInterval: Duration(milliseconds: 350),
        retryEvaluator: (dynamic error, response) {
          if (error != null &&
              ([
                io.SocketException,
                io.HandshakeException,
                http.ClientException,
                async.TimeoutException,
              ].contains(error.runtimeType))) {
            return true;
          }
          if (response != null &&
              [
                io.HttpStatus.partialContent,
                io.HttpStatus.requestTimeout,
                io.HttpStatus.tooManyRequests,
                io.HttpStatus.connectionClosedWithoutResponse,
                io.HttpStatus.internalServerError,
                io.HttpStatus.badGateway,
                io.HttpStatus.serviceUnavailable,
                io.HttpStatus.gatewayTimeout,
                io.HttpStatus.insufficientStorage,
                io.HttpStatus.networkConnectTimeoutError,
              ].contains(response.statusCode)) {
            return true;
          }
          return false;
        },
      ),
    ),
    CacheExtension(
      logger: logger ? Logger("Cache") : null,
      defaultOptions: CacheOptions(store: _defaultCacheStore, ignoreCache: true),
    ),
    IdempotencyExtension(
      logger: logger ? Logger("Idempotency") : null,
      defaultOptions: IdempotencyOptions(
        keyBuilder: (request) {
          String key = "${request.method}-${request.url.toString()}";
          if (token.value != null) {
            key += "-${sha1.convert(utf8.encode(token.value))}";
          }
          return key;
        },
      ),
    ),
    HeadersExtension(
      logger: logger ? Logger("Headers") : null,
      defaultOptions: HeadersOptions(
        headersBuilder: (_) => {
          io.HttpHeaders.acceptHeader: "application/json",
          io.HttpHeaders.contentTypeHeader: "application/json",
          if (token?.value != null) "Authorization": "Bearer ${token.value}"
        },
      ),
    ),
    if (logger) LogExtension(defaultOptions: LogOptions(logContent: true, logHeaders: false)),
  ];
}

class Options {
  const Options({
    this.cache,
    this.cacheType,
    this.cacheExpiry,
    this.cacheKeyBuilder,
    this.retries,
    this.timeout,
  });

  final bool cache;
  final CacheType cacheType;
  final Duration cacheExpiry;
  final CacheKeyBuilder cacheKeyBuilder;
  final int retries;
  final Duration timeout;

  Options copyWith({
    bool cache,
    CacheType cacheType,
    CacheKeyBuilder cacheKeyBuilder,
    int retryCount,
    Duration timeout,
  }) {
    return Options(
      cache: cache ?? this.cache,
      cacheType: cacheType ?? this.cacheType,
      cacheKeyBuilder: cacheKeyBuilder ?? this.cacheKeyBuilder,
      retries: retryCount ?? this.retries,
      timeout: timeout ?? this.timeout,
    );
  }
}

List<dynamic> buildExtensionOptions(Options options) {
  return <dynamic>[
    if (options.timeout != null) TimeoutOptions(options.timeout),
    if (options.cache != null)
      CacheOptions(
        ignoreCache: !options.cache,
        expiry: options.cacheExpiry ?? Duration(minutes: 5),
        keyBuilder: (request) {
          final appendage = "_${options.cacheKeyBuilder?.call(request) ?? "keep"}".replaceAll(" ", "_");
          return CacheOptions.defaultCacheKeyBuilder(request) + appendage;
        },
        store: _resolveCacheStoreType(options.cacheType),
      ),
    if (options.retries != null) RetryOptions(retries: options.retries),
  ];
}

CacheStore _resolveCacheStoreType(CacheType type) {
  switch (type) {
    case CacheType.file:
      return FileCacheStore(io.Directory("BoroMe"));
    case CacheType.memory:
    default:
      return _defaultCacheStore;
  }
}
