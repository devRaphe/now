import 'package:borome/utils.dart';
import 'package:flutter/widgets.dart';

class LoanRequestService extends SimpleRoutingService {
  factory LoanRequestService({int initialIndex = 0, @required List<SimpleRoute> routes}) {
    return LoanRequestService._(
      initialIndex: initialIndex,
      observer: SimpleRouteObserver(),
      routes: routes,
    ).._initialize();
  }

  LoanRequestService._({
    @required int initialIndex,
    @required this.observer,
    @required List<SimpleRoute> routes,
  }) : super(initialIndex, routes);

  final SimpleRouteObserver observer;

  void _initialize() {
    observer.listen((settings) {
      value = findIndex(settings.name);
    });
  }

  @override
  void dispose() {
    observer.dispose();
    super.dispose();
  }
}
