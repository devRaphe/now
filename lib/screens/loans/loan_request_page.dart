import 'package:borome/extensions.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loan_request_routes.dart';
import 'loan_request_service.dart';

class LoanRequestPage extends StatefulWidget {
  const LoanRequestPage({Key key, @required this.routes}) : super(key: key);

  final List<SimpleRoute> routes;

  @override
  _LoanRequestPageState createState() => _LoanRequestPageState();
}

class _LoanRequestPageState extends State<LoanRequestPage> {
  GlobalKey<NavigatorState> _navigationKey;
  LoanRequestService _loanRequestService;

  @override
  void initState() {
    super.initState();

    _loanRequestService = LoanRequestService(routes: widget.routes);
    _navigationKey = GlobalKey<NavigatorState>();
  }

  @override
  void dispose() {
    _loanRequestService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 32).scale(context),
      appBar: ClearAppBar(
        leading: ValueListenableBuilder<int>(
          valueListenable: _loanRequestService,
          builder: (context, currentIndex, child) {
            return AppBackButton(
              onPressed: () {
                final navigator = _navigationKey.currentState;
                if (navigator == null) {
                  return;
                }
                if (navigator.canPop()) {
                  navigator.pop();
                  return;
                }
                Navigator.of(context).pop();
              },
            );
          },
        ),
        child: ValueListenableBuilder<int>(
          valueListenable: _loanRequestService,
          builder: (context, currentIndex, child) {
            return Text(
              'Step ${currentIndex + 1} of ${_loanRequestService.length}',
              style: context.theme.display1.bold.dark,
            );
          },
        ),
        trailing: ValueListenableBuilder<int>(
          valueListenable: _loanRequestService,
          builder: (context, currentIndex, child) {
            if (currentIndex == 0) {
              return SizedBox();
            }

            return AppCloseButton(
              onPressed: () async {
                final choice = await showConfirmDialog(context, 'Quit?');
                if (choice != true) {
                  return;
                }

                _loanRequestService.reset();
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      body: KeyboardDismissible(
        child: ChangeNotifierProvider<LoanRequestService>.value(
          value: _loanRequestService,
          child: Navigator(
            key: _navigationKey,
            observers: [_loanRequestService.observer],
            initialRoute: _loanRequestService.initialRoute,
            onGenerateRoute: LoanRequestRoutes.onGenerateRoute,
          ),
        ),
      ),
    );
  }
}

extension LoanRequestServiceContext on BuildContext {
  LoanRequestService get loanRequestService => Provider.of<LoanRequestService>(this, listen: false);
}
