import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:intl/intl.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  final NoticeModel item;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => onPressed(context),
        child: Padding(
          padding: EdgeInsets.only(top: context.scaleY(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: context.scaleY(5)),
                child: SizedBox(
                  width: context.scale(40),
                  child: item.isReadAsBool ? null : Icon(Icons.brightness_1, color: AppColors.primary, size: 8),
                ),
              ),
              Expanded(
                child: Container(
                  height: context.scaleY(92),
                  decoration: BoxDecoration(border: Border(bottom: AppBorderSide())),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Material(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: Text(
                                "Recovery Unit",
                                style: ThemeProvider.of(context).bodyBold.copyWith(color: Colors.white),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: item.isReadAsBool ? AppColors.dark.shade500 : AppColors.primaryAccent,
                          ),
                          Text(DateFormat("d MMM y").format(item.createdAt), style: ThemeProvider.of(context).bodyBold),
                        ],
                      ),
                      const ScaledBox.vertical(8),
                      Expanded(
                        child: Text(
                          item.title,
                          style: ThemeProvider.of(context).body1.copyWith(
                              fontWeight: item.isReadAsBool ? AppStyle.regular : AppStyle.semibold,
                              color: AppColors.dark,
                              height: 1.27),
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const ScaledBox.horizontal(18),
            ],
          ),
        ),
      ),
    );
  }

  void onPressed(BuildContext context) {
    if (!item.isReadAsBool) {
      context.store.dispatcher.add(NoticeActions.read(item.id));
    }

    if (item.requestedFilesAsBool) {
      Registry.di.coordinator.profile.toAddFile(isRequested: true);
      return;
    }

    Registry.di.coordinator.notification.toDetail(item: item);
  }
}
