import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guard_code/public/style/app_theme_type.dart';
import 'package:guard_code/public/style/color_style.dart';
import 'package:guard_code/public/style/size_style.dart';

class FontWeightType {
  const FontWeightType._();

  /// light 细体
  static const FontWeight light = FontWeight.w300;

  /// regular 常规
  static const FontWeight regular = FontWeight.w400;

  /// medium 中等
  static const FontWeight medium = FontWeight.w500;

  /// semibold 半粗
  static const FontWeight semibold = FontWeight.w600;
}

class AppTextStyle {
  static AppThemeType? _type;
  static AppTextStyle? _impl;

  factory AppTextStyle(AppThemeType type) {
    if (_type != null && _type == type && _impl != null) {
      return _impl!;
    }
    _type = type;
    switch (type) {
      case AppThemeType.dark:
      case AppThemeType.light:
        _impl = AppTextStyle._();
    }
    return _impl!;
  }

  AppTextStyle._();

  /// 28 页面核心强调
  TextStyle stress({
    Color? color,
    FontWeight fontWeight = FontWeightType.regular,
  }) {
    return TextStyle(
      fontSize: SizeStyle(_type!).textStress,
      color: color ?? AppColorStyle(_type!).textMainColor,
      fontWeight: fontWeight,
    );
  }

  /// 20 特大标题
  TextStyle bigestTitle({
    Color? color,
    FontWeight fontWeight = FontWeightType.medium,
  }) {
    return TextStyle(
      fontSize: 96.sp,
      color: color ?? AppColorStyle(_type!).textMainColor,
      fontWeight: fontWeight,
    );
  }

  /// 20 大标题
  TextStyle bigTitle({
    Color? color,
    FontWeight fontWeight = FontWeightType.medium,
  }) {
    return TextStyle(
      fontSize: SizeStyle(_type!).textBigTitle,
      color: color ?? AppColorStyle(_type!).textMainColor,
      fontWeight: fontWeight,
    );
  }

  /// 18 大标题
  TextStyle navTitle({
    Color? color,
    FontWeight fontWeight = FontWeightType.medium,
  }) {
    return TextStyle(
      fontSize: SizeStyle(_type!).textBigTitle,
      color: color ?? AppColorStyle(_type!).lightestColor,
      fontWeight: fontWeight,
    );
  }

  /// 18 大标题
  TextStyle title({
    Color? color,
    FontWeight fontWeight = FontWeightType.medium,
  }) {
    return TextStyle(
      fontSize: SizeStyle(_type!).textTitle,
      color: color ?? AppColorStyle(_type!).textMainColor,
      fontWeight: fontWeight,
    );
  }

  /// 16 子标题
  TextStyle subTitle({
    Color? color,
    FontWeight fontWeight = FontWeightType.medium,
  }) {
    return TextStyle(
      fontSize: SizeStyle(_type!).textSubTitle,
      color: color ?? AppColorStyle(_type!).textMainColor,
      fontWeight: fontWeight,
    );
  }

  /// 15 列表
  TextStyle list({
    Color? color,
    FontWeight fontWeight = FontWeightType.regular,
  }) {
    return TextStyle(
      fontSize: SizeStyle(_type!).textList,
      color: color ?? AppColorStyle(_type!).textMainColor,
      fontWeight: fontWeight,
    );
  }

  /// 14 字段名称内容
  TextStyle fieldTitle({
    Color? color,
    FontWeight fontWeight = FontWeightType.medium,
  }) {
    return TextStyle(
      fontSize: SizeStyle(_type!).textContent,
      color: color ?? AppColorStyle(_type!).textMainColor,
      fontWeight: fontWeight,
    );
  }

  /// 14 常规内容
  TextStyle content({
    Color? color,
    FontWeight fontWeight = FontWeightType.regular,
  }) {
    return TextStyle(
      fontSize: SizeStyle(_type!).textContent,
      color: color ?? AppColorStyle(_type!).textMainColor,
      fontWeight: fontWeight,
    );
  }

  /// 12 次常规内容
  TextStyle subContent({
    Color? color,
    FontWeight fontWeight = FontWeightType.regular,
  }) {
    return TextStyle(
      fontSize: SizeStyle(_type!).textSubContent,
      color: color ?? AppColorStyle(_type!).textMainColor,
      fontWeight: fontWeight,
    );
  }

  /// 11 弱化内容和弱辅助文案
  TextStyle weak({
    Color? color,
    FontWeight fontWeight = FontWeightType.regular,
  }) {
    return TextStyle(
      fontSize: SizeStyle(_type!).textWeak,
      color: color ?? AppColorStyle(_type!).textThirdColor,
      fontWeight: fontWeight,
    );
  }

  /// 22px 弱化内容和弱辅助文案
  TextStyle hint({
    Color? color,
    FontWeight fontWeight = FontWeightType.regular,
  }) {
    return TextStyle(
      fontSize: SizeStyle(_type!).textWeak,
      color: color ?? AppColorStyle(_type!).textThirdColor,
      fontWeight: fontWeight,
    );
  }
}
