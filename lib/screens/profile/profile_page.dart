import 'package:borome/constants.dart';
import 'package:borome/registry.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final iconColor = kTextBaseColor.withOpacity(.5);
    return Material(
      child: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: Text("Profile"), primary: true, automaticallyImplyLeading: false),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              ListTile.divideTiles(
                context: context,
                color: kBorderSideColor,
                tiles: [
                  _ItemTile(
                    leading: Icon(AppIcons.id_card, color: iconColor),
                    title: Text("Personal Information"),
                    onTap: () => Registry.di.coordinator.profile.toPersonalInformation(),
                  ),
                  _ItemTile(
                    leading: Icon(AppIcons.phone_book, color: iconColor),
                    title: Text("Contact Information"),
                    onTap: () => Registry.di.coordinator.profile.toContactInformation(),
                  ),
                  _ItemTile(
                    leading: Icon(AppIcons.padlock, color: iconColor),
                    title: Text("Change Password"),
                    onTap: () => Registry.di.coordinator.profile.toChangePassword(),
                  ),
                  _ItemTile(
                    leading: Icon(AppIcons.bank, color: iconColor),
                    title: Text("My Bank"),
                    onTap: () => Registry.di.coordinator.profile.toMyBank(),
                  ),
                  _ItemTile(
                    leading: Icon(AppIcons.folder, color: iconColor),
                    title: Text("My Files"),
                    onTap: () => Registry.di.coordinator.profile.toMyFiles(),
                  ),
                  _ItemTile(
                    leading: Icon(AppIcons.buildings, color: iconColor),
                    title: Text("Work Details"),
                    onTap: () => Registry.di.coordinator.profile.toWorkDetails(),
                  ),
                  _ItemTile(
                    leading: Icon(AppIcons.file, color: iconColor),
                    title: Text("Work Identification"),
                    onTap: () => Registry.di.coordinator.profile.toWorkId(),
                  ),
                  _ItemTile(
                    leading: Icon(AppIcons.followers, color: iconColor),
                    title: Text("Next of Kin"),
                    onTap: () => Registry.di.coordinator.profile.toNextOfKin(),
                  ),
                  _ItemTile(
                    leading: Icon(AppIcons.photo_camera, color: iconColor),
                    title: Text("Profile Photo"),
                    onTap: () => Registry.di.coordinator.profile.toProfilePhoto(),
                  ),
                ],
              ).toList(),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                TouchableOpacity(
                  onPressed: () => logoutAction(context: context),
                  color: AppColors.danger,
                  child: Text("Sign Out"),
                ),
                ScaledBox.vertical(2),
                Text(
                  "Version ${Registry.di.appDeviceInfo.version}",
                  style: context.theme.smallSemi,
                  textAlign: TextAlign.center,
                ),
                ScaledBox.vertical(24),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    Key key,
    @required this.leading,
    @required this.title,
    @required this.onTap,
    this.color,
  }) : super(key: key);

  final Widget leading;
  final Widget title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox.fromSize(
        size: Size.square(32),
        child: Center(child: leading),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: context.scale(4), horizontal: context.scaleY(16)),
      title: DefaultTextStyle(
        child: title,
        style: ThemeProvider.of(context).title.copyWith(color: color ?? AppColors.dark),
      ),
      trailing: Icon(AppIcons.chevron, color: kTextBaseColor, size: 12),
      onTap: onTap,
    );
  }
}
