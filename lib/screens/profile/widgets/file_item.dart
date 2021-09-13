import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class FileItem extends StatefulWidget {
  const FileItem({
    Key key,
    @required this.size,
    @required this.title,
    @required this.icon,
    @required this.onPressed,
    this.onDelete,
    this.color = AppColors.dark,
  }) : super(key: key);

  final Size size;
  final IconData icon;
  final Color color;
  final Widget title;
  final VoidCallback onPressed;
  final VoidCallback onDelete;

  @override
  _FileItemState createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  @override
  Widget build(BuildContext context) {
    return Ink(
      width: widget.size.width,
      height: widget.size.height,
      child: InkWell(
        splashColor: AppColors.secondaryAccent.shade50,
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(widget.icon, size: 48, color: widget.color),
                const ScaledBox.vertical(8),
                DefaultTextStyle(
                  child: widget.title,
                  style: ThemeProvider.of(context).bodySemi.copyWith(color: widget.color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            if (widget.onDelete != null)
              Align(
                alignment: const Alignment(.2, -.45),
                child: IconButton(
                  iconSize: IconTheme.of(context).size,
                  onPressed: widget.onDelete,
                  icon: Icon(AppIcons.cancel, color: AppColors.danger),
                ),
              ),
          ],
        ),
        onTap: widget.onPressed,
      ),
    );
  }
}
