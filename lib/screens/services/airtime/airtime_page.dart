import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class AirtimePage extends StatefulWidget {
  @override
  _AirtimePageState createState() => _AirtimePageState();
}

class _AirtimePageState extends State<AirtimePage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.dark.shade50,
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: Text("Purchase Airtime"), primary: true),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  "SAVED TRANSACTIONS",
                  style: context.theme.subhead1.semibold.copyWith(height: 1.24, letterSpacing: 1.5),
                ),
                const ScaledBox.vertical(20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
