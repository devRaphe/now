import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:borome/constants.dart';
import 'package:borome/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

typedef LabelBuilder = String Function(double value);

class SliderWidget extends LeafRenderObjectWidget {
  const SliderWidget({
    Key key,
    @required this.labelBuilder,
    @required this.min,
    @required this.max,
    @required this.steps,
    this.value = 0.0,
    this.onChanged,
  }) : super(key: key);

  final double value;
  final double min;
  final double max;
  final int steps;
  final LabelBuilder labelBuilder;
  final ValueChanged<double> onChanged;

  @override
  SliderRenderObject createRenderObject(BuildContext context) {
    return SliderRenderObject(
      value: value,
      min: min,
      max: max,
      steps: steps,
      labelBuilder: labelBuilder,
      onChanged: onChanged,
    );
  }

  @override
  void updateRenderObject(BuildContext context, SliderRenderObject renderObject) {
    renderObject
      ..value = value
      ..min = min
      ..max = max
      ..steps = steps
      ..labelBuilder = labelBuilder
      ..onChanged = onChanged;
  }
}

// TODO: animations
class SliderRenderObject extends RenderBox {
  SliderRenderObject({
    @required double value,
    @required double min,
    @required double max,
    @required int steps,
    @required LabelBuilder labelBuilder,
    @required ValueChanged<double> onChanged,
  })  : assert(value != null),
        assert(steps != null),
        _steps = steps,
        _value = value,
        _labelBuilder = labelBuilder,
        _onChanged = onChanged {
    _recognizer = HorizontalDragGestureRecognizer()
      ..onStart = _handleDragStart
      ..onEnd = ((_) => _handleDragCancel())
      ..onUpdate = _handleDragUpdate
      ..onCancel = _handleDragCancel;

    _min = _deriveMin(min, steps);
    _max = _deriveMax(max, steps);
    _selectedIndex = _deriveSelectedIndex(value, min: _min, max: _max, divisions: _divisions);
  }

  int _selectedIndex;

  double _value;

  set value(double value) {
    _value = value;
    final index = _deriveSelectedIndex(value, min: _min, max: _max, divisions: _divisions);
    if (_selectedIndex == index) {
      return;
    }
    _selectedIndex = index;
    markNeedsPaint();
  }

  int get _divisions => (_max - _min) ~/ _steps;

  int _steps;

  set steps(int steps) {
    if (_steps == steps) {
      return;
    }
    _steps = steps;
    _min = _deriveMin(_min, _steps);
    _max = _deriveMax(_max, _steps);
    _selectedIndex = _deriveSelectedIndex(_value, min: _min, max: _max, divisions: _divisions);
    markNeedsPaint();
  }

  double _min;

  set min(double value) {
    var amount = _deriveMin(value, _steps);
    if (_min == amount) {
      return;
    }
    _min = amount;
    markNeedsPaint();
  }

  double _max;

  set max(double value) {
    var amount = _deriveMax(value, _steps);
    if (_max == amount) {
      return;
    }
    _max = amount;
    markNeedsPaint();
  }

  LabelBuilder _labelBuilder;

  set labelBuilder(LabelBuilder labelBuilder) {
    if (_labelBuilder == labelBuilder) {
      return;
    }
    _labelBuilder = labelBuilder;
    markNeedsPaint();
  }

  ValueChanged<double> _onChanged;

  set onChanged(ValueChanged<double> onChanged) {
    if (_onChanged == onChanged) {
      return;
    }
    _onChanged = onChanged;
  }

  static double _deriveMin(double amount, int steps) {
    var rem = amount % steps;
    return amount + (rem > 0 ? steps - rem : 0);
  }

  static double _deriveMax(double amount, int steps) {
    return amount - (amount % steps);
  }

  static int _deriveSelectedIndex(double value, {@required double max, @required double min, @required int divisions}) {
    return interpolate(inputMax: max, inputMin: min, outputMax: (divisions - 0).toDouble())(value).toInt();
  }

  double _currentDragValue = 0.0;
  HorizontalDragGestureRecognizer _recognizer;

  void _handleDragStart(DragStartDetails details) {
    _currentDragValue = (details.localPosition.dx).clamp(0, size.width);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _currentDragValue += details.primaryDelta;
    _onRangeChanged((_currentDragValue / size.width).clamp(0.0, 1.0));
  }

  void _handleDragCancel() => _currentDragValue = 0.0;

  void _onRangeChanged(double value) {
    final selectedIndex = (value * _divisions).round();
    if (selectedIndex == _selectedIndex) {
      return;
    }
    _selectedIndex = selectedIndex;
    HapticFeedback.selectionClick();
    _onChanged?.call(_min + (_selectedIndex * _steps));
    markNeedsPaint();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool get sizedByParent => true;

  @override
  ui.Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));

    if (event is PointerDownEvent) {
      _recognizer.addPointer(event);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final preferredStrokeWidth = size.width * .005;
    final preferredWidth = size.width - (preferredStrokeWidth * 2);
    final height = size.height;
    final bounds = Rect.fromCenter(center: size.center(offset), width: preferredWidth, height: height);

    final verticalSpaceRadius = math.min(4.0, height * .1 / 2);
    final labelHeight = math.min(14.0, (height - verticalSpaceRadius) * .25);

    final space = preferredWidth / _divisions;
    final selectedTickHeight = height - verticalSpaceRadius - labelHeight;
    final smallTickHeight = selectedTickHeight * .325;
    for (int i = 0; i < (_divisions + 1); i++) {
      final color = i <= _selectedIndex ? AppColors.primary : const Color(0xFFDEDEDE);
      final strokeWidth = i == _selectedIndex ? (preferredStrokeWidth * 2) : preferredStrokeWidth;
      final strokeHeight = i == _selectedIndex ? selectedTickHeight : smallTickHeight;
      final offset = bounds.topLeft + Offset(i * space, selectedTickHeight / 2 - strokeHeight / 2);

      canvas.drawLine(
        offset,
        offset.translate(0, strokeHeight),
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth,
      );
    }

    final maxLabelParagraph = _buildParagraph(_max);
    canvas
      ..drawParagraph(_buildParagraph(_min), bounds.bottomLeft.translate(0, -labelHeight))
      ..drawParagraph(
        maxLabelParagraph,
        bounds.bottomRight.translate(-maxLabelParagraph.maxIntrinsicWidth, -labelHeight),
      );
  }

  ui.Paragraph _buildParagraph(double text) {
    final ui.TextStyle style = ui.TextStyle(
      fontStyle: FontStyle.normal,
      fontSize: 12.0,
      color: AppColors.dark,
      height: 1.24,
      letterSpacing: 1.25,
      fontWeight: FontWeight.w600,
      fontFamily: AppFonts.base,
    );
    final label = ui.ParagraphBuilder(ui.ParagraphStyle())
      ..pushStyle(style)
      ..addText(_labelBuilder(text))
      ..pop();
    return label.build()..layout(ui.ParagraphConstraints(width: size.width));
  }
}
