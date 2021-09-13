import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/screens/history/sort_type_drop_down.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class SortingBar extends StatelessWidget {
  const SortingBar({
    Key key,
    @required this.state,
    @required this.onSort,
  }) : super(key: key);

  final SubState<DashboardData> state;
  final ValueChanged<SortType> onSort;

  @override
  Widget build(BuildContext context) {
    final minHeight = context.scaleY(48);
    final duration = state.value?.duration ?? SortType.month;

    return SliverPersistentHeader(
      pinned: true,
      delegate: AppSliverPersistentHeaderDelegate(
        height: minHeight,
        builder: (BuildContext context, _a, overlapsContent, _b) {
          final boxShadowAnimation = overlapsContent ? 1.0 : 0.0;

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: overlapsContent ? Colors.white : AppColors.dark.shade50,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, boxShadowAnimation * 2),
                      blurRadius: boxShadowAnimation * 4,
                      color: Color.lerp(Colors.transparent, Colors.black12, boxShadowAnimation),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24).scale(context),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("TRANSACTIONS", style: AppFont.bold(14, AppColors.dark)),
                    ),
                    const ScaledBox.horizontal(8),
                    SortTypeDropdown(initialValue: duration, onChanged: onSort),
                  ],
                ),
              ),
              if (state.loading) Positioned.fill(bottom: null, child: LoadingSpinner.linear()),
            ],
          );
        },
      ),
    );
  }
}
