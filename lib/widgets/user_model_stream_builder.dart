import 'package:borome/domain.dart';
import 'package:borome/store.dart';
import 'package:flutter/material.dart';

class UserModelStreamBuilder extends StatelessWidget {
  const UserModelStreamBuilder({
    Key key,
    @required this.builder,
    @required this.orElse,
    this.loading,
    this.error,
  })  : assert(builder != null),
        assert(orElse != null),
        super(key: key);

  final Widget Function(BuildContext, UserModel) builder;
  final WidgetBuilder orElse;
  final WidgetBuilder loading;
  final Widget Function(BuildContext, String) error;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SubState<UserModel>>(
      initialData: context.store.state.value.user,
      stream: context.store.state.map((state) => state.user),
      builder: (context, snapshot) {
        if (snapshot.data.hasError) {
          return error != null ? error(context, snapshot.data.error) : SizedBox();
        }
        if (snapshot.data.loading) {
          return loading != null ? loading(context) : SizedBox();
        }
        if (snapshot.data.hasData) {
          return builder(context, snapshot.data.value);
        }
        return orElse(context);
      },
    );
  }
}
