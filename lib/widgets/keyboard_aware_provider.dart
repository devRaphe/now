import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KeyboardAwareProvider extends StatelessWidget {
  const KeyboardAwareProvider({Key key, this.child}) : super(key: key);

  final Widget child;

  static Keyboard of(BuildContext context) => Provider.of<Keyboard>(context);

  @override
  Widget build(BuildContext context) {
    return Provider<Keyboard>.value(
      value: Keyboard(MediaQuery.of(context).viewInsets),
      child: child,
    );
  }
}

class Keyboard {
  Keyboard(this.insets);

  final EdgeInsets insets;

  bool get isVisible => insets != EdgeInsets.zero;
}
