import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/screens/notifications/notification_detail_view.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class AsyncNotificationDetailPage extends StatefulWidget {
  const AsyncNotificationDetailPage({
    Key key,
    @required this.futureBuilder,
  }) : super(key: key);

  final Future<NoticeModel> Function() futureBuilder;

  @override
  _AsyncNotificationDetailPageState createState() => _AsyncNotificationDetailPageState();
}

class _AsyncNotificationDetailPageState extends State<AsyncNotificationDetailPage> {
  StreamableDataModel<NoticeModel> noticeInfoBloc;
  Stream<DataModel<NoticeModel>> noticeInfoStream;

  @override
  void initState() {
    super.initState();

    noticeInfoBloc = StreamableDataModel(
      widget.futureBuilder,
      errorMapper: errorToString,
      emptyPredicate: (data) => data == null,
    );

    noticeInfoStream = noticeInfoBloc.stream;
  }

  @override
  void dispose() {
    noticeInfoBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      appBar: ClearAppBar(),
      body: StreamBuilder<DataModel<NoticeModel>>(
        stream: noticeInfoStream,
        initialData: noticeInfoBloc.value,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data.isLoading) {
            return Column(
              children: [
                LoadingSpinner.linear(),
                Expanded(child: LoadingWidget(message: AppStrings.loadingMessage)),
              ],
            );
          }

          if (data.hasError || data.isEmpty) {
            return Center(
              child: TouchableOpacity(
                child: ErrorTextWidget(message: data.isEmpty ? "No content to see here" : data.message),
                onPressed: noticeInfoBloc.refresh,
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(18, 0, 18, 32 + MediaQuery.of(context).padding.bottom),
            child: NotificationDetailView(item: data.valueOrNull),
          );
        },
      ),
    );
  }
}
