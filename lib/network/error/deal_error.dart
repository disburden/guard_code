import 'package:guard_code/network/error/core_error.dart';
import 'package:guard_code/network/error/net_error.dart';
import 'package:guard_code/preload.dart';
import 'package:guard_code/tools/toast.dart';

class DealErrorUtil {
  /// 统一处理app层的错误，包括api层错误，core层错误
  static void dealAppError(dynamic error) {
    if (error is NetError) {
      ToastUtil.showError(error.errorMessage);
    } else if (error is CoreError) {
      ToastUtil.showError(error.errorMessage);
    } else {
      ToastUtil.showError("未知错误：");
    }
  }
}
