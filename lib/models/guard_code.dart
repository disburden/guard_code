// // lib/data/models/guard_code.dart

import 'package:guard_code/tools/app_help.dart';

class GuardCode {
  final int? id;
  final int? tagId;
  final String project;
  final String account;
  final String? memo;
  final String? logoUrl;
  final String guard;
  final int state;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GuardCode({
    this.id,
    this.tagId,
    required this.project,
    required this.account,
    this.memo,
    this.logoUrl,
    required this.guard,
    this.state = 1,
    this.createdAt,
    this.updatedAt,
  });

  // 从数据库行数据创建对象
  factory GuardCode.fromRow(Map<String, dynamic> row, String key) {
    return GuardCode(
      id: row['id'] as int?,
      tagId: row['tag_id'] as int?,
      project: row['project'] as String,
      account: row['account'] as String,
      memo: row['memo'] as String?,
      logoUrl: row['logo_url'] as String?,
      guard: AppHelp.jiemi(row['guard'] as String, key),
      state: row['state'] as int,
      createdAt: row['created_at'] != null
          ? DateTime.parse(row['created_at'].toString())
          : null,
      updatedAt: row['updated_at'] != null
          ? DateTime.parse(row['updated_at'].toString())
          : null,
    );
  }

  // 转换为数据库行数据
  Map<String, dynamic> toRow() {
    return {
      if (tagId != null) 'tag_id': tagId,
      'project': project,
      'account': account,
      if (memo != null) 'memo': memo,
      if (logoUrl != null) 'logo_url': logoUrl,
      'guard': guard,
      'state': state,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // 复制并更新部分字段
  GuardCode copyWith({
    int? tagId,
    String? project,
    String? account,
    String? alias,
    String? logoUrl,
    String? guard,
    String? memo,
    int? state,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GuardCode(
      id: id,
      tagId: tagId ?? this.tagId,
      project: project ?? this.project,
      account: account ?? this.account,
      memo: memo ?? this.memo,
      logoUrl: logoUrl ?? this.logoUrl,
      guard: guard ?? this.guard,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
