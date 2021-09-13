import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/screens/history/sorting_bar.dart';
import 'package:borome/screens/history/transaction_item.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Pair<SubState<UserModel>, SubState<DashboardData>>>(
      initialData: Pair(context.store.state.value.user, context.store.state.value.dashboard),
      stream: context.store.state.map((state) => Pair(state.user, state.dashboard)),
      builder: (context, snapshot) {
        final state = snapshot.data.second;
        final dashboard = state.value;

        return Material(
          color: AppColors.dark.shade50,
          child: CustomScrollView(
            slivers: <Widget>[
              CustomSliverAppBar(title: Text("History"), primary: true, automaticallyImplyLeading: false),
              SortingBar(
                state: state,
                onSort: (value) => context.dispatchAction(DashboardActions.fetch(value)),
              ),
              if (state.loading || state.empty)
                SliverToBoxAdapter(
                  child: LoadingWidget(message: AppStrings.loadingMessage),
                ),
              if (state.hasError)
                SliverToBoxAdapter(
                  child: Center(
                    child: TouchableOpacity(
                      child: ErrorTextWidget(message: state.error),
                      onPressed: () => context.dispatchAction(DashboardActions.fetch()),
                    ),
                  ),
                ),
              if (state.hasData && dashboard.loans.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "No transactions to see yet",
                      textAlign: TextAlign.center,
                      style: context.theme.bodySemi,
                    ),
                  ),
                )
              else if (state.hasData)
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(24, 12, 24, 108).scale(context),
                  sliver: SliverList(
                    delegate: SliverSeparatorBuilderDelegate(
                      builder: (_, index) => TransactionItem(data: dashboard.loans[index]),
                      childCount: dashboard.loans.length,
                      separatorBuilder: (_a, _b) => const ScaledBox.vertical(12),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
