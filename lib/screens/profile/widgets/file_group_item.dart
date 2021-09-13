import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class FileGroupItem extends StatelessWidget {
  const FileGroupItem({
    Key key,
    @required this.title,
    @required this.count,
    @required this.onPressed,
    @required this.onDelete,
  }) : super(key: key);

  final String title;
  final int count;
  final VoidCallback onPressed;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: ThemeProvider.of(context).subhead1Bold.copyWith(height: 1.24, color: AppColors.dark),
      ),
      subtitle: Text(
        "$count File${count > 1 ? 's' : ''}",
        style: ThemeProvider.of(context).subhead1.copyWith(height: 1.24),
      ),
      leading: Container(
        constraints: BoxConstraints.tight(Size.square(40)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xFFA2A2A2),
        ),
        child: Icon(AppIcons.file, color: Colors.white),
      ),
      trailing: IconButton(
        iconSize: IconTheme.of(context).size,
        icon: Icon(AppIcons.trash, color: kHintColor),
        onPressed: onDelete,
      ),
      onTap: onPressed,
    );
  }
}
