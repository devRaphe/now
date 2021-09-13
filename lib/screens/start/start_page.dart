import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({
    Key key,
    @required this.pristine,
  }) : super(key: key);

  final bool pristine;

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Registry.di.localAuth.hasCredentials() && widget.pristine) {
        onLocalAuth();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppStatusBar(
      brightness: Brightness.dark,
      child: AppScaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const ScaledBox.vertical(40 + kToolbarHeight),
            const Align(alignment: Alignment.centerLeft, child: AppIcon()),
            const ScaledBox.vertical(58),
            Text(
              "Let’s help you\nget you the\nmoney you need",
              style: context.theme.display6.primary.copyWith(
                height: 1.08,
                fontWeight: AppStyle.thin,
              ),
            ),
            const ScaledBox.vertical(35),
            Text(
              "ON TIME.\nEVERY TIME.",
              style: context.theme.subhead3Semi.copyWith(
                height: 1.24,
                letterSpacing: 1.5,
                color: AppColors.dark.shade400,
              ),
            ),
            const ScaledBox.vertical(90),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton(
                    backgroundColor: AppColors.dark,
                    onPressed: () => Registry.di.coordinator.auth.toLogin(),
                    child: Text("Login"),
                  ),
                ),
                const ScaledBox.horizontal(10),
                FilledButton(
                  backgroundColor: AppColors.dark,
                  minWidth: kButtonHeight,
                  onPressed: onLocalAuth,
                  child: Icon(AppIcons.fingerprint, color: Colors.white, size: 32),
                ),
              ],
            ),
            const ScaledBox.vertical(10),
            FilledButton(
              onPressed: () => Registry.di.coordinator.auth.toSignup(),
              child: Text("Register"),
            ),
            const ScaledBox.vertical(24),
            GestureDetector(
              child: Text("Need Help?", style: context.theme.bodyMedium.primary, textAlign: TextAlign.center),
              onTap: () => showSupportDialog(context, email: "", phone: ""),
            ),
          ],
        ),
      ),
    );
  }

  void onLocalAuth() async {
    final auth = Registry.di.localAuth;
    if (!await auth.isAvailable()) {
      AppSnackBar.of(context).info("You do not have biometrics enabled on this device");
      return;
    }

    if (!await auth.authenticate()) {
      AppSnackBar.of(context).info("An error occurred while verifying your identity. Try again");
      return;
    }

    final creds = await auth.fetchCredentials();
    if (creds == null) {
      AppSnackBar.of(context).info("You need to login at least once");
      return;
    }

    AppSnackBar.of(context).loading();

    final loginRequestData = LoginRequestData(
      phone: creds.first,
      password: creds.second,
      deviceId: Registry.di.appDeviceInfo.deviceId,
    );
    await loginAction(context: context, request: loginRequestData);
  }
}
