import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/screens/gallery/slides/slide_show_indicator_view.dart';
import 'package:borome/screens/gallery/slides/slide_show_view.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({
    Key key,
    @required this.item,
  }) : super(key: key);

  final ImageListItem item;

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.item.index, viewportFraction: .85);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: ClearAppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        trailing: AppCloseButton(color: Colors.white),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: SlideShowView(controller: pageController)),
          SlideShowIndicatorView(controller: pageController),
          const ScaledBox.vertical(32),
        ],
      ),
    );
  }
}
