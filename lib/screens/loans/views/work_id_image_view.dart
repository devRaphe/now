import 'package:borome/constants.dart';
import 'package:borome/mixins.dart';
import 'package:borome/screens.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class WorkIdImageView extends StatefulWidget {
  @override
  _WorkIdImageViewState createState() => _WorkIdImageViewState();
}

class _WorkIdImageViewState extends State<WorkIdImageView> with WorkIdSubmitActionMixin {
  final photoViewKey = GlobalKey<ProfilePhotoFormViewState>();

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ScaledBox.vertical(4),
          Text(
            "Upload Work ID",
            style: theme.display3.copyWith(height: 1.08, fontWeight: AppStyle.bold, color: AppColors.primary),
          ),
          const ScaledBox.vertical(28),
          Text(
            "Please upload a clear photo of your work or business ID card",
            style: theme.subhead3.copyWith(height: 1.24, fontWeight: AppStyle.medium, letterSpacing: .25),
          ),
          const ScaledBox.vertical(32),
          ProfilePhotoFormView(
            key: photoViewKey,
            onSaved: (file) async {
              if (await handleSubmit(file, photoViewKey)) {
                Navigator.of(context).pushNamed(context.loanRequestService.nextPage);
              }
            },
          ),
        ],
      ),
    );
  }
}
