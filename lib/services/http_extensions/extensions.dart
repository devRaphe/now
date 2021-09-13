import 'package:borome/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_extensions/http_extensions.dart';
import 'package:logging/logging.dart';

class TimeoutOptions {
  const TimeoutOptions([this.timeout = const Duration(seconds: 30)]);

  final Duration timeout;
}

class TimeoutExtension extends Extension<TimeoutOptions> {
  TimeoutExtension([TimeoutOptions defaultOptions = const TimeoutOptions()]) : super(defaultOptions: defaultOptions);

  @override
  Future<http.StreamedResponse> sendWithOptions(http.BaseRequest request, TimeoutOptions options) {
    return super.sendWithOptions(request, options).timeout(options.timeout);
  }
}

class IdempotencyOptions {
  const IdempotencyOptions({@required this.keyBuilder});

  final String Function(http.BaseRequest request) keyBuilder;
}

class IdempotencyExtension extends Extension<IdempotencyOptions> {
  IdempotencyExtension({IdempotencyOptions defaultOptions, this.logger}) : super(defaultOptions: defaultOptions);

  final Logger logger;
  final idGenerator = generateCachedId();

  @override
  Future<http.StreamedResponse> sendWithOptions(http.BaseRequest request, IdempotencyOptions options) {
    final key = options.keyBuilder(request);
    final id = idGenerator(key);
    logger?.info("key: $key id: $id");
    request.headers.addAll({"Idempotency-Key": id});
    return super.sendWithOptions(request, options);
  }
}
