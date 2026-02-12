import "dart:async";
import 'dart:convert';

import 'package:guard_code/models/config.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class LocalSave {
  // 是否是第一次运行
  static Future<bool> isFirst() async {
    final sp = await SharedPreferences.getInstance();
    bool? everRun = sp.getBool('everRun');
    //判断一次后就设置为以运行过
    sp.setBool('everRun', true);
    return everRun == null || everRun == false;
  }

  // 清除所有数据
  static Future<void> cleanAllData() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }

  /// 存储Config
  static Future<void> saveConfig(Config config) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('config', json.encode(config.toJson()));
  }

  /// 存储Config
  static Future<Config> gainConfig() async {
    final sp = await SharedPreferences.getInstance();
    final configJsonStr = sp.getString('config');
    if (configJsonStr != null) {
      return Config.fromJsonSafe(json.decode(configJsonStr));
    } else {
      return Config.defaultConfig();
    }
  }

  /// 存储zhongyao
  static Future<void> saveZhongyao(String zhongyao) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('zhongyao', zhongyao);
  }

  /// 读取zhongyao
  static Future<String> gainZhongyao() async {
    final sp = await SharedPreferences.getInstance();
    final zhongyaoStr = sp.getString('zhongyao');
    return zhongyaoStr ?? "";
  }

  /// 存储supabase url
  static Future<void> saveSupabaseUrl(String supabaseUrl) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('supabaseUrl', supabaseUrl);
  }

  /// 读取supabase url
  static Future<String> gainSupabaseUrl() async {
    final sp = await SharedPreferences.getInstance();
    final supabaseUrl = sp.getString('supabaseUrl');
    return supabaseUrl ?? "";
  }

  /// 存储supabase key
  static Future<void> saveSupabaseKey(String supabaseKey) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('supabaseKey', supabaseKey);
  }

  /// 读取supabase key
  static Future<String> gainSupabaseKey() async {
    final sp = await SharedPreferences.getInstance();
    final supabaseKey = sp.getString('supabaseKey');
    return supabaseKey ?? "";
  }

  // ///存储user
  // static Future<void> saveUser(User user) async {
  //   Future<SharedPreferences> _sp = SharedPreferences.getInstance();
  //   final SharedPreferences sp = await _sp;
  //   sp.setString('user', json.encode(user.toJson()));
  // }

  // static Future<User?> gainUser() async {
  //   Future<SharedPreferences> _sp = SharedPreferences.getInstance();
  //   final SharedPreferences sp = await _sp;
  //   final userJsonStr = sp.getString('user');
  //   if (userJsonStr != null) {
  //     return User.fromJson(json.decode(userJsonStr));
  //   } else {
  //     return null;
  //   }
  // }

  //为了区分用户存储,所以要获取当前用户id
  //static String obtainCurrUserId(){

  //   Future<SharedPreferences> _sp = SharedPreferences.getInstance();
  //   final SharedPreferences sp = await _sp;
  //   sp.setString('user', json.encode(user.toJson()));
  // }

  // static Future<User?> gainUser() async {
  //   Future<SharedPreferences> _sp = SharedPreferences.getInstance();
  //   final SharedPreferences sp = await _sp;
  //   final userJsonStr = sp.getString('user');
  //   if (userJsonStr != null) {
  //     return User.fromJson(json.decode(userJsonStr));
  //   } else {
  //     return null;
  //   }
  // }

  //为了区分用户存储,所以要获取当前用户id
  //static String obtainCurrUserId(){
  //  BuildContext ctx = AppHelp.navigatorKey.currentState.overlay.context;
  //  return  ctx.read<User>().id;
  //}

  //
  //static String obtainCurrUserServerId(){
  //  BuildContext ctx = AppHelp.navigatorKey.currentState.overlay.context;
  //  return ctx.read<User>().accountInfo.serverId;
  //}

  /// 保存用户登录信息，账号和密码
  // static Future<void> saveLoginInfo(String userName, String encryptedPwd) async {
  //   Future<SharedPreferences> _sp = SharedPreferences.getInstance();
  //   final SharedPreferences sp = await _sp;
  //   sp.setString('userName', userName);
  //   sp.setString('passWord', encryptedPwd);
  // }

  //   // 记住最后一次登录的用户名
  //   static Future<void> saveLastUserId(String userid) async {
  //     Future<SharedPreferences> _sp = SharedPreferences.getInstance();
  //     final SharedPreferences sp = await _sp;
  //     sp.setString('lastUserId', userid);
  //   }
  //
  //   // 获取最后一次登录的用户名
  //   static Future<String> getLastUserId() async {
  //     Future<SharedPreferences> _sp = SharedPreferences.getInstance();
  //     final SharedPreferences sp = await _sp;
  //     final String lastUserId = sp.getString('lastUserId');
  //     return lastUserId;
  //   }
  //
  // 保存用户
  //  static Future<void> saveUser(User user) async {
  //    Future<SharedPreferences> _sp = SharedPreferences.getInstance();
  //    final SharedPreferences sp = await _sp;
  //    sp.setString('user', json.encode(user.toJson()));
  //  }

  // 获取用户
  //  static Future<User> getUser() async {
  //    Future<SharedPreferences> _sp = SharedPreferences.getInstance();
  //    final SharedPreferences sp = await _sp;
  //    final String userStr = sp.getString('user');
  //    if (userStr == null) {
  //      return null;
  //    }
  //    return User.fromJson(json.decode(userStr));
  //  }

  // static savePayBusOrderId(String payBusOrderId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('payOrder', payBusOrderId);
  // }
  //
  // static Future<String?> gainPayBusOrderId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final  String? payBusOrderId = prefs.getString('payOrder');
  //   return payBusOrderId;
  // }
}
