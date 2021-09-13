import 'dart:io';

import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens/loans/upload_progress_bar.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class UploadingPage extends StatefulWidget {
  const UploadingPage({Key key}) : super(key: key);

  @override
  _UploadingPageState createState() => _UploadingPageState();
}

class _UploadingPageState extends State<UploadingPage> {
  @override
  void initState() {
    super.initState();

    final registry = Registry.di;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      registry.permissions.request().then((status) async {
        if (!status.isOk) {
          await AppSnackBar.of(context).info(status.message);
          registry.coordinator.shared.pop();
          return;
        }

        try {
          final request = UploadRequestData(
            contacts: await registry.contacts.fetchContacts(),
            location: await registry.location.fetchLocation(),
            os: Platform.operatingSystem,
          );
          final rate = await registry.repository.auth.saveUploadData(request);
          registry.coordinator.loan.toOffer(rate: rate);
        } catch (e, st) {
          AppLog.e(e, st);
          await AppSnackBar.of(context).error(errorToString(e));
          registry.coordinator.shared.pop();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return Scaffold(
      appBar: ClearAppBar(
        automaticallyImplyLeading: false,
        trailing: AppBarButton(title: "CANCEL", onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Image(image: AppImages.loanProcess, fit: BoxFit.contain),
          ),
          Expanded(
            flex: 7,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: context.scale(257)),
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Text(
                      "We’re determining your loan amount",
                      style: theme.display6.copyWith(height: 1.08, fontWeight: AppStyle.thin, color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Center(
                      child: SizedBox(
                        width: context.scale(257),
                        child: Text(
                          "Please be patient. Our bots are working hard to calculate how much loan you are eligible to.",
                          style: theme.title.copyWith(height: 1.27, color: AppColors.dark),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Spacer(),
                    UploadProgressBar(),
                    const Spacer(),
                    Center(
                      child: SizedBox(
                        width: context.scale(257),
                        child: Text(
                          "Please ensure that your internet connection is good enough as this process might take up to 5 minutes",
                          style: theme.body1.copyWith(height: 1.27),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
