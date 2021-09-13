import 'package:borome/extensions.dart';
import 'package:borome/mixins.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class ProfilePhotoPage extends StatefulWidget {
  @override
  _ProfilePhotoPageState createState() => _ProfilePhotoPageState();
}

class _ProfilePhotoPageState extends State<ProfilePhotoPage> with ProfileInfoSubmitActionMixin {
  final photoViewKey = GlobalKey<ProfilePhotoFormViewState>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: Text("Profile Image"), primary: true),
          SliverPadding(
            padding: const EdgeInsets.all(24).scale(context),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ProfilePhotoFormView(
                  key: photoViewKey,
                  onSaved: (file) => handleSubmit(file, photoViewKey),
                  buttonCaption: "Save",
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
