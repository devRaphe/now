import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/mixins.dart';
import 'package:borome/store.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class ContactInformationPage extends StatefulWidget {
  @override
  _ContactInformationPageState createState() => _ContactInformationPageState();
}

class _ContactInformationPageState extends State<ContactInformationPage> with ContactInfoSubmitActionMixin {
  ContactInfoRequestData request;

  @override
  void initState() {
    super.initState();

    request = ContactInfoRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: Text("Contact Information"), primary: true),
          SliverPadding(
            padding: const EdgeInsets.all(24).scale(context),
            sliver: UserModelStreamBuilder(
              builder: (context, user) => SliverList(
                delegate: SliverChildListDelegate([
                  ContactInfoFormView(
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
