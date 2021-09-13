import 'package:borome/constants.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens/onboard/page_view_overlay_indicator.dart';
import 'package:flutter/material.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({Key key}) : super(key: key);

  @override
  _OnboardPageState createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  PageController pageController;
  List<PageViewItem> pages;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    pages = [
      PageViewItem(
        image: AppImages.onboard[0],
        text: "Instant\naccess to\nloans in\nminutes",
        gradientColor: AppColors.primary,
        color: Colors.white,
        brightness: Brightness.light,
      ),
      PageViewItem(
        image: AppImages.onboard[1],
        text: "Multiple\noptions to\npay back\neasily",
        gradientColor: AppColors.white,
        color: AppColors.primary,
        brightness: Brightness.dark,
      ),
      PageViewItem(
        image: AppImages.onboard[2],
        text: "Grow your\ncredit score\nfor access to\neven more.",
        gradientColor: Colors.grey.shade800,
        color: Colors.white,
        brightness: Brightness.light,
      ),
    ];
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: pageController,
            physics: ClampingScrollPhysics(),
            children: [
              for (final page in pages) SizedBox.expand(child: Image(image: page.image, fit: BoxFit.cover)),
            ],
          ),
          PageViewOverlayIndicator(
            controller: pageController,
            pages: pages,
            onComplete: () => Registry.di.coordinator.shared.toStart(pristine: true),
          ),
        ],
      ),
    );
  }
}
