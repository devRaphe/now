import 'package:flutter/widgets.dart';

abstract class SimpleRoutingService extends ValueNotifier<int> {
  SimpleRoutingService(this.initialIndex, this.steps) : super(initialIndex);

  final int initialIndex;
  final List<SimpleRoute> steps;

  int findIndex(String route) => steps.indexWhere((it) => it.name == route);

  String get initialRoute => steps[initialIndex].name;

  int get length => steps.length;

  int get lastIndex => steps.length - 1;

  int get currentIndex => value;

  bool get canGoBack => steps[currentIndex].canGoBack;

  String get nextPage {
    return steps[currentIndex == lastIndex ? currentIndex : currentIndex + 1].name;
  }

  String get previousPage {
    return steps[currentIndex == 0 ? currentIndex : currentIndex - 1].name;
  }

  void reset() {
    value = initialIndex;
  }
}

class SimpleRoute {
  const SimpleRoute(this.name, [this.canGoBack = true]);

  final String name;
  final bool canGoBack;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleRoute && runtimeType == other.runtimeType && name == other.name && canGoBack == other.canGoBack;

  @override
  int get hashCode => name.hashCode ^ canGoBack.hashCode;

  @override
  String toString() {
    return 'SimpleRoute{name: $name, canGoBack: $canGoBack}';
  }
}
