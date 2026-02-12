import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guard_code/core/guard_code_server.dart';
import 'package:guard_code/models/config.dart';
import 'package:guard_code/models/guard_code.dart';
import 'package:guard_code/models/tag.dart';
import 'package:guard_code/pages/page_new.dart';
import 'package:guard_code/pages/page_setting.dart';
import 'package:guard_code/pages/page_tags.dart';
import 'package:guard_code/preload.dart';
import 'package:guard_code/public/style/app_button_style.dart';
import 'package:guard_code/public/style/style.dart';
import 'dart:async';

import 'package:guard_code/tools/WFTable.dart';

import '../public/define.dart';

class PageHome extends ConsumerStatefulWidget {
  const PageHome({super.key});

  @override
  ConsumerState<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends ConsumerState<PageHome>
    implements NewGuradCodeDelegate {
  final WFPopupMenuController _wpopController = WFPopupMenuController();
  late WFPopupMenu _wgqPopmenu;

  Timer? _timer;
  final _count = 30;
  int remainingSeconds = 0;

  List<GuardCode> _guardCodeList = [];
  List<Tag> _tagList = [];

  Future? _future;

  // final supabase = Supabase.instance.client;

  late GuardCodeService guardCodeService;
  int _currentTagId = -1;

  Tag? _selectedTag;

  final dropDownKey = GlobalKey<DropdownSearchState<PopupMode>>();

  @override
  void initState() {
    super.initState();
    final config = ref.read(configProvider).requireValue;
    final supabase = ref.read(supabaseClientProvider);
    guardCodeService = GuardCodeService(supabase, config.zhongyao);
    _future = _doLoadData();
    _doGainTags();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        // 重要：检查组件是否还在挂载状态
        if (mounted) {
          remainingSeconds = getRemainingSeconds();
          setState(() {});
        } else {
          timer.cancel(); // 组件已卸载，取消定时器
        }
      });
    });
  }

  @override
  void dispose() {
    _future = null;
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _doCreatePopmenu();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<Config>>(configProvider, (previous, next) {
      next.maybeWhen(
        data: (config) {
          debugPrint('监听到config变化');
          _doRefresh();
        },
        orElse: () {
          // 可选：处理加载或错误状态
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('护卫码'),
        actions: [
          SizedBox(width: 120, height: 40, child: _buildDropDownMenu()),
          Padding(padding: EdgeInsets.only(right: 16)),
          SizedBox(
            width: 90,
            height: 40,
            child: AppMainButton(text: "新增", onPressed: _ontapNewAddr),
          ),

          Padding(padding: EdgeInsets.only(right: 16)),
          IconButton(onPressed: _ontapSetting, icon: Icon(Icons.settings)),
          _wgqPopmenu,
          Padding(padding: EdgeInsets.only(right: 16)),
          SizedBox(
            width: 30,
            child: Text(
              "$remainingSeconds",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: remainingSeconds < 10
                    ? Theme.of(context).appColorStyle.emphasisColorMain
                    : Colors.white,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 16)),
        ],
      ),

      body: _builMainBody(),
    );
  }

  Widget _builMainBody() {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            {
              if (snapshot.hasError) {
                return _buildLoadErrorView();
              } else {
                return _buildContentView();
              }
            }
          case ConnectionState.none:
            return WFWidgetUtils.noDataWidget();
          case ConnectionState.waiting:
          case ConnectionState.active:
            return AppHelp.jh();
        }
      },
    );
  }

  Widget _buildLoadErrorView() {
    return WFWidgetUtils.buildFutureView(
      cb: () {
        _doLoadData();
      },
      type: FutureViewType.error,
    );
  }

  Widget _buildContentView() {
    return WFTable<GuardCode>(
      headers: const ['图标', '账号', '护卫码', '备注'],
      columnWidths: const [
        FlexColumnWidth(1),
        FlexColumnWidth(3),
        FlexColumnWidth(4),
        FlexColumnWidth(2),
      ],
      data: _guardCodeList,
      rowBuilder: (row) => [
        Align(
          alignment: Alignment.centerLeft,
          child: AppHelp.urlImage(row.logoUrl),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(row.account, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(row.project),
          ],
        ),
        Text(
          AppHelp.gainCode(row.guard),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(row.memo ?? ""),
      ],
      onRowDoubleTap: (row, idx) {
        Clipboard.setData(ClipboardData(text: AppHelp.gainCode(row.guard)));
        ToastUtil.showNormal("复制成功!");
      },
      slideMenuBuilder: (guardcode, idx) => [
        SlideMenuAction<GuardCode>(
          icon: const Icon(Icons.edit, color: Colors.white),
          color: const Color(0xFF4ecdc4),
          label: '编辑',
          onPressed: (addr) {
            _ontapSliderItemEdit(guardcode, idx);
          },
        ),
        SlideMenuAction<GuardCode>(
          icon: const Icon(Icons.delete, color: Colors.white),
          color: const Color(0xFFff6b6b),
          label: '删除',
          onPressed: (addr) {
            _ontapSliderItemDelete(addr, idx);
          },
        ),
      ],
    );
  }

  Widget _buildDropDownMenu() {
    return DropdownSearch<Tag>(
      key: dropDownKey,
      selectedItem: _selectedTag,
      itemAsString: (Tag? tag) => tag?.name ?? '未选择',
      compareFn: (i1, i2) => i1 == i2,
      items: (String? filter, LoadProps? _) => _displayTags,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 14,
          ),
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
        ),
      ),
      popupProps: PopupProps.menu(
        fit: FlexFit.loose,
        constraints: BoxConstraints(),
      ),
      onChanged: (Tag? newValue) {
        setState(() {
          _currentTagId = newValue?.id ?? -1;
          _future = _doLoadData();
        });
        // print("選擇了: ${newValue?.name} (id: ${newValue?.id})");
      },
    );
  }

  void _doCreatePopmenu() {
    _wgqPopmenu = WFPopupMenu(
      _doCreatePopmenuItems(),
      controller: _wpopController,
      backgroundColor: Theme.of(context).appColorStyle.primaryColor,
      onSelected: _ontapPopMenuItem,
    );
  }

  Future<void> _doLoadData() async {
    try {
      if (_currentTagId == -1) {
        final result = await guardCodeService.gainAllActive();
        _guardCodeList = result;
      } else {
        final result = await guardCodeService.getGuardCodesByTag(_currentTagId);
        _guardCodeList = result;
      }
      setState(() {});
    } catch (e) {
      DealErrorUtil.dealAppError(e);
    }
  }

  Future<bool> _doGainTags() async {
    debugPrint('开始获取tag列表');

    try {
      final supabase = ref.read(supabaseClientProvider);
      final response = await supabase
          .from('tag')
          .select()
          .order('sort_order', ascending: true);

      _tagList = (response as List)
          .map((row) => Tag.fromRow(row as Map<String, dynamic>))
          .toList();
      _selectedTag = _displayTags.first;

      setState(() {});
      return true;
    } catch (e) {
      DealErrorUtil.dealAppError(e);
      return false;
      // throw Exception('获取tag失败: $e');
    }
  }

  List<PopupMenuEntry<String>> _doCreatePopmenuItems() {
    return <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(value: 'setting', child: Text('基本设置')),
      const PopupMenuItem<String>(value: 'tags', child: Text('标签管理')),
    ];
  }

  void _doRefresh() async {
    final config = ref.read(configProvider).requireValue;
    final supabase = ref.read(supabaseClientProvider);
    guardCodeService = GuardCodeService(supabase, config.zhongyao);
    debugPrint('zhongyao: ${config.zhongyao}');
    await _doGainTags();
    _future = _doLoadData();
  }

  List<Tag> get _displayTags {
    // 创建副本并添加“全部”（放在首位，便于UI显示）
    return [Tag(id: -1, name: '全部'), ..._tagList];
  }

  void _ontapPopMenuItem(dynamic value) {
    switch (value) {
      case 'setting':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => PageSetting()),
        );
        break;
      case 'tags':
        Navigator.of(context)
            .push<List<Tag>>(
              MaterialPageRoute(
                builder: (BuildContext context) => PageTags(tags: _tagList),
              ),
            )
            .then((updatedTags) {
              if (updatedTags != null) {
                setState(() {
                  _tagList = updatedTags;
                });
              }
            });
        break;
      default:
        break;
    }
  }

  void _ontapNewAddr() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            PageNew(tags: _tagList, delegate: this),
      ),
    );
  }

  void _ontapSetting() async {
    _wpopController.showMenu();
  }

  void _ontapSliderItemEdit(GuardCode guardCode, int idx) {
    debugPrint('will edit: ${guardCode.account}');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            PageNew(tags: _tagList, delegate: this, guardCode: guardCode),
      ),
    );
  }

  void _ontapSliderItemDelete(GuardCode guardCode, int idx) {
    WFDialogConfirmWith2Operation(context, "确定删除吗?", () {
      guardCodeService.deleteGuardCode(guardCode.id!).then((_) {
        _doLoadData();
      });
      Navigator.of(context).pop();
    });
  }

  int getRemainingSeconds() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return _count - (now % _count);
  }

  @override
  void needRefresh() {
    _doLoadData();
  }
}
