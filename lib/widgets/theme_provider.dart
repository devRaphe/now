import 'package:borome/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends InheritedWidget {
  const ThemeProvider({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  TextStyle get xxsmall => _text10Style;

  TextStyle get xxsmallHint => xxsmall.copyWith(color: Colors.grey);

  TextStyle get xsmall => _text11Style;

  TextStyle get xsmallHint => xsmall.copyWith(color: Colors.grey);

  TextStyle get small => _text12Style;

  TextStyle get smallSemi => small.copyWith(fontWeight: AppStyle.semibold);

  TextStyle get smallButton => small.copyWith(color: AppColors.primary, fontWeight: AppStyle.bold);

  TextStyle get body1 => _text14Style;

  TextStyle get body2 => body1.copyWith(height: 1.5);

  TextStyle get bodyMedium => body1.copyWith(fontWeight: AppStyle.medium);

  TextStyle get bodySemi => body1.copyWith(fontWeight: AppStyle.semibold);

  TextStyle get bodyBold => body1.copyWith(fontWeight: AppStyle.bold);

  TextStyle get bodyHint => body1.copyWith(color: Colors.grey);

  TextStyle get button => title.copyWith(height: 1.24, fontWeight: AppStyle.semibold);

  TextStyle get title => _text18Style;

  TextStyle get label => bodySemi;

  TextStyle get subhead1 => _text15MediumStyle;

  TextStyle get subhead1Semi => _text15SemiStyle;

  TextStyle get subhead1Bold => _text15BoldStyle;

  TextStyle get subhead1Light => _text15LightStyle;

  TextStyle get subhead2 => _text14Style;

  TextStyle get subhead3 => _text16Style;

  TextStyle get subhead3Semi => _text16Style.copyWith(fontWeight: AppStyle.semibold);

  TextStyle get subhead3Light => _text16Style.copyWith(fontWeight: AppStyle.light);

  TextStyle get headline => _text48Style;

  TextStyle get display1 => _text20Style;

  TextStyle get display2 => _text24Style.copyWith(height: 1.05);

  TextStyle get display3 => _text28Style;

  TextStyle get display4 => _text32Style;

  TextStyle get display5 => _text34Style;

  TextStyle get display6 => _text36Style;

  TextStyle get textfield => _text16Style.copyWith(color: AppColors.dark);

  TextStyle get textfieldLabel => textfield.copyWith(
        height: 0.25,
        color: AppColors.light_grey.withOpacity(.8),
      );

  TextStyle get errorStyle => small.copyWith(color: kBorderSideErrorColor);

  TextStyle get _text10Style => AppFont.size(10.0);

  TextStyle get _text11Style => AppFont.size(11.0);

  TextStyle get _text12Style => AppFont.size(12.0);

  TextStyle get _text14Style => AppFont.size(14.0);

  TextStyle get _text15SemiStyle => AppFont.semibold(15.0);

  TextStyle get _text15BoldStyle => AppFont.bold(15.0);

  TextStyle get _text15LightStyle => AppFont.light(15.0);

  TextStyle get _text15MediumStyle => AppFont.medium(15.0);

  TextStyle get _text16Style => AppFont.size(16.0);

  TextStyle get _text18Style => AppFont.size(18.0);

  TextStyle get _text20Style => AppFont.size(20.0);

  TextStyle get _text24Style => AppFont.size(24.0);

  TextStyle get _text28Style => AppFont.size(28.0);

  TextStyle get _text32Style => AppFont.size(32.0);

  TextStyle get _text34Style => AppFont.size(34.0);

  TextStyle get _text36Style => AppFont.size(36.0);

  TextStyle get _text48Style => AppFont.thin(48.0);

  static ThemeProvider of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ThemeProvider>();

  ThemeData themeData(ThemeData theme) {
    final textFieldBorder = OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12));

    return ThemeData(
      primarySwatch: AppColors.primaryAccent,
      primaryColor: AppColors.primary,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: AppColors.primaryAccent),
      textTheme: theme.textTheme.copyWith(
        bodyText2: theme.textTheme.bodyText2.merge(body1),
        button: theme.textTheme.button.merge(button),
        subtitle1: theme.textTheme.subtitle1.merge(textfield),
      ),
      iconTheme: theme.iconTheme.copyWith(size: 20),
      canvasColor: Colors.white,
      colorScheme: theme.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
      ),
      buttonTheme: theme.buttonTheme.copyWith(
        height: kButtonHeight,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: AppColors.primaryAccent,
          accentColor: AppColors.secondaryAccent,
        ),
        shape: const RoundedRectangleBorder(),
        highlightColor: Colors.white10,
        splashColor: Colors.white10,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: false,
        border: textFieldBorder,
        focusedBorder: textFieldBorder,
        enabledBorder: textFieldBorder,
        errorBorder: textFieldBorder.copyWith(borderSide: BorderSide(color: kBorderSideErrorColor, width: 1.0)),
        hintStyle: textfieldLabel,
        labelStyle: textfieldLabel,
        contentPadding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 26,
        ),
        fillColor: AppColors.dark.shade50,
        filled: true,
        errorStyle: errorStyle,
      ),
      textSelectionTheme: theme.textSelectionTheme.copyWith(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary,
        selectionHandleColor: AppColors.primary,
      ),
      fontFamily: AppFonts.base,
      hintColor: kHintColor,
      disabledColor: kHintColor,
      dividerColor: kBorderSideColor,
    );
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) => false;
}

extension TextStyleX on TextStyle {
  TextStyle get primary => copyWith(color: AppColors.primary);

  TextStyle get secondary => copyWith(color: AppColors.secondary);

  TextStyle get dark => copyWith(color: AppColors.dark);

  TextStyle get white => copyWith(color: AppColors.white);

  TextStyle get bold => copyWith(fontWeight: AppStyle.bold);

  TextStyle get semibold => copyWith(fontWeight: AppStyle.semibold);

  TextStyle get light => copyWith(fontWeight: AppStyle.light);

  TextStyle get medium => copyWith(fontWeight: AppStyle.medium);
}

extension BuildContextX on BuildContext {
  ThemeProvider get theme => ThemeProvider.of(this);
}
