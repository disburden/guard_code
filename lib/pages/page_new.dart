import "package:dropdown_search/dropdown_search.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:guard_code/core/guard_code_server.dart";
import "package:guard_code/models/guard_code.dart";
import "package:guard_code/models/tag.dart";
import "package:guard_code/preload.dart";
import "package:guard_code/public/define.dart";
import "package:guard_code/public/style/style.dart";
import 'package:supabase_flutter/supabase_flutter.dart';
import "package:wgq_dart/wgq_dart.dart";

// ignore: must_be_immutable
class PageNew extends ConsumerStatefulWidget {
  List<Tag> tags = [];
  GuardCode? guardCode;
  NewGuradCodeDelegate? delegate;

  PageNew({super.key, required this.tags, this.delegate, this.guardCode});

  @override
  ConsumerState createState() => _PageNewState();
}

class _PageNewState extends ConsumerState<PageNew> {
  bool _isAsyncing = false;
  bool _isEdit = false;

  final _projectController = TextEditingController();
  final _accountController = TextEditingController();
  final _guardController = TextEditingController();
  final _memoController = TextEditingController();
  final _logoUrlController = TextEditingController();

  final dropDownKey = GlobalKey<DropdownSearchState<PopupMode>>();

  final supabase = Supabase.instance.client;
  late GuardCodeService guardCodeService;

  Tag? _selectedTag;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.guardCode != null;
    debugPrint('tags0000000: ${widget.tags.length}');
    if (WDDataType.isAir(widget.tags) == false) {
      if (_isEdit) {
        _projectController.text = widget.guardCode!.project;
        _accountController.text = widget.guardCode!.account;
        _guardController.text = widget.guardCode!.guard;
        _memoController.text = widget.guardCode!.memo ?? '';
        _logoUrlController.text = widget.guardCode!.logoUrl ?? '';
        _selectedTag = widget.tags.firstWhere(
          (tag) => tag.id == widget.guardCode!.tagId,
        );
      } else {
        _selectedTag = widget.tags.last;
      }
    }
    final config = ref.read(configProvider).requireValue;
    guardCodeService = GuardCodeService(supabase, config.zhongyao);
  }

  @override
  dispose() {
    _projectController.dispose();
    _accountController.dispose();
    _guardController.dispose();
    _memoController.dispose();
    _logoUrlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? "编辑" : "新增")),
      backgroundColor: Theme.of(context).appColorStyle.scaffoldBackGroundColor,
      body: ModalProgressHUD(
        opacity: 0,
        inAsyncCall: _isAsyncing,
        child: _buildMainBody(),
      ),
    );
  }

  Widget _buildMainBody() {
    if (WDDataType.isAir(widget.tags)) {
      debugPrint('tags是空的');
      return WFWidgetUtils.noDataWidget(
        hintString: "请先到\"基础设置\"中完善基础信息",
        icon: Icons.settings,
      );
    }
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
                  // 项目名称
                  AppHelp.buildLabel('项目名称'),
                  AppHelp.buildInput(
                    hintText: '请输入项目名称',
                    isPassword: false,
                    controller: _projectController,
                  ),
                  const SizedBox(height: 24),

                  // 账号
                  AppHelp.buildLabel('账号'),
                  AppHelp.buildInput(
                    hintText: '请输入账号',
                    isPassword: false,
                    controller: _accountController,
                  ),
                  const SizedBox(height: 16),

                  //校验码
                  if (!_isEdit) ...[
                    AppHelp.buildLabel('校验码'),
                    AppHelp.buildInput(
                      hintText: '请输入校验码',
                      isPassword: false,
                      controller: _guardController,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Logo URL
                  AppHelp.buildLabel('Logo URL'),
                  AppHelp.buildInput(
                    hintText: '请输入Logo URL',
                    isPassword: false,
                    controller: _logoUrlController,
                  ),
                  AppHelp.buildTips("支持svg格式图片"),
                  const SizedBox(height: 24),

                  // 选择标签
                  AppHelp.buildLabel('TAG'),
                  DropdownSearch<Tag>(
                    key: dropDownKey,
                    selectedItem: _selectedTag,
                    itemAsString: (Tag? tag) => tag?.name ?? '未选择',
                    compareFn: (i1, i2) => i1 == i2,
                    items: (String? filter, LoadProps? _) => widget.tags,
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFDDDDDD),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFDDDDDD),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF9EB69D),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    popupProps: PopupProps.menu(
                      fit: FlexFit.loose,
                      constraints: BoxConstraints(),
                    ),
                    onChanged: (Tag? newValue) {
                      setState(() {
                        _selectedTag = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  // 保存按钮
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

  void _doCleanInputerText() {
    _projectController.text = '';
    _accountController.text = '';
    _guardController.text = '';
    _logoUrlController.text = '';
    _memoController.text = '';
    _selectedTag = null;
  }

  void _doCreateNewGuardCode() async {
    final trimGuard = _guardController.text.replaceAll(RegExp(r'\s+'), '');
    final config = ref.read(configProvider).requireValue;
    final finalGuard = AppHelp.jiami(trimGuard, config.zhongyao);

    _isAsyncing = true;
    setState(() {});
    try {
      await guardCodeService.createGuardCode(
        project: _projectController.text,
        account: _accountController.text,
        guard: finalGuard,
        tagId: _selectedTag?.id,
        memo: _memoController.text,
        logoUrl: _logoUrlController.text.isNotEmpty
            ? _logoUrlController.text
            : null,
      );

      if (widget.delegate != null) {
        widget.delegate!.needRefresh();
      }
      if (mounted) {
        WFDialogConfirmWith2Operation(
          context,
          "创建成功,是否需要继续创建新的护卫码",
          () {
            if (mounted) {
              Navigator.of(context).pop();
            }
            _doCleanInputerText();
          },
          onCancel: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      }
    } catch (e) {
      DealErrorUtil.dealAppError(e);
    } finally {
      _isAsyncing = false;
      setState(() {});
    }
  }

  void _doUpdateGuardCode() async {
    final paraId = widget.guardCode!.id;
    final paraTagId = _selectedTag?.id;
    final paraProject = _projectController.text;
    final paraAccount = _accountController.text;
    final paraLogoUrl = _logoUrlController.text.isNotEmpty
        ? _logoUrlController.text
        : null;

    _isAsyncing = true;
    setState(() {});

    try {
      await guardCodeService.updateGuardCode(
        paraId!,
        tagId: paraTagId,
        project: paraProject,
        account: paraAccount,
        logoUrl: paraLogoUrl,
      );
      if (widget.delegate != null) {
        widget.delegate!.needRefresh();
      }
      ToastUtil.showNormal("修改成功!");
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      DealErrorUtil.dealAppError(e);
    } finally {
      _isAsyncing = false;
      setState(() {});
    }
  }

  void _ontapSave() async {
    if (_projectController.text.isEmpty ||
        _accountController.text.isEmpty ||
        _guardController.text.isEmpty) {
      ToastUtil.showError('错误!请填写完整信息');
      return;
    }

    if (_isEdit) {
      // 编辑模式
      _doUpdateGuardCode();
    } else {
      // 新增模式
      _doCreateNewGuardCode();
    }
  }
}

abstract class NewGuradCodeDelegate {
  void needRefresh();
}
