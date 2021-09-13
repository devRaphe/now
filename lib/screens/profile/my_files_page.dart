import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens/profile/widgets/file_group_item.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class MyFilesPage extends StatefulWidget {
  const MyFilesPage({Key key}) : super(key: key);

  @override
  _MyFilesPageState createState() => _MyFilesPageState();
}

class _MyFilesPageState extends State<MyFilesPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: StreamBuilder<SubState<UserModel>>(
        initialData: context.store.state.value.user,
        stream: context.store.state.map((state) => state.user),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final fileGroupTitles = data.hasData ? data.value.filesGrouped.keys.toList() : <String>[];
          return CustomScrollView(
            slivers: [
              CustomSliverAppBar(
                title: Text("My Files"),
                primary: true,
                trailing: IconButton(
                  iconSize: IconTheme.of(context).size,
                  icon: Icon(AppIcons.plus),
                  onPressed: () => Registry.di.coordinator.profile.toAddFile(),
                ),
                isLoading: data.loading,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    if (data.hasError)
                      TouchableOpacity(
                        child: ErrorTextWidget(message: data.error),
                        onPressed: () => context.dispatchAction(UserActions.fetch()),
                      ),
                    if (data.empty || (data.hasData && fileGroupTitles.isEmpty)) ...[
                      const ScaledBox.vertical(8),
                      Center(child: Text("No files to see yet")),
                    ],
                    if (fileGroupTitles.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 54).scale(context),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, i) {
                            final title = fileGroupTitles[i];
                            return FileGroupItem(
                              title: title,
                              count: data.value.filesGrouped[title].length,
                              onPressed: () => Registry.di.coordinator.profile.toFileGroup(title),
                              onDelete: () => onDeleteGroup(title),
                            );
                          },
                          shrinkWrap: true,
                          itemCount: fileGroupTitles.length,
                          separatorBuilder: (_a, _b) => const ScaledBox.vertical(12),
                        ),
                      ),
                      const ScaledBox.vertical(32),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void onDeleteGroup(String name) async {
    final choice = await showConfirmDialog(context, "Do you wish to delete this group?");

    if (choice != true) {
      return;
    }

    AppSnackBar.of(context).loading();
    try {
      final message = await Registry.di.repository.auth.deleteFileGroup(name);
      if (!mounted) {
        return;
      }

      context.dispatchAction(UserActions.fetch());
      AppSnackBar.of(context).success(message);
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }
}
