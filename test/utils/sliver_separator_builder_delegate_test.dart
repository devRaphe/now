import 'package:borome/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildScrollViewApp(SliverChildDelegate delegate) {
  return MaterialApp(home: CustomScrollView(slivers: <Widget>[SliverList(delegate: delegate)]));
}

void main() {
  group("SliverSeparatorBuilderDelegate", () {
    testWidgets("works normally", (tester) async {
      final delegate = SliverSeparatorBuilderDelegate(
        builder: (_a, _b) => Text("data"),
        separatorBuilder: (_a, _b) => Text("separator"),
        childCount: 2,
      );

      expect(delegate.childCount, 3);

      await tester.pumpWidget(_buildScrollViewApp(delegate));

      expect(find.text('data'), findsNWidgets(2));
      expect(find.text('separator'), findsOneWidget);
    });

    testWidgets("works with headers", (tester) async {
      final delegate = SliverSeparatorBuilderDelegate.withHeader(
        builder: (_a, _b) => Text("data"),
        separatorBuilder: (_a, _b) => Text("separator"),
        headerBuilder: (_a) => Text("header"),
        childCount: 2,
      );

      expect(delegate.childCount, 4);

      await tester.pumpWidget(_buildScrollViewApp(delegate));

      expect(find.text('data'), findsNWidgets(2));
      expect(find.text('separator'), findsOneWidget);
      expect(find.text('header'), findsOneWidget);
    });

    testWidgets("can include top separator with header", (tester) async {
      final delegate = SliverSeparatorBuilderDelegate.withHeader(
        builder: (_a, _b) => Text("data"),
        separatorBuilder: (_a, _b) => Text("separator"),
        headerBuilder: (_a) => Text("header"),
        childCount: 2,
        skipTopSeparator: false,
      );

      expect(delegate.childCount, 5);

      await tester.pumpWidget(_buildScrollViewApp(delegate));

      expect(find.text('data'), findsNWidgets(2));
      expect(find.text('separator'), findsNWidgets(2));
      expect(find.text('header'), findsOneWidget);
    });
  });
}
