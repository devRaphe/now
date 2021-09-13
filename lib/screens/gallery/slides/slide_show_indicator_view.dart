import 'dart:math' as math;

import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import "package:flutter_scale_aware/flutter_scale_aware.dart";
import 'package:provider/provider.dart';

class SlideShowIndicatorView extends StatefulWidget {
  const SlideShowIndicatorView({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  _SlideShowIndicatorViewState createState() => _SlideShowIndicatorViewState();
}

class _SlideShowIndicatorViewState extends State<SlideShowIndicatorView> {
  double _currentPage;
  ScrollController controller;
  final paddingVertical = 16;
  final itemHeight = 62;

  @override
  void initState() {
    _currentPage = widget.controller.initialPage.toDouble();
    controller = ScrollController();
    widget.controller.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.jumpTo(_currentPage * context.scaleY(itemHeight));
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    final items = Provider.of<ImageList>(context);
    return Container(
      height: context.scaleY(itemHeight + (paddingVertical * 2)),
      child: ListView.custom(
        controller: controller,
        physics: ClampingScrollPhysics(),
        key: PageStorageKey<Type>(runtimeType),
        padding: EdgeInsets.symmetric(horizontal: context.scale(18), vertical: context.scaleY(paddingVertical)),
        scrollDirection: Axis.horizontal,
        childrenDelegate: SliverSeparatorBuilderDelegate(
          builder: (BuildContext context, int i) {
            return AnimatedBuilder(
              child: Material(
                borderRadius: borderRadius,
                clipBehavior: Clip.antiAlias,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: InkWell(
                    splashColor: AppColors.secondaryAccent.shade50,
                    child: Ink(
                      decoration: BoxDecoration(color: AppColors.dark.shade200),
                      child: CachedImage(url: items.items[i].url),
                    ),
                    onTap: () => widget.controller
                        .animateToPage(i, curve: Curves.decelerate, duration: Duration(milliseconds: 350)),
                  ),
                ),
              ),
              animation: widget.controller,
              builder: (BuildContext context, Widget child) {
                final t = 1 - (i - _currentPage).abs().clamp(0.0, 1.0);
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2 * t,
                      color: Color.lerp(Colors.transparent, AppColors.secondaryAccent, t),
                    ),
                    borderRadius: borderRadius,
                  ),
                  padding: EdgeInsets.all(2 * t),
                  child: child,
                );
              },
            );
          },
          separatorBuilder: (context, _) => const ScaledBox.horizontal(10),
          childCount: items.items.length,
        ),
      ),
    );
  }

  void _listener() {
    _currentPage = widget.controller.page;
    controller.animateTo(
      math.max(_currentPage - 1, 0) * context.scaleY(itemHeight),
      curve: Curves.decelerate,
      duration: Duration(milliseconds: 350),
    );
  }
}
