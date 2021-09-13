import 'package:borome/constants.dart';
import 'package:borome/extensions.dart';
import 'package:borome/mixins.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class WorkIdPage extends StatefulWidget {
  @override
  _WorkIdPageState createState() => _WorkIdPageState();
}

class _WorkIdPageState extends State<WorkIdPage> with WorkIdSubmitActionMixin {
  final photoViewKey = GlobalKey<ProfilePhotoFormViewState>();

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return AppScaffold(
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: Text("Upload Work ID"), primary: true),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 28).scale(context),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  "Please upload a clear photo of your work or business ID card",
                  style: theme.subhead3.copyWith(height: 1.24, fontWeight: AppStyle.medium, letterSpacing: .25),
                ),
                const ScaledBox.vertical(32),
                ProfilePhotoFormView(
                  key: photoViewKey,
                  onSaved: (file) => handleSubmit(file, photoViewKey),
                  buttonCaption: "Save",
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
