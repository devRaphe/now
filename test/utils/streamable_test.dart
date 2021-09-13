import 'dart:async';

import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import '../helpers.dart';

void main() {
  group('Streamable', () {
    group('_StreamableImpl', () {
      test('works normally', () async {
        final emittedValues = <DataModel<String>>[];
        final bloc = _StreamableImpl(() => Future.value(""), errorMapper: _errorMapper);

        // Persists initial state
        expect(bloc.value.isLoading, true);
        expect(emittedValues.length, 0);

        final sub = bloc.stream.listen(emittedValues.add);
        await tick();

        expect(emittedValues.length, 2);
        expect(emittedValues.first.isLoading, true);
        expect(emittedValues.last.isData, true);
        expect(bloc.value.isData, true);

        bloc.addError(_Exception("Ye!"));
        await tick();

        expect(emittedValues.length, 3);
        expect(emittedValues.last.hasError, true);
        expect(emittedValues.last.message, "Ye!");

        // Persists only successful states
        expect(bloc.value.isData, true);

        bloc.refresh();
        await tick();

        // It increments by 2 because it reuses initial data before actual operation
        expect(emittedValues.length, 5);
        expect(emittedValues[3].isLoading, true);
        expect(emittedValues.last.isData, true);

        bloc.refresh(silent: true);
        await tick();

        // It doesn't increment because it skips initial state and the new value is the same as the last
        expect(emittedValues.length, 5);

        bloc
          ..addError(_Exception("Nay!"))
          ..refresh(silent: true);
        await tick();

        // It increments by 2 because of first error operation and then skips initial state
        expect(emittedValues.length, 7);
        expect(emittedValues.last.isData, true);

        await sub.cancel();
      });

      test('accepts initial data', () async {
        final emittedValues = <DataModel<String>>[];
        final bloc = _StreamableImpl(
          () => Future.value("b"),
          initialData: DataModel("a"),
          errorMapper: _errorMapper,
        );

        expect(bloc.value.valueOrNull, "a");
        final sub = bloc.stream.listen(emittedValues.add);
        await tick();

        expect(bloc.value.valueOrNull, "b");
        await sub.cancel();
      });

      test('can defer first init when not seeded', () async {
        final emittedValues = <DataModel<String>>[];
        final bloc = _StreamableImpl(
          () => Future.value("b"),
          seeded: false,
          errorMapper: _errorMapper,
        );

        final sub = bloc.stream.listen(emittedValues.add);
        await tick();

        expect(bloc.value.isLoading, true);

        bloc.refresh();
        await tick();

        expect(bloc.value.valueOrNull, "b");

        await sub.cancel();
      });

      test('can map successful values to empty state', () async {
        final emittedValues = <DataModel<String>>[];
        final bloc = _StreamableImpl(
          () => Future.value("b"),
          errorMapper: _errorMapper,
          emptyPredicate: (String value) => value == "b",
        );

        final sub = bloc.stream.listen(emittedValues.add);
        await tick();

        expect(emittedValues.last.isEmpty, true);
        expect(bloc.value.isLoading, true);

        await sub.cancel();
      });

      test('persists only successful states', () async {
        final emittedValues = <DataModel<String>>[];
        final bloc = _StreamableImpl(() => Future.value("b"), errorMapper: _errorMapper);

        final sub = bloc.stream.listen(emittedValues.add);
        await tick();

        bloc.addError(_Exception("Ye!"));
        await tick();

        expect(emittedValues.last.hasError, true);
        expect(bloc.value.valueOrNull, "b");
        await sub.cancel();
      });

      test('can push new future builder', () async {
        final emittedValues = <DataModel<String>>[];
        final bloc = _StreamableImpl(() => Future.value("b"), errorMapper: _errorMapper);

        final sub = bloc.stream.listen(emittedValues.add);
        await tick();

        bloc.push(() async => "c");
        await tick();

        expect(bloc.value.valueOrNull, "c");

        bloc.push(() async => throw _Exception("Nay!"));
        await tick();

        expect(emittedValues.last.hasError, true);
        expect(bloc.value.valueOrNull, "c");

        bool onSuccessCalled = false;
        bloc.push(() async => "d", () => onSuccessCalled = true);
        await tick();

        expect(onSuccessCalled, true);
        expect(bloc.value.valueOrNull, "d");

        await sub.cancel();
      });

      test('can reset to initial data', () async {
        final emittedValues = <DataModel<String>>[];
        final bloc = _StreamableImpl(
          () => Future.value("b"),
          initialData: DataModel("a"),
          errorMapper: _errorMapper,
        );

        final sub = bloc.stream.listen(emittedValues.add);
        await tick();

        expect(bloc.value.valueOrNull, "b");

        bloc.reset();
        await tick();

        expect(bloc.value.valueOrNull, "a");

        await sub.cancel();
      });

      test('can switch to loading state', () async {
        final emittedValues = <DataModel<String>>[];
        final bloc = _StreamableImpl(() => Future.value("b"), errorMapper: _errorMapper);

        final sub = bloc.stream.listen(emittedValues.add);
        await tick();

        expect(bloc.value.valueOrNull, "b");

        bloc.showLoading();
        await tick();

        expect(emittedValues.last.isLoading, true);
        expect(bloc.value.valueOrNull, "b");

        await sub.cancel();
      });

      test('observes only unique state', () async {
        final emittedValues = <DataModel<String>>[];
        final bloc = _StreamableImpl(() => Future.value("b"), errorMapper: _errorMapper);

        final sub = bloc.stream.listen(emittedValues.add);
        await tick();

        expect(emittedValues.length, 2);
        expect(bloc.value.valueOrNull, "b");

        for (int i = 10; i > 0; i--) {
          bloc.refresh(silent: true);
          await tick();
        }

        expect(emittedValues.length, 2);
        expect(bloc.value.valueOrNull, "b");

        await sub.cancel();
      });

      test('can add raw data', () async {
        final emittedValues = <DataModel<String>>[];
        final bloc = _StreamableImpl(() => Future.value("b"), errorMapper: _errorMapper);

        final sub = bloc.stream.listen(emittedValues.add);
        await tick();

        bloc.sink.add(Future.value("c"));
        await tick();

        expect(bloc.value.valueOrNull, "c");

        await sub.cancel();
      });

      test('can clean up on dispose', () async {
        final bloc = _StreamableImpl(() => Future.value("b"), errorMapper: _errorMapper);

        final sub = bloc.stream.listen((_) {});
        await tick();

        bloc.dispose();

        expect(bloc.isClosed, true);

        await sub.cancel();
      });
    });

    group('StreamableDataModel', () {
      test('refresh reuses builder', () async {
        final emittedValues = <DataModel<String>>[];
        final bloc = StreamableDataModel(() => Future.value("b"), errorMapper: _errorMapper);

        final sub = bloc.stream.listen(emittedValues.add);
        await tick();

        expect(emittedValues.length, 2);

        bloc.refresh();
        await tick();

        expect(emittedValues.length, 4);
        expect(emittedValues[2].isLoading, true);

        bloc.refresh(silent: true);
        await tick();

        // No changes as new value is same as previous
        expect(emittedValues.length, 4);

        await sub.cancel();
      });
    });
  });
}

final _errorMapper = (dynamic e) => e is _Exception ? e.message : "$e";

class _Exception implements Exception {
  const _Exception(this.message);

  final String message;

  @override
  String toString() => message;
}

class _StreamableImpl<T> extends Streamable<T> {
  _StreamableImpl(
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
