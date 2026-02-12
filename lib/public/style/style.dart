import 'package:flutter/material.dart';
import 'package:guard_code/public/style/app_theme_type.dart';
import 'package:guard_code/public/style/color_style.dart';
import 'package:guard_code/public/style/size_style.dart';
import 'package:guard_code/public/style/text_style.dart';

/// 改变主题:Get.changeTheme(ThemeData.light());
class AppTheme {
  /// 当前主题，默认是亮色
  static AppThemeType currentAppThemeType = AppThemeType.light;

  AppTheme._();

  static ThemeData getTheme([AppThemeType type = AppThemeType.light]) {
    currentAppThemeType = type;
    switch (type) {
      case AppThemeType.dark:
        return _darkTheme;
      case AppThemeType.light:
        return _lightTheme;
    }
  }

  static final ThemeData _lightTheme = _getBaseTheme(AppThemeType.light).copyWith(
    brightness: Brightness.light,
  );

  static final ThemeData _darkTheme = _getBaseTheme(AppThemeType.dark).copyWith(
    brightness: Brightness.dark,
  );

  static ThemeData _getBaseTheme(AppThemeType type) {
    AppColorStyle colorStyle = AppColorStyle(type);
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: colorStyle.primaryColor,
      // accentColor: colorStyle.primaryColor,
      scaffoldBackgroundColor: colorStyle.backgroundColorBig,
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: colorStyle.primaryColor,
      ),
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
    );
  }
}

extension ThemeDataExtension on ThemeData {
  AppColorStyle get appColorStyle {
    return AppColorStyle(AppTheme.currentAppThemeType);
  }

  SizeStyle get sizeStyle {
    return SizeStyle(AppTheme.currentAppThemeType);
  }

  AppTextStyle get appTextStyle {
    return AppTextStyle(AppTheme.currentAppThemeType);
  }
}
