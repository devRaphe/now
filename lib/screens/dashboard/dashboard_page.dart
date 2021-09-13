import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/screens/dashboard/dashboard_scaffold.dart';
import 'package:borome/screens/history/history_page.dart';
import 'package:borome/screens/home/home_page.dart';
import 'package:borome/screens/payments/payments_page.dart';
import 'package:borome/screens/profile/profile_page.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key}) : super(key: key);

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  int _currentPageIndex = 0;
  TabController _controller;
  List<_TabRouteView> _tabRouteViews;
  List<GlobalKey> _destinationKeys;

  @override
  void initState() {
    super.initState();

    _tabRouteViews = [
      _TabRouteView("Home", AppIcons.home, HomePage(key: const PageStorageKey("home"))),
      _TabRouteView("History", AppIcons.rotate, HistoryPage(key: const PageStorageKey("history"))),
      _TabRouteView("Payments", AppIcons.credit_card, PaymentsPage(key: const PageStorageKey("payments"))),
      _TabRouteView("Profile", AppIcons.social, ProfilePage(key: const PageStorageKey("profile"))),
    ];

    _controller = TabController(
      vsync: this,
      length: _tabRouteViews.length,
      initialIndex: _currentPageIndex,
    )..addListener(_pageListener);

    _destinationKeys = List<GlobalKey>.generate(_tabRouteViews.length, (_) => GlobalKey());
  }

  @override
  void dispose() {
    _controller.removeListener(_pageListener);
    _controller.dispose();
    super.dispose();
  }

  void _pageListener() {
    if (!_controller.indexIsChanging) {
      setState(() => _currentPageIndex = _controller.index);
    }
  }

  void navigateToIndex(int index) {
    _controller.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AppStatusBar(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: StreamBuilder<Pair<SubState<DashboardData>, SubState<ProfileStatusModel>>>(
          initialData: Pair(context.store.state.value.dashboard, context.store.state.value.profileStatus),
          stream: context.store.state.map((state) => Pair(state.dashboard, state.profileStatus)),
          builder: (context, snapshot) {
            final state = snapshot.data;
            final dashboardData = state.first;
            final canShowFab = dashboardData.hasData && (dashboardData.value.lastLoan?.canApplyForLoan ?? true);
            final adImage = dashboardData.value?.adImage;

            return DashboardScaffold(
              backgroundColor: AppColors.dark.shade50,
              body: AnimatedBuilder(
                animation: _controller.animation,
                builder: (context, child) {
                  final value = _controller.animation.value;
                  return Stack(
                    children: [
                      for (int i = 0; i < _tabRouteViews.length; i++)
                        Positioned(
                          left: (i - value) * width,
                          bottom: 0,
                          top: 0,
                          width: width,
                          child: KeyedSubtree(
                            key: _destinationKeys[i],
                            child: Material(
                              type: MaterialType.transparency,
                              child: _tabRouteViews[i].widget,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              fab: canShowFab
                  ? PreferredSize(
                      preferredSize: Size.square(context.scaleY(60)),
                      child: _LoanFab(onPressed: () => applyForLoan(context, profileStatus: state.second.value)),
                    )
                  : null,
              ad: _currentPageIndex == 0 && adImage != null
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(context.scaleY(66)),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: context.scale(28)),
                        child: CachedImage(url: adImage, height: context.scaleY(66)),
                      ),
                    )
                  : null,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(context.scaleY(60)),
                child: _BottomBar(
                  items: [
                    for (int i = 0; i < _tabRouteViews.length; i++)
                      _BottomItem(
                        icon: _tabRouteViews[i].icon,
                        title: _tabRouteViews[i].title,
                        onPressed: () {
                          if (_currentPageIndex == i) {
                            return;
                          }
                          if ((_currentPageIndex - i).abs() > 1) {
                            _controller.index = i + (i > _currentPageIndex ? -1 : 1);
                          }
                          _controller.animateTo(i);
                        },
                        isActive: _currentPageIndex == i,
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    Key key,
    @required this.items,
  }) : super(key: key);

  final List<_BottomItem> items;

  @override
  Widget build(BuildContext context) {
    final bottomItems = List<Widget>.from(items);
    final scaffold = context.findAncestorWidgetOfExactType<DashboardScaffold>();
    final fabSize = scaffold.fab?.preferredSize;
    if (fabSize != null && !fabSize.isEmpty) {
      bottomItems.insert(items.length ~/ 2, SizedBox.fromSize(size: fabSize));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -4),
            blurRadius: 8,
            color: Color(0xFF000000).withOpacity(.05),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: context.scale(8)).copyWith(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: bottomItems,
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    Key key,
    this.icon,
    this.title,
    this.onPressed,
    this.isActive = false,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.light_grey;
    return TouchableOpacity(
      minWidth: context.scale(44),
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: color),
          const ScaledBox.vertical(4),
          Text(title, style: context.theme.smallSemi.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _LoanFab extends StatelessWidget {
  const _LoanFab({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final preferredSize = context.findAncestorWidgetOfExactType<PreferredSize>()?.preferredSize;
    return ConstrainedBox(
      constraints: BoxConstraints.tight(preferredSize),
      child: Material(
        elevation: 6,
        shadowColor: Colors.black26,
        color: AppColors.primary,
        shape: CircleBorder(),
        child: InkWell(
          borderRadius: BorderRadius.circular(56),
          child: Image(image: AppImages.icon, fit: BoxFit.scaleDown),
          onTap: onPressed,
        ),
      ),
    );
  }
}

class _TabRouteView {
  _TabRouteView(this.title, this.icon, this.widget);

  final String title;
  final IconData icon;
  final Widget widget;
}
