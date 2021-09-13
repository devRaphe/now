import 'package:borome/widgets/scaled_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group("ScaledBox", () {
    testWidgets("works normally", (tester) async {
      final finder = find.byType(SizedBox);

      await tester.pumpWidget(ScaleAware(child: MaterialApp(home: ScaledBox(width: 10, height: 10))));
      final el = tester.widget<SizedBox>(finder);
      final context = tester.element(finder);
      expect(el.width, context.scale(10));
      expect(el.height, context.scaleY(10));
    });

    testWidgets("works normally with child", (tester) async {
      await tester.pumpWidget(
        ScaleAware(child: MaterialApp(home: ScaledBox(width: 10, height: 10, child: Text("See")))),
      );
      expect(find.text("See"), findsOneWidget);
    });

    testWidgets("works with factories", (tester) async {
      final finder = find.byType(SizedBox);

      await tester.pumpWidget(ScaleAware(child: MaterialApp(home: ScaledBox.horizontal(10))));
      final el1 = tester.widget<SizedBox>(finder);
      final context1 = tester.element(finder);
      expect(el1.width, context1.scale(10));
      expect(el1.height, 0);

      await tester.pumpWidget(ScaleAware(child: MaterialApp(home: ScaledBox.vertical(10))));
      final el2 = tester.widget<SizedBox>(finder);
      final context2 = tester.element(finder);
      expect(el2.width, 0);
      expect(el2.height, context2.scaleY(10));

      await tester.pumpWidget(ScaleAware(child: MaterialApp(home: ScaledBox.fromSize(size: Size(0, 10)))));
      final el3 = tester.widget<SizedBox>(finder);
      final context3 = tester.element(finder);
      expect(el3.width, 0);
      expect(el3.height, context3.scaleY(10));
    });
  });
}
