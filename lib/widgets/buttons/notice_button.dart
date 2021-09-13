import 'package:borome/domain.dart';
import 'package:borome/store.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class NoticeButton extends StatelessWidget {
  const NoticeButton({
    Key key,
    this.color,
    this.onPressed,
  }) : super(key: key);

  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SubState<List<NoticeModel>>>(
      initialData: context.store.state.value.notice,
      stream: context.store.state.map((state) => state.notice),
      builder: (context, snapshot) => snapshot.data.map(
        (data) => BellButton(
          color: color,
          hasUnreadCount: data.where((i) => !i.isReadAsBool).length,
          onPressed: onPressed,
        ),
        orElse: () => Center(child: LoadingSpinner.circle(color: Colors.white54)),
      ),
    );
  }
}
