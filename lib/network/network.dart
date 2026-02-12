import 'package:guard_code/network/error/error_code.dart'; 
import 'package:guard_code/network/error/net_error.dart'; 
import 'package:dio/dio.dart'; 
import 'package:guard_code/public/define.dart'; 
import 'dart:typed_data'; 
 
class NetWork { 
  static final _dio = Dio() 
    ..options.baseUrl = SERVER_HOST 
    ..options.receiveTimeout = Duration(milliseconds: 10000) 
    ..options.contentType = "application/json"; 
  
   
  Future<Response> awaitPost(String apiPath,String method, Map<String, dynamic> param, {bool needCompleteParam=true,CancelToken? cancelToken}) async { 
     
    //测试http网络请求的post方法 
    //要非常小心参数的类型,传的时候map类型要json.encode成json对象 
    //服务器端解的时候还要在decode成map 
    var parameter = { 
      "action": method, 
      "content": param, 
    }; 
 
    print("$method before para:${parameter}"); 
 
    // 当前不是ios就是android 
    _dio.options.headers['user-agent'] = 'web'; 
     
    // 请求 
    try { 
      var response = await _dio.post(apiPath, data: parameter, cancelToken: cancelToken); 
      if (response.statusCode != 200 || response.data == null) { 
        throw NetError(ErrorCode.netError, getNetErrorString()); 
      } 
      return response; 
    } catch (e) { 
      if (e is DioError) { 
        if (CancelToken.isCancel(e)) { 
          throw NetError(ErrorCode.netCancel, getNetCancelString()); 
        } else { 
          throw NetError(ErrorCode.netError, getNetErrorString()); 
        } 
      } 
      throw NetError(ErrorCode.netError, getNetErrorString()); 
    } 
  } 
   
  /// 网络请求 -- 上传头像 请求 
  void uploadImage(String patch, Uint8List imageData,String fileName,{CancelToken? cancelToken,}) async { 
     
    final _dio1 = Dio() 
      ..options.baseUrl = SERVER_HOST 
      ..options.receiveTimeout = Duration(milliseconds: 10000) 
      ..options.contentType = "application/x-www-form-urlencoded"; 
     
    Future<FormData> _obtainFormData() async { 
      return FormData.fromMap({ 
        "$fileName": await MultipartFile.fromBytes(imageData,) 
      }); 
    } 
     
    // 发起请求 
    print('begin request'); 
    try { 
      var response = await _dio1.post(patch, data: await _obtainFormData(), cancelToken: cancelToken); 
      print('request finish'); 
      if (response.statusCode != 200 || response.data == null) { 
      } 
    } on DioError catch (e) { 
      if (CancelToken.isCancel(e)) { 
      } else { 
      } 
    } catch (e) { 
    } 
  } 
 
  // 网络错误的文本 
  String getNetErrorString() { 
    return '获取数据失败'; 
  } 
   
  // 网络取消的本文 
  String getNetCancelString() { 
    return '请求已取消'; 
  } 
   
} 
