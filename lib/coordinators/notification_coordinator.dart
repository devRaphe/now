import 'package:borome/domain.dart';
import 'package:borome/route_transition.dart';
import 'package:borome/screens.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'coordinator_base.dart';

@immutable
class NotificationCoordinator extends CoordinatorBase {
  const NotificationCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  void toList() => navigator?.push(RouteTransition.slideIn(NotificationsPage()));

  void toDetail({@required NoticeModel item}) =>
      navigator?.push(RouteTransition.fadeIn(NotificationDetailPage(item: item), fullscreenDialog: true));

  void toGallery({@required List<ImageListItem> items, @required ImageListItem item}) {
    navigator?.push(RouteTransition.fadeIn(
      Provider<ImageList>.value(value: items.toImageList(), child: GalleryPage(item: item)),
    ));
  }
}
