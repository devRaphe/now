import 'package:borome/constants.dart';
import 'package:flutter/material.dart' show IconButton, Colors;
import 'package:flutter/widgets.dart';

class BellButton extends StatelessWidget {
  const BellButton({
    Key key,
    @required this.color,
    @required this.onPressed,
    @required this.hasUnreadCount,
  }) : super(key: key);

  final Color color;
  final VoidCallback onPressed;
  final int hasUnreadCount;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: IconTheme.of(context).size,
      icon: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Icon(AppIcons.alarm, color: color),
          hasUnreadCount > 0
              ? IgnorePointer(
                  child: Align(
                    alignment: const FractionalOffset(.8, .25),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 1.5),
                      ),
                      child: const SizedBox(height: 12.0, width: 12.0),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      onPressed: onPressed,
      color: Colors.white,
    );
  }
}
