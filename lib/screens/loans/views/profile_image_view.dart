import 'package:borome/constants.dart';
import 'package:borome/mixins.dart';
import 'package:borome/screens.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class ProfileImageView extends StatefulWidget {
  @override
  _ProfileImageViewState createState() => _ProfileImageViewState();
}

class _ProfileImageViewState extends State<ProfileImageView> with ProfileInfoSubmitActionMixin {
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
            "Upload Image",
            style: theme.display3.copyWith(height: 1.08, fontWeight: AppStyle.bold, color: AppColors.primary),
          ),
          const ScaledBox.vertical(28),
          Text(
            "Please take a clear photo of yourself. Ensure your face shows clearly and is properly lit",
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
