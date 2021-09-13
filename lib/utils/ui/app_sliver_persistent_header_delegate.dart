import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  const AppSliverPersistentHeaderDelegate({
    @required this.builder,
    double height,
    double minExtent,
    double maxExtent,
    this.snapConfiguration,
    this.floating = false,
  })  : minExtent = height ?? minExtent ?? kTextTabBarHeight,
        maxExtent = height ?? maxExtent ?? kTextTabBarHeight;

  final Widget Function(BuildContext context, double shrinkOffset, bool overlapsContent, bool isAtTop) builder;
  @override
  final double maxExtent;
  @override
  final double minExtent;
  @override
  final FloatingHeaderSnapConfiguration snapConfiguration;

  final bool floating;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final child = builder(context, shrinkOffset, overlapsContent, shrinkOffset == 0);
    return floating ? _FloatingPersistentWidget(child: child) : child;
  }

  @override
  bool shouldRebuild(AppSliverPersistentHeaderDelegate oldDelegate) =>
      maxExtent != oldDelegate.maxExtent ||
      minExtent != oldDelegate.minExtent ||
      builder != oldDelegate.builder ||
      snapConfiguration != oldDelegate.snapConfiguration ||
      floating != oldDelegate.floating;
}

class _FloatingPersistentWidget extends StatefulWidget {
  const _FloatingPersistentWidget({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _FloatingPersistentWidgetState createState() => _FloatingPersistentWidgetState();
}

class _FloatingPersistentWidgetState extends State<_FloatingPersistentWidget> {
  ScrollPosition _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_position != null) {
      _position.isScrollingNotifier.removeListener(_isScrollingListener);
    }
    _position = Scrollable.of(context)?.position;
    if (_position != null) {
      _position.isScrollingNotifier.addListener(_isScrollingListener);
    }
  }

  @override
  void dispose() {
    if (_position != null) {
      _position.isScrollingNotifier.removeListener(_isScrollingListener);
    }
    super.dispose();
  }

  RenderSliverFloatingPersistentHeader _headerRenderer() {
    return context.findAncestorRenderObjectOfType<RenderSliverFloatingPersistentHeader>();
  }

  void _isScrollingListener() {
    if (_position == null) {
      return;
    }

    // When a scroll stops, then maybe snap the appbar into view.
    // Similarly, when a scroll starts, then maybe stop the snap animation.
    final RenderSliverFloatingPersistentHeader header = _headerRenderer();
    if (_position.isScrollingNotifier.value) {
      header?.maybeStopSnapAnimation(_position.userScrollDirection);
    } else {
      header?.maybeStartSnapAnimation(_position.userScrollDirection);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
