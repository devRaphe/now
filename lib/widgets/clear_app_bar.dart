import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClearAppBar extends StatelessWidget implements PreferredSizeWidget {
  ClearAppBar({
    Key key,
    this.titleSpacing,
    this.automaticallyImplyLeading = true,
    this.title,
    this.child,
    this.systemOverlayStyle = SystemUiOverlayStyle.light,
    this.leading,
    this.trailing,
    this.onPop,
  })  : assert((() => !(title != null && child != null))(), "Only either title or child can be used"),
        super(key: key);

  final double titleSpacing;
  final bool automaticallyImplyLeading;
  final String title;
  final Widget child;
  final SystemUiOverlayStyle systemOverlayStyle;
  final Widget leading;
  final Widget trailing;
  final VoidCallback onPop;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
    final bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    Widget leadingWidget = leading;
    if (leading == null && automaticallyImplyLeading) {
      leadingWidget = useCloseButton ? AppCloseButton(onPressed: onPop) : AppBackButton(onPressed: onPop);
    }

    return AppBar(
      titleSpacing: titleSpacing ?? NavigationToolbar.kMiddleSpacing,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: Colors.transparent,
      leading: leadingWidget,
      centerTitle: true,
      systemOverlayStyle: systemOverlayStyle,
      title: _buildTitle(context),
      elevation: 0,
      actions: <Widget>[if (trailing != null) trailing],
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (child != null) {
      return child;
    }

    if (title != null) {
      return Text(
        title,
        style: ThemeProvider.of(context).display1.copyWith(fontWeight: AppStyle.bold, color: AppColors.primaryDark),
      );
    }

    return null;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
