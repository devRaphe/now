import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/mixins.dart';
import 'package:borome/store.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class NextOfKinPage extends StatefulWidget {
  @override
  _NextOfKinPageState createState() => _NextOfKinPageState();
}

class _NextOfKinPageState extends State<NextOfKinPage> with NextOfKinInfoSubmitActionMixin {
  NextOfKinRequestData request;

  @override
  void initState() {
    super.initState();

    request = NextOfKinRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: Text("Next Of Kin"), primary: true),
          SliverPadding(
            padding: const EdgeInsets.all(24).scale(context),
            sliver: UserModelStreamBuilder(
              builder: (context, user) => SliverList(
                delegate: SliverChildListDelegate([
                  NextOfKinFormView(
                    request: request,
                    onSaved: handleSubmit,
                    user: user,
                    buttonCaption: "Save",
                  )
                ]),
              ),
              orElse: (context) => SliverLoadingWidget(),
              error: (context, message) => SliverErrorWidget(
                message: message,
                onRetry: () => context.dispatchAction(UserActions.fetch()),
              ),
            ),
          )
        ],
      ),
    );
  }
}
