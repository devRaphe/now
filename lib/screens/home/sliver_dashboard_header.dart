import 'dart:math' as math;

import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:intl/intl.dart';

class HeaderData {
  HeaderData({this.lastLoan, this.maxAmount});

  bool get isValid => maxAmount != null;

  bool get hasPendingLoan => lastLoan?.canRepayLoan ?? false;

  final LoanModel lastLoan;
  final double maxAmount;
}

class SliverDashboardHeader extends StatelessWidget {
  const SliverDashboardHeader({
    Key key,
    @required this.dashboardState,
    @required this.profileStatusState,
    @required this.creditScore,
    @required this.email,
    @required this.phone,
    @required this.accountNumber,
    @required this.bankName,
    this.profileImageSrc,
  }) : super(key: key);

  final SubState<DashboardData> dashboardState;
  final SubState<ProfileStatusModel> profileStatusState;

  final String profileImageSrc;
  final double creditScore;
  final String email;
  final String phone;
  final String accountNumber;
  final String bankName;

  @override
  Widget build(BuildContext context) {
    final data = dashboardState.map(
      (data) => HeaderData(lastLoan: data.lastLoan, maxAmount: data.maxRate),
      orElse: () => HeaderData(),
    );

    final paddingTop = MediaQuery.of(context).padding.top;
    final minExtent = paddingTop;
    final maxExtent = (data.isValid ? context.scaleY(data.hasPendingLoan ? 304 : 184) : kToolbarHeight) + minExtent;

    return SliverPersistentHeader(
      pinned: true,
      delegate: AppSliverPersistentHeaderDelegate(
        maxExtent: maxExtent,
        minExtent: minExtent,
        builder: (BuildContext context, double shrinkOffset, _a, _b) {
          final flexibleMaxExtent = maxExtent;
          final currentExtent = math.max(paddingTop, flexibleMaxExtent - shrinkOffset);
          final offset = interpolate(inputMin: paddingTop, inputMax: flexibleMaxExtent)(currentExtent);

          return AppStatusBar(
            brightness: offset == 0 ? Brightness.dark : Brightness.light,
            child: Material(
              color: Color.lerp(Colors.white, AppColors.primary, offset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    child: FlexibleSpaceBar.createSettings(
                      maxExtent: flexibleMaxExtent,
                      minExtent: paddingTop,
                      toolbarOpacity: 1,
                      currentExtent: currentExtent,
                      child: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image(image: AppImages.header, fit: BoxFit.cover),
                            _Header(
                              data: data,
                              profileImageSrc: profileImageSrc,
                              creditScore: creditScore,
                              phone: phone,
                              email: email,
                              onApplyForLoan: () => applyForLoan(context, profileStatus: profileStatusState.value),
                              onRepayLoan: () => repayLoan(
                                context,
                                loan: data.lastLoan,
                                accountNumber: accountNumber,
                                bankName: bankName,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (dashboardState.loading) LoadingSpinner.linear(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key key,
    this.data,
    this.profileImageSrc,
    @required this.creditScore,
    @required this.onApplyForLoan,
    @required this.onRepayLoan,
    @required this.email,
    @required this.phone,
  }) : super(key: key);

  final HeaderData data;
  final String profileImageSrc;
  final double creditScore;
  final String email;
  final String phone;
  final VoidCallback onApplyForLoan;
  final VoidCallback onRepayLoan;

  bool get hasPendingLoan => data?.lastLoan?.canRepayLoan ?? false;

  bool get canApplyForLoan => data?.lastLoan?.canApplyForLoan ?? true;

  @override
  Widget build(BuildContext context) {
    final fadedLabelStyle = AppFont.bold(14, Colors.white60).copyWith(height: 1.24);
    final boldedContentStyle = AppFont.bold(16, Colors.white).copyWith(height: 1.08);
    final iconSize = IconTheme.of(context).size;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30).scale(context),
        child: Column(
          children: <Widget>[
            const ScaledBox.vertical(4),
            SizedBox.fromSize(
              size: Size.fromHeight(kToolbarHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Your credit score", style: fadedLabelStyle),
                        Text(
                          "$creditScore",
                          style: AppFont.bold(32, Colors.white).copyWith(height: 1.08),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    iconSize: iconSize,
                    icon: Icon(AppIcons.chat, color: Colors.white),
                    onPressed: () => showSupportDialog(context, email: email, phone: phone),
                  ),
                  const ScaledBox.horizontal(2),
                  NoticeButton(
                    color: Colors.white,
                    onPressed: () => Registry.di.coordinator.notification.toList(),
                  ),
                  const ScaledBox.horizontal(8),
                  TouchableOpacity(
                    child: profileImageSrc != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(iconSize * 2),
                            child: SizedBox.fromSize(
                              size: Size.square(iconSize * 2),
                              child: CachedImage(url: profileImageSrc),
                            ),
                          )
                        : CircleAvatar(radius: iconSize, backgroundColor: Colors.white),
                    onPressed: () {
                      context.findAncestorStateOfType<DashboardPageState>().navigateToIndex(4);
                    },
                  ),
                ],
              ),
            ),
            if (data.isValid) ...[
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Divider(color: Colors.white, height: 0),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                hasPendingLoan ? "Amount Owed" : "Access up to",
                                style: fadedLabelStyle,
                              ),
                              Text(
                                Money.fromString(
                                  hasPendingLoan ? data.lastLoan.amount : data.maxAmount.toString(),
                                ).formatted,
                                style: AppFont.bold(32, Colors.white).copyWith(height: 1.08),
                              ),
                            ],
                          ),
                        ),
                        if (hasPendingLoan || canApplyForLoan)
                          FilledButton(
                            height: 30,
                            backgroundColor: Colors.white,
                            onPressed: hasPendingLoan ? onRepayLoan : onApplyForLoan,
                            shape: StadiumBorder(),
                            child: Text(
                              hasPendingLoan ? "Repay Now" : "Apply Now",
                              style: ThemeProvider.of(context).smallButton,
                            ),
                          ),
                      ],
                    ),
                    const ScaledBox.vertical(16),
                    if (hasPendingLoan)
                      Container(
                        constraints: BoxConstraints(minHeight: context.scaleY(66)),
                        padding: EdgeInsets.all(20).scale(context),
                        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: context.scaleY(2)),
                              constraints: BoxConstraints.tight(Size.square(14)),
                              decoration: BoxDecoration(
                                color: data.lastLoan.isOverdue
                                    ? AppColors.danger
                                    : (data.lastLoan.isDue ? AppColors.primary : AppColors.success),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                            const ScaledBox.horizontal(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Next Payment", style: fadedLabelStyle),
                                  Text(Money.fromString(data.lastLoan.nextPayment).formatted,
                                      style: boldedContentStyle),
                                ],
                              ),
                            ),
                            const ScaledBox.horizontal(8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    data.lastLoan.isOverdue
                                        ? "Overdue"
                                        : (data.lastLoan.isDue ? "Due Today" : "Due on"),
                                    style: fadedLabelStyle,
                                  ),
                                  Text(DateFormat("d MMM y").format(data.lastLoan.dateDue), style: boldedContentStyle),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
