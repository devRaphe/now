import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/screens/profile/widgets/file_item_group.dart';
import 'package:borome/store.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class FileGroupDetailsPage extends StatefulWidget {
  const FileGroupDetailsPage({
    Key key,
    @required this.name,
  }) : super(key: key);

  final String name;

  @override
  _FileGroupDetailsPageState createState() => _FileGroupDetailsPageState();
}

class _FileGroupDetailsPageState extends State<FileGroupDetailsPage> {
  String _selectedName;

  @override
  void initState() {
    super.initState();

    _selectedName = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: StreamBuilder<SubState<UserModel>>(
        initialData: context.store.state.value.user,
        stream: context.store.state.map((state) => state.user),
        builder: (context, snapshot) {
          final data = snapshot.data;
          return CustomScrollView(
            slivers: [
              CustomSliverAppBar(title: Text("File Details"), primary: true, isLoading: data.loading),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    if (data.hasError)
                      TouchableOpacity(
                        child: ErrorTextWidget(message: data.error),
                        onPressed: () => context.dispatchAction(UserActions.fetch()),
                      ),
                    if (data.hasData) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18).scale(context),
                        child: DropDownFormField(
                          initialValue: _selectedName,
                          items: data.value.filesGrouped.keys.toList(),
                          decoration: const InputDecoration(hintText: "Group"),
                          onChanged: (value) {
                            setState(() {
                              _selectedName = value;
                            });
                          },
                        ),
                      ),
                      const ScaledBox.vertical(8),
                      FileItemGroup(
                        name: _selectedName,
                        files: data.value.filesGrouped[_selectedName],
                      ),
                      const ScaledBox.vertical(32),
                    ]
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
