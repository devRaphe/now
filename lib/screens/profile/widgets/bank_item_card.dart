import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class BankItemCard extends StatelessWidget {
  const BankItemCard({
    Key key,
    @required this.item,
    @required this.imageUrl,
  }) : super(key: key);

  final AccountModel item;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context).subhead3.copyWith(color: AppColors.white);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AppImages.cardBackground,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(AppColors.dark, BlendMode.hue),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8).scale(context),
      padding: EdgeInsets.all(18).scale(context),
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox.fromSize(
              size: Size.square(context.scale(32)),
              child: imageUrl == null
                  ? Icon(AppIcons.bank, color: Colors.white)
                  : CachedImage(url: imageUrl, loadingColor: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(AppIcons.bank, color: AppColors.white),
                  if (item.isDefaultBool)
                    Container(
                      margin: EdgeInsets.only(top: context.scaleY(2)),
                      constraints: BoxConstraints.tight(Size.square(14)),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(item.accountName, style: theme),
              const ScaledBox.vertical(8),
              Text(item.accountNumber, style: theme.copyWith(fontWeight: AppStyle.bold)),
              const ScaledBox.vertical(8),
            ],
          ),
        ],
      ),
    );
  }
}
