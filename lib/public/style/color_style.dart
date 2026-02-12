import 'package:flutter/material.dart';
import 'package:guard_code/public/style/app_theme_type.dart';


/// 颜色配置
abstract class AppColorStyle {
  static AppThemeType? _type;
  static AppColorStyle? _impl;

  factory AppColorStyle(AppThemeType type) {
    if (_type != null && _type == type && _impl != null) {
      return _impl!;
    }
    _type = type;
    switch (type) {
      case AppThemeType.dark:
        _impl = DarkColorStyle();
        break;
      case AppThemeType.light:
        _impl = LightColorStyle();
    }
    return _impl!;
  }

  /// 主题色
  Color get primaryColor;

  /// 主题色+
  Color get primaryPlusColor;

  /// 主题色-
  Color get primaryLessColor;

  /// 窗体背景色
  Color get scaffoldBackGroundColor;

  /// 强调色
  Color get emphasisColorMain;

  /// 强调色
  Color get emphasisColorVice;

  /// 大面积背景色
  Color get backgroundColorBig;

  /// 中等区域背景色
  Color get backgroundColorMid;

  /// 小面积的背景色
  Color get backgroundColorSml;

  /// 背景色
  Color get splitColor;

  /// 文本-主色
  Color get textMainColor;

  /// 文本-次色
  Color get textSecondColor;

  /// 文本-次色
  Color get textThirdColor;

  /// 文本-次色
  Color get textFourthColor;

  /// 最浅的颜色，一般都设置白色
  Color get lightestColor;
}

class LightColorStyle implements AppColorStyle {

  // @override
  // Color get primaryPlusColor => const Color(0xffa5ccb7);
  //
  // @override
  // Color get primaryColor => const Color(0xffc4e6c3);
  //
  // @override
  // Color get primaryLessColor => const Color(0xffeefdf6);

  @override
  Color get primaryPlusColor => const Color(0xff338899);

  @override
  Color get primaryColor => const Color(0xff9EB69D);

  @override
  Color get primaryLessColor => const Color(0xffd9fff2);

  @override
  Color get scaffoldBackGroundColor => const Color(0xffFEFEF2);

  @override
  Color get emphasisColorMain => const Color(0xffE1938E);

  @override
  Color get emphasisColorVice => const Color(0xfff4b752);

  @override
  Color get backgroundColorBig => const Color(0xff453E40);

  @override
  Color get backgroundColorMid => const Color(0xffA2E6FE);

  @override
  Color get backgroundColorSml => const Color(0xff2D6275);

  @override
  Color get splitColor => const Color(0xffe5f4f9);

  @override
  Color get textMainColor => const Color(0xff333333);

  @override
  Color get textSecondColor => const Color(0xff2f2f2f);

  @override
  Color get textThirdColor => const Color(0xffc0c3c2);

  @override
  Color get textFourthColor => const Color(0xffffffff);

  @override
  Color get lightestColor => const Color(0xffffffff);


}

class DarkColorStyle implements AppColorStyle {
  @override
  Color get primaryColor => const Color(0xff30ae9e);

  @override
  Color get primaryPlusColor => const Color(0xff2D6275);

  @override
  Color get primaryLessColor => const Color(0xff82C4A0);

  @override
  Color get scaffoldBackGroundColor => const Color(0xffFEFEF2);

  @override
  Color get emphasisColorMain => const Color(0xffEB8070);

  @override
  Color get emphasisColorVice => const Color(0xffEB8070);

  @override
  Color get backgroundColorBig => const Color(0xfff8f8f8);

  @override
  Color get backgroundColorMid => const Color(0xff0E2F3B);

  @override
  Color get backgroundColorSml => const Color(0xff0E2F3B);

  @override
  Color get splitColor => const Color(0xffe3e3e3);

  @override
  Color get textMainColor => const Color(0xff2f2f2f);

  @override
  Color get textSecondColor => const Color(0xff999999);

  @override
  Color get textThirdColor => const Color(0xffB2B2B2);

  @override
  Color get textFourthColor => const Color(0xffc7c7c7);

  @override
  Color get lightestColor => const Color(0xffffffff);
}
