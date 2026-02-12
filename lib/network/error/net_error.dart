/// 网络错误 
class NetError implements Exception { 
  int errorCode; 
  String errorMessage; 
 
  NetError(this.errorCode, this.errorMessage); 
 
  @override 
  String toString() { 
    return 'NetError{errorCode: , errorMessage: }'; 
  } 
} 
