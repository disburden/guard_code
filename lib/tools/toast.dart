import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  /// 参考于android的LENGTH_SHORT显示时长
  static const int LENGTH_SHORT = 2;

  /// 参考于android的LENGTH_LONG显示时长
  static const int LENGTH_LONG = 3;

  static showError(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP, // 设置为顶部
      webPosition: "center", // Web 平台上水平居中
      timeInSecForIosWeb: LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static showNormal(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP, // 居中显示
      webPosition: "center", // Web 平台上水平居中
      timeInSecForIosWeb: LENGTH_SHORT,
      backgroundColor: Colors.cyanAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
