class CustomerError implements Exception{
  int errorCode;
  String errorMessage;
  
  CustomerError(this.errorCode, this.errorMessage);
  
  @override
  String toString() {
    return 'CoreError{errorCode: , errorMessage: }';
  }
}
