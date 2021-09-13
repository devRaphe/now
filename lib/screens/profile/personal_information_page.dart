import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/mixins.dart';
import 'package:borome/store.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class PersonalInformationPage extends StatefulWidget {
  @override
  _PersonalInformationPageState createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> with PersonalInfoSubmitActionMixin {
  PersonalInfoRequestData request;

  @override
  void initState() {
    super.initState();

    request = PersonalInfoRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: Text("Personal Information"), primary: true),
          SliverPadding(
            padding: const EdgeInsets.all(24).scale(context),
            sliver: UserModelStreamBuilder(
              builder: (context, user) => SliverList(
                delegate: SliverChildListDelegate([
                  PersonalDetailsFormView(
                    user: user,
                    request: request,
                    onSaved: handleSubmit,
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
