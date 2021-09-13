import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

typedef FilterCallback = bool Function(String value);

class StreamTextEditingController {
  StreamTextEditingController({
    TextEditingController controller,
    this.filter = defaultFilter,
    this.duration = const Duration(milliseconds: 350),
  }) : this.controller = controller ?? TextEditingController() {
    this.controller.addListener(_fieldListener);
  }

  static bool defaultFilter(String value) => value.isNotEmpty && value.toString().length > 1;

  final TextEditingController controller;
  final FilterCallback filter;
  final Duration duration;

  final _subject = PublishSubject<String>();

  StreamSubscription<String> _subscription;

  String get text => controller.text;

  set text(String value) => controller.text = value;

  Stream<String> get stream =>
      _subject.stream.debounceTime(duration).map((value) => value.trim()).where(filter).distinct();

  void listen(void Function(String data) fn) {
    _subscription = stream.listen(fn);
  }

  void dispose() {
    _subscription?.cancel();
    _subject.close();
    controller.removeListener(_fieldListener);
    controller.dispose();
  }

  void _fieldListener() {
    _subject.add(controller.text);
  }
}
