import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens/profile/widgets/bank_item_card.dart';
import 'package:borome/screens/profile/widgets/create_bank_dialog.dart';
import 'package:borome/screens/profile/widgets/title_child_row.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:intl/intl.dart';

class MyBankPage extends StatefulWidget {
  const MyBankPage({Key key}) : super(key: key);

  @override
  _MyBankPageState createState() => _MyBankPageState();
}

class _MyBankPageState extends State<MyBankPage> {
  PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(viewportFraction: .85);
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.store.state;
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: Text("My Bank"), primary: true),
          StreamBuilder<Pair<SubState<UserModel>, SubState<SetUpData>>>(
            initialData: Pair(state.value.user, state.value.setup),
            stream: state.map((state) => Pair(state.user, state.setup)),
            builder: (context, snapshot) {
              final data = snapshot.data.first.value;

              if (snapshot.data.first.loading || snapshot.data.second.loading || data == null) {
                return SliverLoadingWidget();
              }

              if (snapshot.data.first.hasError) {
                return SliverErrorWidget(
                  message: snapshot.data.first.error,
                  onRetry: () => context.dispatchAction(UserActions.fetch()),
                );
              }

              final accounts = data.accounts?.toList() ?? <AccountModel>[];
              final setUpData = snapshot.data.second.value;

              return SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const ScaledBox.vertical(8),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: context.scaleY(183)),
                      child: PageView.builder(
                        controller: pageController,
                        itemBuilder: (context, index) {
                          final account = accounts[index];
                          return BankItemCard(
                            item: account,
                            imageUrl: setUpData.bankImages.containsKey(account.accountBank)
                                ? setUpData.bankImages[account.accountBank]
                                : null,
                          );
                        },
                        itemCount: accounts.length,
                      ),
                    ),
                    const ScaledBox.vertical(28),
                    if (accounts.isEmpty) Center(child: Text("No accounts to see yet")),
                    if (accounts.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: context.scale(36)),
                        child: AnimatedBuilder(
                          animation: pageController,
                          builder: (context, child) {
                            final nextIndex = pageController.page?.round() ?? 0;
                            final item = accounts[nextIndex];
                            return AnimatedSwitcher(
                              duration: Duration(milliseconds: 350),
                              child: Column(
                                key: ValueKey<int>(nextIndex),
                                children: <Widget>[
                                  TitleChildRow(title: "Bank Name", child: Text(item.accountBank)),
                                  const ScaledBox.vertical(28),
                                  TitleChildRow(title: "Account Number", child: Text(item.accountNumber)),
                                  const ScaledBox.vertical(28),
                                  TitleChildRow(title: "Account Name", child: Text(item.accountName)),
                                  const ScaledBox.vertical(28),
                                  TitleChildRow(
                                    title: "Added on",
                                    child: Text(DateFormat.yMEd().format(item.createdAt).toString()),
                                  ),
                                  const ScaledBox.vertical(16),
                                  TitleChildRow(
                                    title: "Make Default",
                                    child: Switch.adaptive(
                                      value: item.isDefaultBool,
                                      onChanged: (state) => onMakeDefault(item, state),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    const ScaledBox.vertical(28),
                    TouchableOpacity(
                      child: Text(
                        "Add Account",
                        style: ThemeProvider.of(context).subhead1Semi.copyWith(color: AppColors.primary, height: 1.24),
                      ),
                      onPressed: () async {
                        await showDialog<void>(
                          context: context,
                          builder: (context) => CreateBankDialog(),
                        );
                      },
                    ),
                    const ScaledBox.vertical(32),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void onMakeDefault(AccountModel account, bool state) async {
    if (state == false || state == null) {
      return;
    }
    if (state == true) {
      AppSnackBar.of(context).loading();
      try {
        final accounts = await Registry.di.repository.auth.setDefaultAccount(account.id);
        if (!mounted) {
          return;
        }

        context.dispatchAction(UserActions.updateAccounts(accounts));
        AppSnackBar.of(context).success("Success");
      } catch (e, st) {
        AppLog.e(e, st);
        AppSnackBar.of(context).error(errorToString(e));
      }
    }
  }
}
