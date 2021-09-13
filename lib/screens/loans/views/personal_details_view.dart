import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/mixins.dart';
import 'package:borome/screens.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class PersonalDetailsView extends StatefulWidget {
  const PersonalDetailsView({Key key}) : super(key: key);

  @override
  _PersonalDetailsViewState createState() => _PersonalDetailsViewState();
}

class _PersonalDetailsViewState extends State<PersonalDetailsView> with PersonalInfoSubmitActionMixin {
  final request = PersonalInfoRequestData();

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ScaledBox.vertical(4),
          Text(
            "Personal Details",
            style: theme.display3.copyWith(height: 1.08, fontWeight: AppStyle.bold, color: AppColors.primary),
          ),
          const ScaledBox.vertical(32),
          UserModelStreamBuilder(
            orElse: (BuildContext context) => LoadingSpinner.circle(),
            builder: (BuildContext context, UserModel user) {
              return PersonalDetailsFormView(
                request: request,
                user: user,
                onSaved: (request) async {
                  if (await handleSubmit(request)) {
                    Navigator.of(context).pushNamed(context.loanRequestService.nextPage);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
