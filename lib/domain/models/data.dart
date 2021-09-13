import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data.freezed.dart';

@freezed
abstract class DataModel<T> with _$DataModel<T> {
  const factory DataModel(T value) = Data<T>;

  const factory DataModel.empty() = Empty<T>;

  const factory DataModel.loading() = Loading<T>;

  const factory DataModel.error([String message]) = ErrorDetails<T>;
}

extension DataModelX<T> on DataModel<T> {
  T get valueOrNull => maybeWhen((data) => data, orElse: () => null);

  bool get isData => this is Data<T>;

  bool get isEmpty => this is Empty<T>;

  bool get hasError => this is ErrorDetails<T>;

  String get message => (this as ErrorDetails<T>).message;

  bool get isLoading => this is Loading<T>;

  T valueOr(T value) => maybeWhen((data) => data, orElse: () => value) ?? value;

  R mapOr<R>(R Function(T data) fn, {R Function() orElse}) {
    final data = valueOrNull;
    if (data == null) {
      return orElse?.call();
    }
    return fn(data);
  }
}
