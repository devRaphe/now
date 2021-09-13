import 'package:borome/constants.dart';
import 'package:borome/extensions.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens/signup/signup_routes.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'signup_request_data_notifier.dart';
import 'signup_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key, this.currentPage, this.request}) : super(key: key);

  final String currentPage;
  final SignupRequestDataNotifier request;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<NavigatorState> _navigationKey;
  SignupService _signupService;

  @override
  void initState() {
    super.initState();

    _signupService = widget.currentPage != null ? SignupService.fromRoute(widget.currentPage) : SignupService();
    _navigationKey = GlobalKey<NavigatorState>();
  }

  @override
  void dispose() {
    _signupService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 32).scale(context),
      appBar: ClearAppBar(
        leading: ValueListenableBuilder<int>(
          valueListenable: _signupService,
          builder: (_a, currentIndex, child) {
            if (_signupService.currentIndex > 0 && _signupService.canGoBack) {
              return AppBackButton(
                onPressed: () {
                  _navigationKey.currentState?.pushNamed(_signupService.previousPage);
                },
              );
            }

            return child;
          },
          child: AppCloseButton(
            onPressed: () async {
              final choice = await showConfirmDialog(context, AppStrings.quitRegistrationMessage);
              if (choice != true) {
                return;
              }

              _signupService.reset();
              final navigator = Navigator.of(context);
              if (navigator.canPop()) {
                return navigator.pop();
              }
              Registry.di.coordinator.shared.toStart(pristine: false, clearHistory: true);
            },
          ),
        ),
        child: ValueListenableBuilder<int>(
          valueListenable: _signupService,
          builder: (context, currentIndex, child) {
            return Text(
              'Step ${currentIndex + 1} of ${_signupService.length}',
              style: context.theme.display1.bold.dark,
            );
          },
        ),
      ),
      body: KeyboardDismissible(
        child: ChangeNotifierProvider<SignupService>.value(
          value: _signupService,
          child: Navigator(
            key: _navigationKey,
            observers: [_signupService.observer],
            initialRoute: _signupService.initialRoute,
            onGenerateRoute: SignupRoutes.onGenerateRoute,
          ),
        ),
      ),
    );
  }
}

extension SignupServiceContext on BuildContext {
  SignupService get signupService => Provider.of<SignupService>(this, listen: false);
}
