import 'dart:async';

import 'package:borome/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class Streamable<T> {
  Streamable({
    @required this.initialData,
    @required this.errorMapper,
    @required this.emptyPredicate,
    @required bool seeded,
  })  : assert(errorMapper != null),
        value = initialData,
        controller = BehaviorSubject(),
        dataController = BehaviorSubject() {
    if (seeded) {
      refresh();
    }
  }

  final DataModel<T> initialData;

  DataModel<T> value;

  bool get isClosed => controller.isClosed && dataController.isClosed;

  StreamSink<Future<T>> get sink => controller.sink;

  final Subject<Future<T>> controller;

  final Subject<DataModel<T>> dataController;

  final String Function(dynamic) errorMapper;

  final bool Function(T) emptyPredicate;

  Stream<DataModel<T>> get stream => MergeStream([
        controller
            .where((data) => data != null)
            .switchMap(
              (result) => result
                  .asStream()
                  .map(mapDataToDataModel)
                  .onErrorReturnWith((dynamic e) => DataModel<T>.error(errorMapper(e))),
            )
            .distinct(),
        dataController.distinct()
      ]).distinct().doOnData((data) {
        final _value = data is Data && data.valueOrNull != null ? data : value;
        value = _value.valueOrNull != null ? _value : initialData;
      }).asBroadcastStream();

  void _addData(DataModel<T> data) {
    if (!dataController.isClosed) {
      dataController.add(data);
    }
  }

  void push(Future<T> Function() builder, [VoidCallback onSuccess]) {
    builder()
        .then(mapDataToDataModel)
        .then((data) => _addData(data))
        .then((_) => onSuccess?.call())
        .catchError((dynamic e) => addError(e));
  }

  void addError(dynamic e) {
    _addData(DataModel<T>.error(errorMapper(e)));
  }

  void refresh({bool silent = false}) {
    if (silent == false) {
      showLoading();
    }
    fetch();
  }

  void fetch();

  DataModel<T> mapDataToDataModel(T data) {
    if (emptyPredicate != null && emptyPredicate(data) == true) {
      return DataModel<T>.empty();
    }
    return DataModel(data);
  }

  void showLoading() {
    _addData(DataModel.loading());
  }

  void reset() {
    _addData(initialData);
  }

  void dispose() {
    dataController.close();
    controller.close();
  }
}

class StreamableDataModel<T> extends Streamable<T> {
  StreamableDataModel(
    this._builder, {
    DataModel<T> initialData = const DataModel.loading(),
    bool seeded = true,
    @required String Function(dynamic) errorMapper,
    bool Function(T) emptyPredicate,
  }) : super(initialData: initialData, seeded: seeded, emptyPredicate: emptyPredicate, errorMapper: errorMapper);

  final Future<T> Function() _builder;

  @override
  void fetch() {
    push(_builder);
  }
}
