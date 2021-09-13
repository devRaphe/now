import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget({
    Key key,
    @required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${message ?? AppStrings.errorMessage} \n ${AppStrings.retryMessage}",
      textAlign: TextAlign.center,
      style: context.theme.bodySemi,
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key, this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 2,
      child: message != null
          ? Text(message, style: context.theme.bodySemi, textAlign: TextAlign.center)
          : LoadingSpinner.circle(),
    );
  }
}

class SliverLoadingWidget extends StatelessWidget {
  const SliverLoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Material(
        child: Center(child: LoadingSpinner.circle()),
      ),
    );
  }
}

class SliverErrorWidget extends StatelessWidget {
  const SliverErrorWidget({
    Key key,
    @required this.message,
    @required this.onRetry,
  }) : super(key: key);

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message, textAlign: TextAlign.center),
            TouchableOpacity(
              child: Text("RETRY"),
              onPressed: onRetry,
            )
          ],
        ),
      ),
    );
  }
}
