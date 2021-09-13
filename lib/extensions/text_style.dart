import 'package:flutter/widgets.dart';
import "package:flutter_scale_aware/flutter_scale_aware.dart";

extension TextStyleX on TextStyle {
  TextStyle scale(BuildContext context) {
    return copyWith(fontSize: context.fontScale(fontSize));
  }
}
