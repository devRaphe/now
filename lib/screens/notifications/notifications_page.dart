import 'package:borome/domain.dart';
import 'package:borome/screens/notifications/notification_item.dart';
import 'package:borome/store.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: Text("Notifications"), primary: true),
          StreamBuilder<SubState<List<NoticeModel>>>(
            initialData: context.store.state.value.notice,
            stream: context.store.state.map((state) => state.notice),
            builder: (context, snapshot) {
              if (snapshot.data.loading) {
                return SliverFillRemaining(child: Center(child: LoadingSpinner.circle()));
              }

              if (snapshot.data.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(snapshot.data.error, textAlign: TextAlign.center),
                        TextButton(
                          child: Text("RETRY"),
                          onPressed: () => context.dispatchAction(NoticeActions.fetch()),
                        )
                      ],
                    ),
                  ),
                );
              }

              final data = snapshot.data.value;

              return SliverColoredBox(
                color: Colors.white,
                sliver: SliverPadding(
                  padding: const EdgeInsets.only(top: 18, bottom: 32),
                  sliver: data.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(heightFactor: 12, child: Text("No notifications to see yet")),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, index) => NotificationItem(item: data[index]),
                            childCount: data.length,
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
