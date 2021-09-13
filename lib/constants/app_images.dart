import 'package:flutter/widgets.dart';

class AppImages {
  static const List<ImageProvider> onboard = [
    AssetImage('assets/onboard/1.png'),
    AssetImage('assets/onboard/2.png'),
    AssetImage('assets/onboard/3.png'),
  ];

  static const Map<String, ImageProvider> cards = {
    'visa': visa,
    'verve': mastercard,
    'mastercard': mastercard,
  };

  static const ImageProvider logo = AssetImage('assets/images/logo.png');
  static const ImageProvider splash = AssetImage('assets/images/splash.png');
  static const ImageProvider icon = AssetImage('assets/images/icon.png');
  static const ImageProvider success = AssetImage('assets/images/success.png');
  static const ImageProvider successCheck = AssetImage('assets/images/success_check.png');
  static const ImageProvider paystack = AssetImage('assets/images/paystack.png');
  static const ImageProvider rave = AssetImage('assets/images/rave.png');
  static const ImageProvider failure = AssetImage('assets/images/failure.png');
  static const ImageProvider failureCheck = AssetImage('assets/images/failure_check.png');
  static const ImageProvider header = AssetImage('assets/images/header.png');
  static const ImageProvider balanceBackground = AssetImage('assets/images/balance_background.png');
  static const ImageProvider cardBackground = AssetImage('assets/images/card_background.png');
  static const ImageProvider cardAltBackground = AssetImage('assets/images/card_alt_background.png');
  static const ImageProvider loanProcess = AssetImage('assets/images/loan_process.png');
  static const ImageProvider mastercard = AssetImage('assets/images/mastercard.png');
  static const ImageProvider visa = AssetImage('assets/images/visa.png');
}
