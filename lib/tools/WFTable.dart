import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:guard_code/preload.dart';
import 'package:guard_code/public/style/style.dart'; // 新增导入

/// 通用 Web 表格组件（支持左滑菜单）
class WFTable<T> extends StatelessWidget {
  final List<String> headers;
  final List<T> data;
  final List<FlexColumnWidth> columnWidths;
  final List<Widget> Function(T row) rowBuilder;
  final List<SlideMenuAction<T>> Function(T row, int idx)?
  slideMenuBuilder; // 可选
  final void Function(T row)? onRowTap;
  final void Function(T row, int idx)? onRowDoubleTap;
  final void Function(int idx)? onHeadTap;

  const WFTable({
    super.key,
    required this.headers,
    required this.data,
    required this.columnWidths,
    required this.rowBuilder,
    this.slideMenuBuilder,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onHeadTap,
  });

  @override
  Widget build(BuildContext context) {
    assert(headers.length == columnWidths.length);

    final Map<int, TableColumnWidth> widths = {
      for (int i = 0; i < columnWidths.length; i++) i: columnWidths[i],
    };

    return SlidableAutoCloseBehavior(
      child: Column(
        children: [
          // 表头（不变）
          Table(
            columnWidths: widths,
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Theme.of(context).appColorStyle.primaryColor,
                ),
                children: [
                  ...headers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final header = entry.value;
                    return _HeaderCell(header, index, onHeadTap: onHeadTap);
                  }),
                  // .toList(growable: false),
                  // ...headers.map((h) => _HeaderCell(h)).toList(growable: false),
                ],
              ),
            ],
          ),
          // 数据区
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final row = data[index];
                final hasMenu = slideMenuBuilder != null;

                // 无菜单：普通行
                if (!hasMenu || slideMenuBuilder!(row, index).isEmpty) {
                  return _HoverRow(
                    index: index,
                    columnWidths: widths,
                    cells: rowBuilder(row),
                    onTap: onRowTap == null ? null : () => onRowTap!(row),
                    onDoubleTap: onRowDoubleTap == null
                        ? null
                        : () => onRowDoubleTap!(row, index),
                  );
                }

                // 有菜单：用 Slidable 包裹
                return Slidable(
                  key: Key('row-$index'),
                  groupTag: 'wf-table-group',
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(), // 滑动动画
                    extentRatio: 0.3,
                    children: slideMenuBuilder!(row, index)
                        .map(
                          (action) => _SlideAction(
                            icon: action.icon,
                            color: action.color ?? const Color(0xFFff6b6b),
                            label: action.label,
                            onPressed: () => action.onPressed(row),
                          ),
                        )
                        .toList(),
                  ),
                  child: _HoverRow(
                    index: index,
                    columnWidths: widths,
                    cells: rowBuilder(row),
                    onTap: onRowTap == null ? null : () => onRowTap!(row),
                    onDoubleTap: onRowDoubleTap == null
                        ? null
                        : () => onRowDoubleTap!(row, index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 菜单动作定义（保持不变）
class SlideMenuAction<T> {
  final Widget icon;
  final Color? color;
  final String? label;
  final void Function(T row) onPressed;

  const SlideMenuAction({
    required this.icon,
    this.color,
    this.label,
    required this.onPressed,
  });
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int index;
  final void Function(int idx)? onHeadTap;
  const _HeaderCell(this.text, this.index, {this.onHeadTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: GestureDetector(
        onTap: () => {
          // debugPrint('header: $text, index: $index')
          if (onHeadTap != null) {onHeadTap!(index)},
        },
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// 滑动菜单项
class _SlideAction extends StatelessWidget {
  final Widget icon;
  final Color color;
  final String? label;
  final VoidCallback onPressed;

  const _SlideAction({
    required this.icon,
    required this.color,
    this.label,
    required this.onPressed,
  });

  // @override
  // Widget build(BuildContext context) {
  //   return SlidableAction(
  //     onPressed: (_) => onPressed(),
  //     backgroundColor: color,
  //     foregroundColor: Colors.white,
  //     icon: (icon is Icon) ? (icon as Icon).icon : Icons.menu,
  //     label: label,
  //     spacing: 0,
  //     flex: 60,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      onPressed: (_) => onPressed(),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          if (label != null) ...[
            const SizedBox(width: 6),
            Text(label!, style: const TextStyle(color: Colors.white)),
          ],
        ],
      ),
    );
  }
}

// 保持原有 HoverRow 逻辑（简化版，移除菜单相关）
class _HoverRow extends StatefulWidget {
  final int index;
  final Map<int, TableColumnWidth> columnWidths;
  final List<Widget> cells;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;

  const _HoverRow({
    required this.index,
    required this.columnWidths,
    required this.cells,
    this.onTap,
    this.onDoubleTap,
  });

  @override
  State<_HoverRow> createState() => _HoverRowState();
}

class _HoverRowState extends State<_HoverRow> {
  bool hovering = false;

  void _setHover(bool value) {
    if (!mounted) return;
    setState(() => hovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEven = widget.index.isEven;
    final Color bgColor = hovering
        ? const Color(0xffE1938E)
        : isEven
        ? Colors.white
        : const Color(0xFFd9fff2);

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        behavior: HitTestBehavior.opaque,
        child: Table(
          columnWidths: widget.columnWidths,
          children: [
            TableRow(
              decoration: BoxDecoration(color: bgColor),
              children: widget.cells
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: c,
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}
