import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/mixins.dart';
import 'package:borome/store.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class WorkDetailsPage extends StatefulWidget {
  @override
  _WorkDetailsPageState createState() => _WorkDetailsPageState();
}

class _WorkDetailsPageState extends State<WorkDetailsPage> with WorkInfoSubmitActionMixin {
  WorkDetailsRequestData request;

  @override
  void initState() {
    super.initState();

    request = WorkDetailsRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: Text("Work Details"), primary: true),
          SliverPadding(
            padding: const EdgeInsets.all(24).scale(context),
            sliver: UserModelStreamBuilder(
              builder: (context, user) => SliverList(
                delegate: SliverChildListDelegate([
                  WorkDetailsFormView(
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
