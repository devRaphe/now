import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/screens/home/sliver_dashboard_header.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<_Service> _services;

  @override
  void initState() {
    super.initState();

    _services = [
      _Service(
        label: "Withdraw to bank",
        icon: ImageIcon(AppImageIcons.bank),
        color: Color(0xFF1896A5),
        onPressed: _showComingSoon,
      ),
      _Service(
        label: "Purchase Airtime",
        icon: ImageIcon(AppImageIcons.airtime),
        color: Color(0xFF7A8AA3),
        onPressed: _showComingSoon,
      ),
      _Service(
        label: "Data & Internet",
        icon: ImageIcon(AppImageIcons.internet),
        color: Color(0xFF537FD6),
        onPressed: _showComingSoon,
      ),
      _Service(
        label: "Pay TV Subscription",
        icon: ImageIcon(AppImageIcons.tv),
        color: Color(0xFFA0616D),
        onPressed: _showComingSoon,
      ),
      _Service(
        label: "Pay for Electricity",
        icon: ImageIcon(AppImageIcons.electricity),
        color: Color(0xFFF95656),
        onPressed: _showComingSoon,
      ),
    ];
  }

  void _showComingSoon() {
    AppSnackBar.of(context).info('This feature is coming soon');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Pair2<SubState<UserModel>, SubState<DashboardData>, SubState<ProfileStatusModel>>>(
      initialData: Pair2(
        context.store.state.value.user,
        context.store.state.value.dashboard,
        context.store.state.value.profileStatus,
      ),
      stream: context.store.state.map((state) => Pair2(state.user, state.dashboard, state.profileStatus)),
      builder: (context, snapshot) {
        final dashboardState = snapshot.data.second;
        final user = snapshot.data.first.value;

        return CustomScrollView(
          slivers: <Widget>[
            SliverDashboardHeader(
              dashboardState: dashboardState,
              profileStatusState: snapshot.data.third,
              profileImageSrc: user != null ? (user.hasImage ? user.image : null) : null,
              creditScore: user != null ? user.creditScore : 0.0,
              phone: user != null ? user.phone : null,
              email: user != null ? user.email : null,
              accountNumber: user?.virtualAccountNumber ?? "n/a",
              bankName: user?.virtualBankName ?? "n/a",
            ),
            SliverToBoxAdapter(child: ScaledBox.vertical(24)),
            if (snapshot.data.second.hasData && (snapshot.data.second.value.lastLoan?.canRepayLoan ?? false)) ...[
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: context.scale(52)),
                sliver: SliverToBoxAdapter(child: _OverdueCard()),
              ),
              SliverToBoxAdapter(child: ScaledBox.vertical(30)),
            ],
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: context.scale(28)),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: .65,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final service = _services[index];
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: service.onPressed,
                              borderRadius: BorderRadius.circular(20),
                              highlightColor: service.color.withOpacity(.2),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: service.color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(
                                    width: constraints.maxWidth,
                                    height: constraints.maxWidth,
                                  ),
                                  child: Center(
                                    child: IconTheme(
                                      data: IconThemeData(color: Colors.white, size: 28),
                                      child: service.icon,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ScaledBox.vertical(8),
                            Text(
                              service.label,
                              style: context.theme.smallSemi,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        );
                      },
                    );
                  },
                  childCount: _services.length,
                ),
              ),
            ),
            SliverToBoxAdapter(child: ScaledBox.vertical(156)),
          ],
        );
      },
    );
  }
}

class _OverdueCard extends StatelessWidget {
  const _OverdueCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.scaleY(87),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFFCF4FB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'YOUR LOAN IS OVERDUE',
              style: context.theme.subhead2.copyWith(
                color: AppColors.danger,
                fontWeight: AppStyle.bold,
                height: 1.24,
              ),
            ),
            ScaledBox.vertical(6),
            Text(
              'We strongly advice that you pay immediately',
              style: context.theme.subhead2.copyWith(
                color: AppColors.dark,
                height: 1.24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Service {
  const _Service({
    @required this.icon,
    @required this.color,
    @required this.label,
    @required this.onPressed,
  });

  final Widget icon;
  final Color color;
  final String label;
  final VoidCallback onPressed;
}
