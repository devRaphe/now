import 'package:borome/store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group("SubState", () {
    test("works normally", () {
      final state = SubState<int>(value: 0);
      expect(state.value, 0);
      expect(state.withError("error"), SubState<int>.withError("error", 0));
      expect(state.withLoading(), SubState<int>.withLoading(0));
      expect(state.copyWith(value: 1), SubState<int>(value: 1));
      expect(state.copyWith(value: null), SubState<int>(value: 0));
      expect(state.copyWith(loading: true), SubState<int>(value: 0, loading: true));
      expect(state.copyWith(error: "error"), SubState<int>(value: 0, error: "error"));
      expect(state.copyWith(empty: true), SubState<int>(value: 0, empty: true));
      expect(state.update((previous) => previous), SubState<int>(value: 0));
      expect(state.update((previous) => previous + 1), SubState<int>(value: 1));
      expect(state.map((current) => current + 1), 1);
    });

    test("supports hasData", () {
      expect(SubState<int>(value: 0).hasData, true);
      expect(SubState<int>(value: 0, empty: true).hasData, false);
      expect(SubState<int>.withError("").hasData, false);
      expect(SubState<int>.withLoading().hasData, false);
      expect(SubState<int>.withEmpty().hasData, false);

      final state = SubState<int>(value: null);
      expect(state.withError("").hasData, false);
      expect(state.withLoading().hasData, false);
      expect(state.copyWith(value: 1).hasData, true);
      expect(state.update((previous) => (previous ?? 0) + 1).hasData, true);
    });

    test("supports hasError", () {
      expect(SubState<int>(value: 0).hasError, false);
      expect(SubState<int>.withError("").hasError, true);
      expect(SubState<int>.withLoading().hasError, false);
      expect(SubState<int>.withEmpty().hasError, false);
      expect(SubState<int>(value: 0, error: "").hasError, true);
      expect(SubState<int>(value: null).withError("").hasError, true);
    });

    test("supports map without null exception", () {
      final increment = (int current) => current + 1;
      final nullState = SubState<int>(value: null);
      expect(nullState.map(increment), null);
      expect(nullState.map(increment, orElse: () => 1), 1);
      expect(nullState.map(increment, orElse: null), null);

      final state = SubState<int>(value: 0);
      expect(state.withError("error").map(increment), 1);
      expect(state.withLoading().map(increment), 1);
      expect(state.copyWith(value: 1).map(increment), 2);
      expect(state.copyWith(value: null).map(increment), 1);
      expect(state.copyWith(loading: true).map(increment), 1);
      expect(state.copyWith(error: "error").map(increment), 1);
      expect(state.copyWith(empty: true).map(increment), 1);
      expect(state.update((previous) => previous).map(increment), 1);
      expect(state.update((previous) => previous + 1).map(increment), 2);
    });

    test("supports valueOr for null values", () {
      final nullState = SubState<int>(value: null);
      expect(nullState.valueOr(2), 2);
      expect(nullState.valueOr(null), null);
    });

    test("equality works normally", () {
      expect(SubState<int>(value: 0), SubState<int>(value: 0));
      expect(SubState<int>(value: 0, empty: true), SubState<int>(value: 0, empty: true));
      expect(
        SubState<int>(value: 0, empty: true, error: "error"),
        SubState<int>(value: 0, empty: true, error: "error"),
      );
      expect(
        SubState<int>(value: 0, empty: true, error: "error", loading: true),
        SubState<int>(value: 0, empty: true, error: "error", loading: true),
      );
    });

    test("hashCode are on-point", () {
      expect(SubState<int>(value: 0).hashCode, SubState<int>(value: 0).hashCode);
      expect(
        SubState<int>(value: 0, empty: true).hashCode,
        SubState<int>(value: 0, empty: true).hashCode,
      );
      expect(
        SubState<int>(value: 0, empty: true, error: "error").hashCode,
        SubState<int>(value: 0, empty: true, error: "error").hashCode,
      );
      expect(
        SubState<int>(value: 0, empty: true, error: "error", loading: true).hashCode,
        SubState<int>(value: 0, empty: true, error: "error", loading: true).hashCode,
      );
    });
  });
}
