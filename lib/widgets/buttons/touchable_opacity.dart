import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TouchableOpacity extends StatefulWidget {
  const TouchableOpacity({
    Key key,
    @required this.child,
    this.color = AppColors.primary,
    this.padding,
    this.disabledColor,
    this.minHeight,
    this.minWidth,
    this.pressedOpacity = 0.1,
    @required this.onPressed,
  })  : assert(pressedOpacity == null || (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        super(key: key);

  factory TouchableOpacity.icon({
    Key key,
    @required Icon icon,
    @required Widget child,
    EdgeInsetsGeometry padding,
    Color color,
    Color disabledColor,
    double minHeight,
    double minWidth,
    VoidCallback onPressed,
    double pressedOpacity,
  }) = _TouchableOpacityIconButton;

  final Widget child;
  final EdgeInsetsGeometry padding;

  final Color color;
  final double minHeight;
  final double minWidth;
  final Color disabledColor;
  final VoidCallback onPressed;

  final double pressedOpacity;

  bool get enabled => onPressed != null;

  @override
  _TouchableOpacityState createState() => _TouchableOpacityState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      FlagProperty('enabled', value: enabled, ifFalse: 'disabled'),
    );
  }
}

class _TouchableOpacityState extends State<TouchableOpacity> with SingleTickerProviderStateMixin {
  static const Duration kFadeOutDuration = Duration(milliseconds: 10);
  static const Duration kFadeInDuration = Duration(milliseconds: 100);
  Tween<double> _opacityTween;

  AnimationController _animationController;

  void _setTween() {
    _opacityTween = Tween<double>(begin: 1.0, end: widget.pressedOpacity ?? 1.0);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), value: 0.0, vsync: this);
    _setTween();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(TouchableOpacity old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) {
      return;
    }
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0, duration: kFadeOutDuration)
        : _animationController.animateTo(0.0, duration: kFadeInDuration);
    ticker.then<void>((value) {
      if (mounted && wasHeldDown != _buttonHeldDown) {
        _animate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.minHeight ?? Theme.of(context).buttonTheme.height,
          minWidth: widget.minWidth ?? 0.0,
        ),
        child: Semantics(
          button: true,
          child: FadeTransition(
            opacity: _opacityTween.animate(CurvedAnimation(parent: _animationController, curve: Curves.decelerate)),
            child: Padding(
              padding: widget.padding ?? EdgeInsets.zero,
              child: Center(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: DefaultTextStyle(
                  child: widget.child,
                  style: ThemeProvider.of(context).button.copyWith(color: widget.color, letterSpacing: .8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TouchableOpacityIconButton extends TouchableOpacity {
  _TouchableOpacityIconButton({
    Key key,
    @required Icon icon,
    @required Widget child,
    EdgeInsetsGeometry padding,
    Color color = AppColors.primary,
    double minHeight,
    double minWidth,
    Color disabledColor,
    VoidCallback onPressed,
    double pressedOpacity,
  })  : assert(icon != null),
        super(
          key: key,
          padding: padding,
          color: color,
          minHeight: minHeight,
          minWidth: minWidth,
          disabledColor: disabledColor,
          onPressed: onPressed,
          pressedOpacity: pressedOpacity,
          child: Row(
            children: <Widget>[
              IconTheme.merge(data: IconThemeData(color: color), child: icon),
              const ScaledBox.horizontal(6),
              child,
            ],
          ),
        );
}
