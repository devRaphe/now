import 'package:borome/domain.dart';
import 'package:borome/screens/notifications/notification_detail_view.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({Key key, @required this.item}) : super(key: key);

  final NoticeModel item;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      appBar: ClearAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(18, 0, 18, 32 + MediaQuery.of(context).padding.bottom),
        child: NotificationDetailView(item: item),
      ),
    );
  }
}
