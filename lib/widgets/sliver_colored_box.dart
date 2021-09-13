import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SliverColoredBox extends SingleChildRenderObjectWidget {
  const SliverColoredBox({
    Key key,
    @required this.color,
    @required Widget sliver,
  }) : super(key: key, child: sliver);

  final Color color;

  @override
  RenderSliverColoredBox createRenderObject(BuildContext context) {
    return RenderSliverColoredBox(color: color);
  }

  @override
  void updateRenderObject(BuildContext context, RenderSliverColoredBox renderObject) {
    renderObject..color = color;
  }
}

class RenderSliverColoredBox extends RenderSliver with RenderObjectWithChildMixin<RenderSliver> {
  RenderSliverColoredBox({Color color = const Color(0xFFFFFFFF)})
      : assert(color != null),
        _color = color;

  Color get color => _color;
  Color _color;

  set color(Color value) {
    assert(value != null);
    if (_color == value) {
      return;
    }
    final bool didNeedCompositing = alwaysNeedsCompositing;
    _color = value;
    if (didNeedCompositing != alwaysNeedsCompositing) {
      markNeedsCompositingBitsUpdate();
    }
    markNeedsPaint();
  }

  @override
  PhysicalModelLayer get layer => super.layer;

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child != null);
    final SliverPhysicalParentData childParentData = child.parentData;
    childParentData.applyPaintTransform(transform);
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    if (child != null) {
      visitor(child);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
  }

  @override
  void performLayout() {
    assert(child != null);
    child.layout(constraints, parentUsesSize: true);
    geometry = child.geometry;
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData) {
      child.parentData = SliverPhysicalParentData();
    }
  }

  @override
  bool hitTestChildren(SliverHitTestResult result, {double mainAxisPosition, double crossAxisPosition}) {
    return child != null &&
        child.geometry.hitTestExtent > 0 &&
        child.hitTest(result, mainAxisPosition: mainAxisPosition, crossAxisPosition: crossAxisPosition);
  }

  @override
  double childMainAxisPosition(RenderSliver child) {
    assert(child != null);
    assert(child == this.child);
    return 0.0;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    layer ??= PhysicalModelLayer();
    layer
      ..clipPath = (Path()..addRect(offset & getAbsoluteSize()))
      ..elevation = 0.0
      ..color = color
      ..shadowColor = const Color(0x00000000);
    context.pushLayer(layer, child.paint, offset);
  }
}
