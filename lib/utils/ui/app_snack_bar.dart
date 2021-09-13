import 'dart:async';

import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:reading_time/reading_time.dart';

class AppSnackBar {
  AppSnackBar.of(BuildContext context) : state = SnackBarProvider.of(context);

  final SnackBarProviderState state;

  FutureOr<void> success(String value, {Duration duration, Alignment alignment}) {
    return _show(
      value,
      leading: Icon(AppIcons.check, color: Colors.white, size: 24),
      alignment: alignment,
      duration: duration,
      color: Colors.white,
      backgroundColor: AppColors.success,
    );
  }

  FutureOr<void> info(String value, {Duration duration, Alignment alignment}) {
    return _show(
      value,
      leading: Icon(AppIcons.alarm, color: AppColors.primary, size: 24),
      alignment: alignment,
      duration: duration,
      backgroundColor: Colors.white,
      color: Colors.black,
    );
  }

  FutureOr<void> error(String value, {Duration duration, Alignment alignment}) {
    return _show(
      value,
      leading: Icon(Icons.warning, color: Colors.white, size: 24),
      alignment: alignment,
      duration: duration,
      color: Colors.white,
      backgroundColor: AppColors.danger,
    );
  }

  FutureOr<void> loading({String value, Color backgroundColor, Color color, Alignment alignment}) {
    return _show(
      value ?? "Hang on...",
      color: color,
      alignment: alignment,
      dismissible: true,
      backgroundColor: backgroundColor,
      duration: Duration(days: 1),
      leading: LoadingSpinner.circle(size: 24, color: color),
    );
  }

  FutureOr<void> _show(
    String value, {
    Widget leading,
    Duration duration,
    bool dismissible = true,
    Color backgroundColor = Colors.white,
    Color color = AppColors.dark,
    Alignment alignment,
  }) {
    assert(value != null);
    return state?.showSnackBar(
      _RowBar(
        backgroundColor: backgroundColor,
        children: [
          if (leading != null) ...[
            leading,
            ScaledBox.horizontal(16),
          ],
          Expanded(child: Text(value ?? "", style: AppFont.semibold(14.0, color))),
        ],
      ),
      duration: duration ?? calculateReadingTime(value ?? ""),
      alignment: alignment,
    );
  }

  Duration calculateReadingTime(String value) {
    if (value.isEmpty) {
      return null;
    }
    final double readTime = readingTime(value)["time"];
    return Duration(milliseconds: ((readTime + 2000) ?? 0.0).round());
  }

  void hide() => state?.hideCurrentSnackBar();
}

class _RowBar extends StatelessWidget {
  const _RowBar({
    Key key,
    @required this.children,
    this.backgroundColor,
    this.color,
  }) : super(key: key);

  final List<Widget> children;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        boxShadow: [
          const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: BoxConstraints(minHeight: context.scaleY(54)),
      padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
      child: DefaultTextStyle(
        style: AppFont.medium(14, color),
        child: Row(children: children),
      ),
    );
  }
}
