import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Display a platform dependent Action Sheet
class PlatformActionSheet {
  /// Function to display the sheet
  static Future<T> show<T>({
    @required BuildContext context,
    Widget title,
    Widget message,
    @required List<ActionSheetAction> actions,
  }) {
    if (Platform.isIOS) {
      return _showCupertinoActionSheet<T>(context, title, message, actions);
    }
    return _settingModalBottomSheet<T>(context, title, message, actions);
  }
}

Future<T> _showCupertinoActionSheet<T>(
  BuildContext context,
  Widget title,
  Widget message,
  List<ActionSheetAction> actions,
) {
  const noCancelOption = -1;
  // Cancel action is treated differently with CupertinoActionSheets
  final indexOfCancel = actions.lastIndexWhere((action) => action.isCancel);
  final actionSheet = indexOfCancel == noCancelOption
      ? CupertinoActionSheet(
          title: title,
          message: message,
          actions:
              actions.where((action) => !action.isCancel).map<Widget>(_cupertinoActionSheetActionFromAction).toList(),
        )
      : CupertinoActionSheet(
          title: title,
          message: message,
          actions:
              actions.where((action) => !action.isCancel).map<Widget>(_cupertinoActionSheetActionFromAction).toList(),
          cancelButton: _cupertinoActionSheetActionFromAction(actions[indexOfCancel]),
        );
  return showCupertinoModalPopup<T>(context: context, builder: (_) => actionSheet);
}

CupertinoActionSheetAction _cupertinoActionSheetActionFromAction(ActionSheetAction action) =>
    CupertinoActionSheetAction(
      child: Text(action.text),
      onPressed: action.onPressed,
      isDefaultAction: action.defaultAction,
    );

ListTile _listTileFromAction(ActionSheetAction action) => action.hasArrow
    ? ListTile(
        title: Text(action.text),
        onTap: action.onPressed,
        trailing: Icon(Icons.keyboard_arrow_right),
      )
    : ListTile(
        title: Text(
          action.text,
          style: TextStyle(fontWeight: action.defaultAction ? FontWeight.bold : FontWeight.normal),
        ),
        onTap: action.onPressed,
      );

Future<T> _settingModalBottomSheet<T>(
  BuildContext context,
  Widget title,
  Widget message,
  List<ActionSheetAction> actions,
) {
  assert(actions.isNotEmpty);

  return showModalBottomSheet<T>(
    context: context,
    builder: (_) {
      const _lastItem = 1, _secondLastItem = 2;
      return Container(
        child: SafeArea(
          bottom: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: title,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: message,
              ),
              ListView.separated(
                padding: const EdgeInsets.only(left: 20),
                shrinkWrap: true,
                itemCount: actions.length,
                itemBuilder: (_, index) => _listTileFromAction(actions[index]),
                separatorBuilder: (_, index) {
                  return (index == (actions.length - _secondLastItem) && actions[actions.length - _lastItem].isCancel)
                      ? Divider()
                      : Container();
                },
              ),
            ],
          ),
        ), // Separator above the last option only
      );
    },
  );
}

/// Data class for Actions in ActionSheet
class ActionSheetAction {
  /// Construction of an ActionSheetAction
  ActionSheetAction({
    @required this.text,
    @required this.onPressed,
    this.defaultAction = false,
    this.isCancel = false,
    this.hasArrow = false,
  });

  /// Text to display
  final String text;

  /// The function which will be called when the action is pressed
  final VoidCallback onPressed;

  /// Is this a default action - especially for iOS
  final bool defaultAction;

  /// This is a cancel option - especially for iOS
  final bool isCancel;

  /// on Android indicates that further options are next
  final bool hasArrow;
}
