import 'package:flutter/widgets.dart';

class OneTimeBuilder extends StatefulWidget {
  const OneTimeBuilder({
    Key key,
    @required this.once,
    @required this.child,
  })  : assert(once != null),
        assert(child != null),
        super(key: key);

  final VoidCallback once;
  final Widget child;

  @override
  _OneTimeBuilderState createState() => _OneTimeBuilderState();
}

class _OneTimeBuilderState extends State<OneTimeBuilder> {
  bool _hasBuilt = false;

  @override
  Widget build(BuildContext context) {
    if (!_hasBuilt) {
      _hasBuilt = true;
      widget.once();
    }

    return widget.child;
  }
}
