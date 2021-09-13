import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key, @required this.isFirstTime}) : super(key: key);

  final bool isFirstTime;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> logoAnimation;

  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    logoAnimation = CurvedAnimation(parent: controller, curve: Curves.decelerate)..addListener(_listener);
    controller.forward();
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    controller.dispose();
    super.dispose();
  }

  void onComplete() async {
    if (_hasCompleted) {
      return;
    }
    _hasCompleted = true;

    if (widget.isFirstTime) {
      Registry.di.coordinator.shared.toOnboard();
      return;
    }

    Registry.di.coordinator.shared.toStart(pristine: true);
  }

  void _listener() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AppImages.splash, fit: BoxFit.fill),
          color: AppColors.white,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Transform.translate(
              offset: Offset(0, -context.scaleY(logoAnimation.value * 81 / 2)),
              child: Image(height: context.scaleY(81), image: AppImages.logo),
            ),
            Align(
              alignment: Alignment(0, .5),
              child: StreamBuilder<SubState<SetUpData>>(
                initialData: context.store.state.value.setup,
                stream: context.store.state.map((state) => state.setup),
                builder: (context, snapshot) {
                  if (snapshot.data.loading) {
                    return LoadingSpinner.circle();
                  }

                  if (snapshot.data.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(snapshot.data.error, textAlign: TextAlign.center),
                          TextButton(
                            child: Text("RETRY"),
                            onPressed: () => context.dispatchAction(SetupActions.init()),
                          )
                        ],
                      ),
                    );
                  }

                  if (snapshot.data.empty || (snapshot.data.value?.isEmpty ?? true)) {
                    return const SizedBox();
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) => onComplete());
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
