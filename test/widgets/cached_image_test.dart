import 'package:borome/widgets/cached_image.dart';
import 'package:borome/widgets/loading_spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group("CachedImage", () {
    testWidgets("works normally with url", (tester) async {
      const url = "";
      await tester.pumpWidget(MaterialApp(home: CachedImage(url: url)));
      expect(find.byKey(CachedImage.imageKey), findsOneWidget);
      expect(find.byKey(CachedImage.loadingKey), findsOneWidget);

      final image = tester.widget<CachedNetworkImage>(find.byKey(CachedImage.imageKey));
      expect(image.imageUrl, url);
    });

    testWidgets("shows empty widget when no url", (tester) async {
      await tester.pumpWidget(MaterialApp(home: CachedImage(url: null)));
      expect(find.byKey(CachedImage.emptyKey), findsOneWidget);
    });

    testWidgets("works with other parameters", (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CachedImage(url: "", height: 20, fit: BoxFit.cover, loadingColor: Colors.red)),
      );
      final image = tester.widget<CachedNetworkImage>(find.byKey(CachedImage.imageKey));
      expect(image.height, 20);
      expect(image.fit, BoxFit.cover);

      final loading = tester.widget<LoadingSpinner>(find.byKey(CachedImage.loadingKey));
      expect(loading.color, Colors.red);
    });
  });
}
