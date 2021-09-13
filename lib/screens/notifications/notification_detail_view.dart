import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:uuid/uuid.dart';

class NotificationDetailView extends StatefulWidget {
  const NotificationDetailView({Key key, @required this.item}) : super(key: key);

  final NoticeModel item;

  @override
  _NotificationDetailViewState createState() => _NotificationDetailViewState();
}

class _NotificationDetailViewState extends State<NotificationDetailView> {
  ImageList images;

  @override
  void initState() {
    super.initState();

    images = List.generate(
      widget.item.images?.length ?? 0,
      (index) => ImageListItem(id: Uuid().v4(), url: widget.item.images[index], index: index),
    ).toImageList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ScaledBox.vertical(18),
        Text(
          widget.item.title,
          style: ThemeProvider.of(context)
              .display1
              .copyWith(fontWeight: AppStyle.bold, color: AppColors.dark, height: 1.27),
        ),
        if (images.isNotEmpty) ...[
          const ScaledBox.vertical(18),
          SizedBox.fromSize(
            size: Size.fromHeight(context.scaleY(182)),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                splashColor: AppColors.secondaryAccent.shade50,
                onTap: () => Registry.di.coordinator.notification.toGallery(items: images.items, item: images.first),
                child: Ink(
                  decoration: BoxDecoration(color: AppColors.dark.shade200),
                  child: Hero(
                    tag: images.first.id,
                    child: CachedImage(url: images.first.url),
                  ),
                ),
              ),
            ),
          ),
        ],
        const ScaledBox.vertical(18),
        Text(
          widget.item.content,
          style: ThemeProvider.of(context).body1.copyWith(color: AppColors.dark, height: 1.27),
        ),
      ],
    );
  }
}
