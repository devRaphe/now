import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/mixins.dart';
import 'package:borome/screens.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class ContactInfoView extends StatefulWidget {
  const ContactInfoView({Key key}) : super(key: key);

  @override
  _ContactInfoViewState createState() => _ContactInfoViewState();
}

class _ContactInfoViewState extends State<ContactInfoView> with ContactInfoSubmitActionMixin {
  final request = ContactInfoRequestData();

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ScaledBox.vertical(4),
          Text(
            "Contact Information",
            style: theme.display3.copyWith(height: 1.08, fontWeight: AppStyle.bold, color: AppColors.primary),
          ),
          const ScaledBox.vertical(32),
          UserModelStreamBuilder(
            orElse: (BuildContext context) => LoadingSpinner.circle(),
            builder: (BuildContext context, UserModel user) {
              return ContactInfoFormView(
                request: request,
                user: user,
                onSaved: (request) async {
                  if (await handleSubmit(request)) {
                    Navigator.of(context).pushNamed(context.loanRequestService.nextPage);
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}
