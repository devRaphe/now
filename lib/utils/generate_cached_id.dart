import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

String Function(String key) generateCachedId({Duration duration = const Duration(seconds: 5)}) {
  return (String key) {
    final nowTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (_cache.containsKey(key)) {
      final item = _cache[key];
      if (nowTimestamp - item.timestamp <= duration.inMilliseconds) {
        return item.id;
      }
      _cache.remove(key);
    }
    final id = Uuid().v4();
    _cache[key] = _Record(id, nowTimestamp);
    return id;
  };
}

final _cache = <String, _Record>{};

@visibleForTesting
void populateCachedIds(Map<String, _Record> other) {
  _cache.addAll(other);
}

@visibleForTesting
void resetCachedIds() {
  _cache.clear();
}

class _Record {
  const _Record(this.id, this.timestamp);

  final String id;
  final int timestamp;
}
