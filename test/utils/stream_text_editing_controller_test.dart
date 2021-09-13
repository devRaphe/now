import 'package:borome/utils/stream_text_editing_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

// TODO: important
void main() {
  group("StreamTextEditingController", () {
    test("works normally", () async {
      final data = <String>[];
      final editor = StreamTextEditingController();

      editor.stream.listen(data.add);
      await tick();

      expect(data.length, 0);

      editor.dispose();
    });
  });
}
