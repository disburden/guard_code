import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_des/dart_des.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guard_code/preload.dart';
import 'package:flutter/services.dart';
import 'package:guard_code/public/define.dart';
import 'package:guard_code/public/style/style.dart';
import 'package:wgq_dart/wgq_dart.dart';
import 'package:otp/otp.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

class AppHelp {
  static get SharedPreferences => null;

  static ptv(obj) {
    print('Typeis:${obj.runtimeType} value:${obj}');
  }

  static AppBar buildAppBar(String title, [List<Widget>? action = null]) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(appContext).appColorStyle.textMainColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Theme.of(
        appContext,
      ).appColorStyle.scaffoldBackGroundColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Theme.of(appContext).appColorStyle.primaryColor,
      ),
      actions: action,
    );
  }

  static Widget buildCircleAvatar(String imageName, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // 向四周发散的阴影效果
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              appContext,
            ).appColorStyle.primaryColor, // 阴影颜色（与边框协调）
            blurRadius: 2, // 发散程度：值越大阴影越扩散
            spreadRadius: 2, // 扩展程度：值越大阴影范围越大
            offset: const Offset(0, 0), // 偏移量：0,0表示四周均匀发散
          ),
          // 可以添加多层阴影实现更复杂效果
          // BoxShadow(
          //   color: Colors.blueAccent.withOpacity(0.2),
          //   blurRadius: 4,
          //   // spreadRadius: 1,
          // ),
        ],
      ),
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(2), // 边框宽度2px
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Theme.of(appContext).appColorStyle.primaryColor,
              Theme.of(appContext).appColorStyle.primaryColor.withAlpha(128),
            ],
            // colors: [Colors.blue, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // 可选：防止内层阴影穿透
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: ClipOval(
          child: Container(
            width: 32, // 72 - 2*4 = 64
            height: 32,
            color: Colors.white, // 间距颜色
            padding: const EdgeInsets.all(2), // 图像与白色区域的间距
            child: ClipOval(
              child: Image.asset(
                imageName,
                fit: BoxFit.cover,
                // 加载时的占位符
                // loadingBuilder: (context, child, loadingProgress) {
                //   if (loadingProgress == null) return child;
                //   return Center(
                //     child: CircularProgressIndicator(
                //       value: loadingProgress.expectedTotalBytes != null
                //           ? loadingProgress.cumulativeBytesLoaded /
                //                 loadingProgress.expectedTotalBytes!
                //           : null,
                //     ),
                //   );
                // },
                // 加载失败时的备用图
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildSearchBar(
    TextEditingController controller,
    Function(String)? onChanged,
    String hintText,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100], // 浅灰色背景
        borderRadius: BorderRadius.circular(24), // 圆角
        border: Border.all(
          color: Theme.of(appContext).appColorStyle.primaryColor,
        ), // 可选边框
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none, // 去掉默认下划线
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  // 清除本地存储数据,只删除以startWith开头的键值对
  static cleanLocalStorage(String startWith) async {
    final prefs = await SharedPreferences.getInstance();
    final keysToRemove = prefs.getKeys().where(
      (key) => key.startsWith(startWith),
    );
    for (final key in keysToRemove) {
      await prefs.remove(key);
    }
  }

  static clearLocalAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('所有SharedPreferences数据已清除');
  }

  static Widget buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xFF555555),
          fontSize: 14,
        ),
      ),
    );
  }

  static Widget buildInput({
    required String hintText,
    required bool isPassword,
    required TextEditingController controller,
    int? maxLength, // 新增：最大长度（可选）
  }) {
    bool _obscureText = isPassword;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return TextFormField(
          controller: controller,
          obscureText: _obscureText,
          style: const TextStyle(fontSize: 16),

          // ⭐长度限制
          maxLength: maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,

          decoration: InputDecoration(
            counterText: "", // 隐藏默认的 0/30 计数器

            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 14,
            ),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF9EB69D), width: 2),
            ),

            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        );
      },
    );
  }

  static Widget buildTips(String text, {Color? fontColor}) {
    fontColor ??= const Color(0xFF999999);
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: TextStyle(fontSize: 12, color: fontColor)),
      ),
    );
  }

  static Widget jh() {
    return const Center(child: CircularProgressIndicator());
  }

  static String jiami(String mingwen, String key) {
    final base64Guard = WDEncrypt.encodeUseBase64UrlSafe(mingwen);
    DES desECB = DES(key: key.codeUnits, mode: DESMode.ECB);
    List<int> encrypted;
    encrypted = desECB.encrypt(base64Guard.codeUnits);
    //再用base64对List<int>进行编码,得到加密后的base64
    final miwen = base64.encode(encrypted);
    return miwen;
  }

  static String jiemi(String miwen, String key) {
    List<int> encrypted = base64.decode(miwen);
    //根据key生成一个加密器
    DES desECB = DES(key: key.codeUnits, mode: DESMode.ECB);
    //用加密器进行解密,得到原文List<int>
    List<int> decrypted = desECB.decrypt(encrypted);
    //还原原文,这里的原文就是base64,因为之前为了解决字符集问题,明文都被编码为base64
    final sss = utf8.decode(decrypted);
    //最后把base64还原为明文
    final mingwen = WDEncrypt.decodeUseBase64UrlSafe(sss);
    return mingwen;
  }

  static String gainCode(String guard) {
    final now = DateTime.now();
    timezone.initializeTimeZones();

    final pacificTimeZone = timezone.getLocation('America/Los_Angeles');
    final date = timezone.TZDateTime.from(now, pacificTimeZone);
    final code = OTP.generateTOTPCodeString(
      guard,
      date.millisecondsSinceEpoch,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );
    return code;
  }

  static Widget urlImage(String? imageUrl) {
    // 情况一：URL 为空或空白
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      // return Image.asset(
      //   DEFAULT_LOGO_URL,
      //   fit: BoxFit.contain,
      //   width: 72,
      //   height: 48,
      // );
      imageUrl = DEFAULT_LOGO_URL;
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        // 这里可以检测URL后缀，决定使用哪种渲染方式
        if (imageUrl!.endsWith('.svg')) {
          return SvgPicture.network(imageUrl);
        } else {
          return Image(image: imageProvider);
        }
      },
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      width: 72,
      height: 48,
    );

    // // 情况二：判断是否为 SVG
    // final isSvg =
    //     imageUrl.toLowerCase().endsWith('.svg') ||
    //     Uri.tryParse(imageUrl)?.path.toLowerCase().endsWith('.svg') == true;

    // if (isSvg) {
    //   return SvgPicture.network(
    //     imageUrl,
    //     placeholderBuilder: (context) => const CircularProgressIndicator(),
    //     errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    //     fit: BoxFit.contain,
    //   );
    // }

    // // 情况三：普通图片
    // debugPrint('   图片: $imageUrl');
    // return CachedNetworkImage(
    //   imageUrl: imageUrl,
    //   placeholder: (context, url) => const CircularProgressIndicator(),
    //   errorWidget: (context, url, error) => const Icon(Icons.error),
    //   fit: BoxFit.contain,
    // );
  }
}
