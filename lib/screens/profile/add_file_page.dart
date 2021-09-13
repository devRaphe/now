import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens/profile/widgets/file_item_group.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class AddFilePage extends StatefulWidget {
  const AddFilePage({
    Key key,
    @required this.isRequested,
  }) : super(key: key);

  final bool isRequested;

  @override
  _AddFilePageState createState() => _AddFilePageState();
}

class _AddFilePageState extends State<AddFilePage> {
  TextEditingController inputController;

  @override
  void initState() {
    super.initState();

    inputController = TextEditingController();
  }

  @override
  void dispose() {
    inputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: KeyboardDismissible(
        child: StreamBuilder<SubState<UserModel>>(
          initialData: context.store.state.value.user,
          stream: context.store.state.map((state) => state.user),
          builder: (context, snapshot) {
            final data = snapshot.data;
            return CustomScrollView(
              slivers: [
                CustomSliverAppBar(title: Text("Add Files"), primary: true, isLoading: data.loading),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18).scale(context),
                      child: widget.isRequested
                          ? _FileGroupField(inputController: inputController)
                          : TextField(
                              controller: inputController,
                              decoration: const InputDecoration(hintText: "e.g Work documents"),
                            ),
                    ),
                    if (data.hasError) ...[
                      const ScaledBox.vertical(8),
                      TouchableOpacity(
                        child: ErrorTextWidget(message: data.error),
                        onPressed: () => context.dispatchAction(UserActions.fetch()),
                      ),
                    ],
                    const ScaledBox.vertical(8),
                    if (data.hasData)
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: inputController,
                        builder: (context, value, child) {
                          final name = value.text.trim();
                          return name == null || name.isEmpty || name.length < 3
                              ? Center(heightFactor: 12, child: Text("No files to see yet"))
                              : FileItemGroup(name: name, files: data.value.filesGrouped[name] ?? []);
                        },
                      ),
                    const ScaledBox.vertical(32),
                  ]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FileGroupField extends StatefulWidget {
  const _FileGroupField({
    Key key,
    @required this.inputController,
  }) : super(key: key);

  final TextEditingController inputController;

  @override
  _FileGroupFieldState createState() => _FileGroupFieldState();
}

class _FileGroupFieldState extends State<_FileGroupField> {
  StreamableDataModel<List<String>> requestedFilesBloc;
  Stream<DataModel<List<String>>> requestedFilesStream;

  @override
  void initState() {
    super.initState();

    requestedFilesBloc = StreamableDataModel(
      () => Registry.di.repository.auth.fetchRequestedFiles(),
      errorMapper: errorToString,
    );

    requestedFilesStream = requestedFilesBloc.stream;
  }

  @override
  void dispose() {
    requestedFilesBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DataModel<List<String>>>(
      stream: requestedFilesStream,
      initialData: requestedFilesBloc.value,
      builder: (context, snapshot) => Row(
        children: <Widget>[
          Expanded(
            child: DropDownFormField(
              items: snapshot.data.maybeWhen((data) => data, orElse: () => []),
              decoration: const InputDecoration(hintText: "Group"),
              onChanged: (value) => widget.inputController.text = value,
            ),
          ),
          snapshot.data.maybeWhen(
            (data) => SizedBox.shrink(),
            error: (_) => Center(
              child: IconButton(
                iconSize: IconTheme.of(context).size,
                icon: Icon(AppIcons.rotate),
                onPressed: requestedFilesBloc.refresh,
              ),
            ),
            orElse: () => SizedBox.fromSize(
              size: Size.square(48),
              child: Center(child: LoadingSpinner.circle(size: 24)),
            ),
          ),
        ],
      ),
    );
  }
}
