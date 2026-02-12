import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:guard_code/models/config.dart";
import "package:guard_code/preload.dart";
import "package:guard_code/public/define.dart";
import "package:guard_code/public/style/style.dart";
import "package:guard_code/tools/local_save.dart";

class PageSetting extends ConsumerStatefulWidget {
  const PageSetting({super.key});

  @override
  ConsumerState<PageSetting> createState() => _PageSettingState();
}

class _PageSettingState extends ConsumerState<PageSetting> {
  final _isAsyncing = false;

  final _ctlZhongyao = TextEditingController();
  final _ctlSupabaseUrl = TextEditingController();
  final _ctlSupabaseKey = TextEditingController();

  @override
  void initState() {
    super.initState();
    final configData = ref.read(configProvider);
    configData.whenData((data) {
      _ctlZhongyao.text = data.zhongyao;
      _ctlSupabaseUrl.text = data.supabaseUrl;
      _ctlSupabaseKey.text = data.supabaseKey;
    });
  }

  @override
  void dispose() {
    _ctlZhongyao.dispose();
    _ctlSupabaseKey.dispose();
    _ctlSupabaseUrl.dispose();
    _ctlZhongyao.dispose();
    _ctlSupabaseUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("设置")),
      body: ModalProgressHUD(
        opacity: 0,
        inAsyncCall: _isAsyncing,
        child: _buildMainBody(),
      ),
    );
  }

  Widget _buildMainBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerWidth = constraints.maxWidth < 500
            ? constraints.maxWidth - 40
            : 800.0;

        return Center(
          child: Container(
            width: containerWidth,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 密码
                  AppHelp.buildLabel('密码'),
                  AppHelp.buildInput(
                    hintText: '请输入密码',
                    isPassword: true,
                    controller: _ctlZhongyao,
                  ),
                  AppHelp.buildTips(
                    '''
请牢记此密码,否则你会丢失所有的验证数据\n
密码一旦丢失,将无法恢复
密码必须是8位字符
                    ''',
                    fontColor: Theme.of(
                      context,
                    ).appColorStyle.emphasisColorMain,
                  ),
                  const SizedBox(height: 24),

                  // 账号
                  AppHelp.buildLabel('Supabase URL'),
                  AppHelp.buildInput(
                    hintText: '请输入 Supabase URL',
                    isPassword: false,
                    controller: _ctlSupabaseUrl,
                  ),
                  AppHelp.buildTips('请填写你从 Supabase 获取的 URL 地址'),
                  const SizedBox(height: 16),

                  //校验码
                  AppHelp.buildLabel('Supabase Key'),
                  AppHelp.buildInput(
                    hintText: '请输入 Supabase Key',
                    isPassword: false,
                    controller: _ctlSupabaseKey,
                  ),
                  AppHelp.buildTips('请填写你从 Supabase 获取的 anon public key'),
                  // 清除按钮
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _ontapCleanData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).appColorStyle.emphasisColorMain,
                        foregroundColor: Theme.of(
                          context,
                        ).appColorStyle.textMainColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('清除本地数据'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _ontapSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9EB69D),
                        foregroundColor: Theme.of(
                          context,
                        ).appColorStyle.textMainColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('保存'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _ontapCleanData() async {
    WFDialogConfirmWith2Operation(context, "确定清除本地配置信息吗?", () async {
      await LocalSave.cleanAllData();
      _ctlSupabaseKey.text = "";
      _ctlSupabaseUrl.text = "";
      _ctlZhongyao.text = "";
      Navigator.of(context).pop();
    });
  }

  void _ontapSave() async {
    if (_ctlZhongyao.text.length != 8) {
      ToastUtil.showError("请输入长度为8的密码");
      return;
    }

    if (_ctlSupabaseUrl.text.isEmpty) {
      ToastUtil.showError("请输入 Supabase URL");
      return;
    }

    if (_ctlSupabaseKey.text.isEmpty) {
      ToastUtil.showError("请输入 Supabase Key");
      return;
    }
    Config newConfig = Config(
      zhongyao: _ctlZhongyao.text,
      supabaseUrl: _ctlSupabaseUrl.text,
      supabaseKey: _ctlSupabaseKey.text,
    );

    ref.read(configProvider.notifier).updateConfig(newConfig);

    if (mounted) {
      WFDialogConfirmWith2Operation(
        cancelStr: "不保存",
        ensureStr: "保存",
        context,
        "是否需要保存到本地?\n如果只是临时使用建议不用保存,\n网吧环境严禁保存到本地.\n" +
            "如果误点了保存,离开时记得回到这个页面点击\"清除本地数据\"按钮",
        () async {
          await LocalSave.saveConfig(newConfig);
          if (mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }

          ToastUtil.showNormal("保存成功");
        },
        onCancel: () {
          if (mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
      );
    }
  }
}
