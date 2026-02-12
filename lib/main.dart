import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guard_code/pages/page_home.dart';
import 'package:guard_code/public/define.dart';
import 'package:guard_code/public/style/style.dart';
import 'preload.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final config = await container.read(configProvider.future);

  await Supabase.initialize(
    url: config.supabaseUrl,
    anonKey: config.supabaseKey,
  );
  // await Supabase.initialize(url: SUPABASE_URL, anonKey: SUPABASE_KEY);

  // 直接运行测试
  // await testLink();
  // runApp(MyApp());
  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

Future<void> testLink() async {
  // print('🚀 开始测试 Supabase 连接...');
  // print('🔗 URL: $supabaseUrl');

  // // 检查配置是否已填写
  // if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
  //   print('❌ 错误：请先填写 supabaseUrl 和 supabaseAnonKey');
  //   print('   1. 登录 Supabase Dashboard');
  //   print('   2. 进入你的项目');
  //   print('   3. 点击 Settings → API');
  //   print('   4. 复制 URL 和 anon public key');
  //   return;
  // }

  // try {
  //   // 1. 初始化 Supabase
  //   print('🔄 正在初始化...');
  //   await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  //   print('✅ Supabase 初始化完成');

  //   // 2. 获取客户端
  //   final client = Supabase.instance.client;

  //   // 3. 测试连接：尝试查询 tag 表
  //   print('🔄 正在连接数据库...');
  //   final startTime = DateTime.now();

  //   final response = await client
  //       .from('tag')
  //       .select()
  //       .limit(1)
  //       .timeout(const Duration(seconds: 10));

  //   final endTime = DateTime.now();
  //   final duration = endTime.difference(startTime);

  //   // 4. 显示结果
  //   print('=' * 50);
  //   print('🎉 连接成功！');
  //   print('⏱️  响应时间: ${duration.inMilliseconds}ms');
  //   print('📊 返回记录数: ${response.length}');

  //   if (response.isNotEmpty) {
  //     print('📝 第一条记录:');
  //     print('   ${response.first}');
  //   } else {
  //     print('📭 表为空，但连接正常');
  //   }

  //   print('=' * 50);
  // } catch (e) {
  //   // 5. 连接失败的处理
  //   print('=' * 50);
  //   print('❌ 连接失败！');
  //   print('错误信息: $e');
  //   print('');

  //   // 错误诊断
  //   final errorStr = e.toString();

  //   if (errorStr.contains('Invalid argument(s)')) {
  //     print('💡 可能原因：URL 或 anonKey 格式错误');
  //   } else if (errorStr.contains('Failed host lookup')) {
  //     print('💡 可能原因：');
  //     print('   1. URL 地址错误');
  //     print('   2. 网络连接问题');
  //     print('   3. 请检查 URL: $supabaseUrl');
  //   } else if (errorStr.contains('401')) {
  //     print('💡 可能原因：');
  //     print('   1. anon key 错误');
  //     print('   2. 请确认使用的是 anon public key，不是 service_role');
  //     print('   3. 在 Settings → API 中复制正确的 anon public key');
  //   } else if (errorStr.contains('does not exist')) {
  //     print('💡 可能原因：');
  //     print('   1. 表 "tag" 不存在');
  //     print('   2. 请在 Supabase Table Editor 中创建该表');
  //   } else if (errorStr.contains('timeout')) {
  //     print('💡 可能原因：');
  //     print('   1. 网络连接慢');
  //     print('   2. 服务器响应慢');
  //   } else if (errorStr.contains('JWT')) {
  //     print('💡 可能原因：');
  //     print('   1. anon key 格式错误');
  //     print('   2. 请确认复制的 anon key 完整');
  //   }

  //   print('=' * 50);
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '护卫码',
      theme: ThemeData(
        scaffoldBackgroundColor: Theme.of(
          context,
        ).appColorStyle.scaffoldBackGroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(
            context,
          ).appColorStyle.primaryPlusColor, // ✅ 直接控制 AppBar
          foregroundColor: Colors.white, // AppBar 文字/图标颜色
          elevation: 4, // 阴影
        ),
      ),
      // theme: ThemeData(primarySwatch: Colors.blue),
      home: PageHome(),
      onGenerateTitle: (BuildContext context) {
        appContext = context;
        return '护卫码';
      },
    );
  }
}
