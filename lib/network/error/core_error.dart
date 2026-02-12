/// 后台服务错误
class CoreError implements Exception {
  int errorCode;
  String errorMessage;

  CoreError(this.errorCode, this.errorMessage);

  @override
  String toString() {
    return 'CoreError{errorCode: , errorMessage: }';
  }
}
