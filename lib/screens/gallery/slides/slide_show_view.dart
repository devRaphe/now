import 'package:borome/domain.dart';
import 'package:borome/screens/gallery/slides/slide_show_item.dart';
import 'package:flutter/material.dart';
import "package:flutter_scale_aware/flutter_scale_aware.dart";
import 'package:provider/provider.dart';

class SlideShowView extends StatefulWidget {
  const SlideShowView({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  _SlideShowViewState createState() => _SlideShowViewState();
}

class _SlideShowViewState extends State<SlideShowView> {
  double _currentPage;

  @override
  void initState() {
    _currentPage = widget.controller.initialPage.toDouble();
    widget.controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<ImageList>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.scaleY(32)),
      child: PageView.builder(
        controller: widget.controller,
        itemCount: items.items.length,
        itemBuilder: (_, i) {
          return AnimatedBuilder(
            animation: widget.controller,
            child: SlideShowItem(item: items.items[i]),
            builder: (context, child) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scale(12),
                  vertical: (i - _currentPage).abs() * context.scaleY(20),
                ),
                child: child,
              );
            },
          );
        },
      ),
    );
  }

  void _listener() => _currentPage = widget.controller.page;
}
