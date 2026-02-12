import 'package:guard_code/models/tag.dart';
import 'package:guard_code/preload.dart';
import 'package:guard_code/public/style/app_button_style.dart';
import 'package:guard_code/public/style/style.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PageTags extends StatefulWidget {
  final List<Tag> tags; // 接收源列表

  const PageTags({super.key, required this.tags});

  @override
  PageTagsState createState() => PageTagsState();
}

class PageTagsState extends State<PageTags> {
  bool _isAsyncing = false;
  late List<Tag> _tags; // 内部维护的列表
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.tags); // 复制传入列表，避免直接修改widget.tags
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appColorStyle.scaffoldBackGroundColor,

      appBar: AppBar(
        title: const Text('标签管理'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _tags);
          },
        ),
        actions: [
          // IconButton(icon: const Icon(Icons.save), onPressed: _ontapSave),
        ],
      ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 账号
                  AppHelp.buildLabel('添加新标签：'),
                  Row(
                    children: [
                      Expanded(
                        child: AppHelp.buildInput(
                          hintText: "输入标签名称",
                          isPassword: false,
                          controller: _controller,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 90,
                        child: AppMainButton(text: "添加", onPressed: _ontapSave),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '当前标签：',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _tags.isEmpty
                      ? const Text(
                          '暂无标签，请添加。',
                          style: TextStyle(color: Colors.grey),
                        )
                      : Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: _tags.map((tag) {
                            return Chip(
                              label: Text(tag.name),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () => _ontapDeleteTag(tag),
                              backgroundColor: Theme.of(
                                context,
                              ).appColorStyle.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _doAddTag() async {
    final String newName = _controller.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('标签名称不能为空')));
      return;
    }

    // 简单去重检查（可选：也可以让数据库 unique constraint 处理）
    if (_tags.any((tag) => tag.name == newName)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('该标签已存在')));
      return;
    }

    // 插入到 Supabase
    setState(() {
      _isAsyncing = true;
    });
    try {
      // 插入到 Supabase
      final response = await Supabase.instance.client.from('tag').insert({
        'name': newName, // 必须字段
        // 'sort_order': 0, //
      }).select(); // ← 加上 .select() 可以拿到插入后的完整记录（包括自增 id）

      if (response.isNotEmpty) {
        // 拿到新插入的记录（response 是 List<Map>，通常取第一个）
        final newTagMap = response.first;
        final newTag = Tag(
          id: newTagMap['id'] as int, // 或 BigInt，如果是 bigint
          name: newTagMap['name'] as String,
          // 其他字段...
        );
        debugPrint('newTag: ${newTag.id}, ${newTag.name}');

        setState(() {
          _tags.add(newTag); // 本地列表刷新
        });

        _controller.clear();

        ToastUtil.showNormal('已添加标签：$newName');
      }
    } catch (error) {
      ToastUtil.showError('添加失败：$error');
    } finally {
      setState(() {
        _isAsyncing = false;
      });
    }
  }

  void _doDeleteTag(Tag tag) async {
    if (tag.id == 0) {
      ToastUtil.showError('不能删除该标签');
      return;
    }

    setState(() {
      _isAsyncing = true;
    });

    try {
      // await Supabase.instance.client.from('tag').delete().inFilter('id', [
      //   tag.id,
      // ]);
      await Supabase.instance.client.rpc(
        'delete_tag',
        params: {'p_tag_id': tag.id},
      );
      _tags.remove(tag);
      setState(() {});
    } catch (e) {
      DealErrorUtil.dealAppError(e);
    } finally {
      setState(() {
        _isAsyncing = false;
      });
    }
  }

  void _ontapDeleteTag(Tag tag) {
    WFDialogConfirmWith2Operation(
      context,
      "确定要删除标签 \"${tag.name}\" 吗？删除后之前关联的账号标签将为空",
      () async {
        _doDeleteTag(tag);
        if (mounted) {
          Navigator.pop(context);
        }
        // 先关闭确认框
      },
    );
  }

  void _ontapSave() {
    _doAddTag();
  }
}
