import 'package:guard_code/preload.dart';
import 'package:guard_code/public/style/app_theme_type.dart';

/// 大小配置
abstract class SizeStyle {
  static AppThemeType? _type;
  static SizeStyle? _impl;

  factory SizeStyle(AppThemeType type) {
    if (_type != null && _type == type && _impl != null) {
      return _impl!;
    }
    _type = type;
    switch (type) {
      case AppThemeType.dark:
      case AppThemeType.light:
        _impl = DefaultSizeStyle();
    }
    return _impl!;
  }

  // ------------------------ 文本 ------------------------
  /// 页面核心强调 28
  double get textStress;

  /// 大标题 20
  double get textBigTitle;

  /// 大标题 18
  double get textTitle;

  /// 小标题 16
  double get textSubTitle;

  /// 列表 15
  double get textList;

  /// 常规内容 14
  double get textContent;

  /// 次常规内容 12
  double get textSubContent;

  /// 弱化内容和弱辅助文案 11
  double get textWeak;
}


class DefaultSizeStyle implements SizeStyle {
  @override
  double get textStress => 56.sp;

  @override
  double get textBigTitle => 40.sp;

  @override
  double get textTitle => 36.sp;

  @override
  double get textSubTitle => 32.sp;

  @override
  double get textList => 30.sp;

  @override
  double get textContent => 28.sp;

  @override
  double get textSubContent => 24.sp;

  @override
  double get textWeak => 22.sp;
}
