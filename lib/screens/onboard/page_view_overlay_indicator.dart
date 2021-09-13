import 'package:borome/constants.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class PageViewItem {
  PageViewItem({
    @required this.color,
    @required this.text,
    @required this.gradientColor,
    @required this.image,
    @required this.brightness,
  });

  final Color color;
  final String text;
  final Color gradientColor;
  final ImageProvider image;
  final Brightness brightness;
}

class PageViewOverlayIndicator extends AnimatedWidget {
  const PageViewOverlayIndicator({
    Key key,
    @required PageController controller,
    @required this.pages,
    @required this.onComplete,
  }) : super(key: key, listenable: controller);

  PageController get controller => listenable;
  final List<PageViewItem> pages;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final page = controller.page ?? 0;
    final currentIndex = page.ceil() ?? 0;
    final nextIndex = page.round() ?? 0;
    final text = pages[nextIndex].text;
    final threshold = (page - currentIndex).abs();
    final color = Color.lerp(pages[currentIndex].color, pages[nextIndex].color, threshold);
    final gradientColor = Color.lerp(pages[currentIndex].gradientColor, pages[nextIndex].gradientColor, threshold);
    final textStyle = ThemeProvider.of(context).headline.copyWith(height: .89).copyWith(color: color);
    final lastIndex = pages.length - 1;

    return AppStatusBar(
      brightness: pages[nextIndex].brightness,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, gradientColor.withOpacity(.5), gradientColor],
                    begin: const Alignment(0.0, -.5),
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: null,
            left: context.scale(52),
            right: context.scale(32),
            bottom: MediaQuery.of(context).padding.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IgnorePointer(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 350),
                    child: Text(text, key: ValueKey<int>(nextIndex), style: textStyle),
                  ),
                ),
                const ScaledBox.vertical(32),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: context.scaleY(48)),
                  child: Row(
                    children: <Widget>[
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 350),
                        child: SizedBox(
                          key: ValueKey<int>(nextIndex),
                          child: CustomPaint(
                            painter: _IndicatorPainter(color: color, index: nextIndex, count: pages.length),
                          ),
                        ),
                      ),
                      Expanded(child: IgnorePointer(child: const SizedBox())),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 350),
                        child: nextIndex == lastIndex
                            ? FilledButton(
                                minWidth: 100,
                                backgroundColor: Colors.white,
                                child: Text("ENTER"),
                                color: AppColors.primary,
                                onPressed: onComplete,
                              )
                            : TouchableOpacity(
                                color: color,
                                minWidth: 100,
                                child: Text("SKIP"),
                                onPressed: () => controller.animateToPage(
                                  lastIndex,
                                  duration: Duration(milliseconds: 350),
                                  curve: Curves.decelerate,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                const ScaledBox.vertical(16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicatorPainter extends CustomPainter {
  const _IndicatorPainter({
    this.color,
    this.index,
    this.count,
  });

  final Color color;
  final int index;
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 5.0;
    for (int i = 0; i < count; i++) {
      final offset = Offset((radius * 2 * (1 + i)) + (i * radius), size.height / 2);
      canvas.drawCircle(offset, radius, Paint()..color = i == index ? color : color.withOpacity(.3));
    }
  }

  @override
  bool shouldRepaint(_IndicatorPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.index != index || oldDelegate.count != count;
}
