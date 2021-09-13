import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class SubState<T> with DiagnosticableTreeMixin {
  SubState({@required this.value, this.loading = false, this.error, this.empty = false});

  factory SubState.withEmpty() => SubState<T>(value: null, empty: true);

  factory SubState.withLoading([T value]) => SubState<T>(value: value, loading: true);

  factory SubState.withError(String message, [T value]) => SubState<T>(value: value, error: message);

  final T value;
  final bool loading;
  final String error;
  final bool empty;

  bool get hasData => value != null && empty == false;

  bool get hasError => error != null;

  SubState<T> copyWith({T value, bool loading, bool empty, String error}) {
    return SubState<T>(
      value: value ?? this.value,
      loading: loading ?? this.loading,
      empty: empty ?? this.empty,
      error: error ?? this.error,
    );
  }

  R map<R>(R Function(T data) fn, {R Function() orElse}) {
    if (value == null) {
      return orElse?.call();
    }
    return fn(value);
  }

  SubState<T> update(T Function(T previous) fn) => copyWith(value: fn(value));

  SubState<T> withLoading() => copyWith(loading: true, empty: false);

  SubState<T> withError(String error) => copyWith(loading: false, empty: false, error: error);

  T valueOr(T newValue) => value ?? newValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubState &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          loading == other.loading &&
          error == other.error &&
          empty == other.empty;

  @override
  int get hashCode => value.hashCode ^ loading.hashCode ^ error.hashCode ^ empty.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('value', value));
    properties.add(DiagnosticsProperty<bool>('loading', loading));
    properties.add(StringProperty('error', error));
    properties.add(DiagnosticsProperty<bool>('hasError', hasError));
    properties.add(DiagnosticsProperty<bool>('hasData', hasData));
    properties.add(DiagnosticsProperty<bool>('empty', empty));
  }
}
