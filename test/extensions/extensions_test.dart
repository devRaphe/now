import 'package:borome/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group("Extensions", () {
    group("SizeX", () {
      testWidgets("works normally", (tester) async {
        final finder = find.byType(SizedBox);

        await tester.pumpWidget(ScaleAware(
          child: MaterialApp(
            home: Builder(
              builder: (context) => SizedBox.fromSize(size: Size.square(10).scale(context)),
            ),
          ),
        ));
        final el = tester.widget<SizedBox>(finder);
        final context = tester.element(finder);
        expect(el.width, context.scale(10));
        expect(el.height, context.scaleY(10));
      });
    });

    group("EdgeInsetsX", () {
      testWidgets("works normally", (tester) async {
        final key = ValueKey("padding");
        final finder = find.byKey(key);

        await tester.pumpWidget(ScaleAware(
          child: MaterialApp(
            home: Builder(
              builder: (context) => Padding(key: key, padding: EdgeInsets.all(10).scale(context)),
            ),
          ),
        ));
        final insets = tester.widget<Padding>(finder).padding.resolve(TextDirection.ltr);
        final context = tester.element(finder);
        expect(insets.left, context.scale(10));
        expect(insets.right, context.scale(10));
        expect(insets.top, context.scaleY(10));
        expect(insets.bottom, context.scaleY(10));
      });
    });
  });
}
