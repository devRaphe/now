import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http_extensions_cache/http_extensions_cache.dart';

const maxAge = Duration(days: 7);

class CustomCacheManager extends CacheManager {
  CustomCacheManager(Directory directory)
      : super(Config(key + '_' + directory.path, stalePeriod: maxAge, maxNrOfCacheObjects: 20));

  static const key = "customCache";
}

/// A store that save each request result in a dedicated file.
///
/// This is better for large responses that aren't updated too often.
class FileCacheStore extends CacheStore {
  FileCacheStore(Directory directory) : cache = CustomCacheManager(directory);

  final CustomCacheManager cache;

  Future<FileInfo> _findFile(String id) async {
    final fileInfo = await cache.getFileFromCache(id);
    if (fileInfo?.file == null) {
      return null;
    }
    return fileInfo;
  }

  @override
  Future<void> clean() {
    return cache.emptyCache();
  }

  @override
  Future<void> delete(String id) {
    return cache.removeFile(id);
  }

  @override
  Future<CachedResponse> get(String id) async {
    final file = await _findFile(id);
    if (file != null) {
      return _deserializeCachedResponse(file.file, file.validTill.millisecondsSinceEpoch);
    }
    return null;
  }

  @override
  Future<void> set(CachedResponse response) {
    return cache.putFile(
      response.id,
      _serializeCachedResponse(response),
      maxAge: maxAge,
      eTag: response.id,
    );
  }

  @override
  Future<void> updateExpiry(String id, DateTime newExpiry) async {
    final file = await _findFile(id);
    return cache.putFile(
      id,
      file.file.readAsBytesSync(),
      maxAge: newExpiry.difference(DateTime.now()),
      eTag: id,
    );
  }
}

List<int> _serializeCachedResponse(CachedResponse response) {
  final encodedUrl = utf8.encode(response.request.url.toString());
  return Uint8List.fromList([
    ...Int8List.fromList([encodedUrl.length]),
    ...encodedUrl,
    ...response.bytes,
  ]);
}

Future<CachedResponse> _deserializeCachedResponse(File file, int expiry) async {
  final data = await file.readAsBytes();
  const sizesLength = 1;

  final urlLength = Int8List.fromList(data.take(sizesLength).toList()).first;
  final decodedUrl = utf8.decode(data.skip(sizesLength).take(urlLength).toList());

  final decodedBytes = data.skip(sizesLength + urlLength).take(data.length).toList();

  return CachedResponse(
    id: decodedUrl,
    statusCode: 200,
    isRedirect: false,
    persistentConnection: true,
    headers: {},
    reasonPhrase: "",
    request: null,
    // ignore: avoid_slow_async_io
    downloadedAt: await file.lastModified(),
    bytes: decodedBytes,
    expiry: DateTime.fromMillisecondsSinceEpoch(expiry),
  );
}
