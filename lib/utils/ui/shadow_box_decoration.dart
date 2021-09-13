import 'package:flutter/rendering.dart';

class ShadowBoxDecoration extends BoxDecoration {
  const ShadowBoxDecoration({Border border})
      : super(
          color: const Color(0xFFFFFFFF),
          border: border,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 8,
              color: Color.fromRGBO(0, 0, 0, .05),
            ),
          ],
        );
}
