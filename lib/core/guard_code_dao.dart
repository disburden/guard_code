import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guard_code/models/guard_code.dart';

class GuardCodeRepository {
  final SupabaseClient _supabase;
  String key;
  static const String tableName = 'guard_code';

  GuardCodeRepository(this._supabase, this.key);

  // 插入新记录
  Future<GuardCode> insert(GuardCode guardCode) async {
    try {
      final response = await _supabase
          .from(tableName)
          .insert(guardCode.toRow())
          .select()
          .single();

      return GuardCode.fromRow(response as Map<String, dynamic>, key);
    } catch (e) {
      throw Exception('Failed to insert guard code: $e');
    }
  }

  // 批量插入
  Future<List<GuardCode>> insertBatch(List<GuardCode> guardCodes) async {
    try {
      final rows = guardCodes.map((gc) => gc.toRow()).toList();
      final response = await _supabase.from(tableName).insert(rows).select();

      return (response as List)
          .map((row) => GuardCode.fromRow(row as Map<String, dynamic>, key))
          .toList();
    } catch (e) {
      throw Exception('Failed to insert batch guard codes: $e');
    }
  }

  // 根据ID查询
  Future<GuardCode?> findById(int id) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return GuardCode.fromRow(response as Map<String, dynamic>, key);
    } catch (e) {
      throw Exception('Failed to find guard code by id: $e');
    }
  }

  // 更新记录
  Future<GuardCode> update1(int id, GuardCode guardCode) async {
    try {
      final response = await _supabase
          .from(tableName)
          .update(guardCode.toRow())
          .eq('id', id)
          .select()
          .single();

      return GuardCode.fromRow(response, key);
    } catch (e) {
      throw Exception('Failed to update guard code: $e');
    }
  }

  // 更新记录
  Future<GuardCode> update(
    int id, {
    required int? tagId,
    required String project,
    required String account,
    String? logoUrl,
  }) async {
    try {
      // 构建仅包含需更新的 4 个字段的 Map（显式包含 null 值）
      final updateData = {
        'tag_id': tagId, // int? → 允许 null
        'project': project, // required String
        'account': account, // required String
        'logo_url': logoUrl, // String? → 允许 null
      };

      final response = await _supabase
          .from(tableName)
          .update(updateData)
          .eq('id', id)
          .select()
          .single();

      return GuardCode.fromRow(response, key);
      // return GuardCode.fromRow(response as Map<String, dynamic>, key);
    } catch (e) {
      throw Exception(
        'Failed to update guard code fields (tag_id, project, account, logo_url): $e',
      );
    }
  }

  // 更新部分字段
  Future<GuardCode> updatePartial(int id, Map<String, dynamic> updates) async {
    try {
      final response = await _supabase
          .from(tableName)
          .update(updates)
          .eq('id', id)
          .select()
          .single();

      return GuardCode.fromRow(response as Map<String, dynamic>, key);
    } catch (e) {
      throw Exception('Failed to update guard code partially: $e');
    }
  }

  // 删除记录
  Future<void> delete(int id) async {
    try {
      await _supabase.from(tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete guard code: $e');
    }
  }

  // 批量删除
  Future<void> deleteBatch(List<int> ids) async {
    // try {
    //   await _supabase.from(tableName).delete().any('id', ids);
    // } catch (e) {
    //   throw Exception('Failed to delete batch guard codes: $e');
    // }
  }

  // 软删除（更新state为0）
  Future<GuardCode> softDelete(int id) async {
    try {
      final response = await _supabase
          .from(tableName)
          .update({'state': 0})
          .eq('id', id)
          .select()
          .single();

      return GuardCode.fromRow(response as Map<String, dynamic>, key);
    } catch (e) {
      throw Exception('Failed to soft delete guard code: $e');
    }
  }

  // 查询所有有效记录（state = 1）
  Future<List<GuardCode>> findAllActive() async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('state', 1)
          .order('created_at', ascending: false);

      return (response as List)
          .map((row) => GuardCode.fromRow(row as Map<String, dynamic>, key))
          .toList();
    } catch (e) {
      throw Exception('Failed to find all active guard codes: $e');
    }
  }

  // 根据tag_id查询
  Future<List<GuardCode>> findByTagId(int tagId) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('tag_id', tagId)
          .eq('state', 1)
          .order('created_at', ascending: false);

      return (response as List)
          .map((row) => GuardCode.fromRow(row as Map<String, dynamic>, key))
          .toList();
    } catch (e) {
      throw Exception('Failed to find guard codes by tag id: $e');
    }
  }

  // 根据project查询
  Future<List<GuardCode>> findByProject(String project) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('project', project)
          .eq('state', 1)
          .order('created_at', ascending: false);

      return (response as List)
          .map((row) => GuardCode.fromRow(row as Map<String, dynamic>, key))
          .toList();
    } catch (e) {
      throw Exception('Failed to find guard codes by project: $e');
    }
  }

  // 根据account查询
  Future<List<GuardCode>> findByAccount(String account) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('account', account)
          .eq('state', 1)
          .order('created_at', ascending: false);

      return (response as List)
          .map((row) => GuardCode.fromRow(row as Map<String, dynamic>, key))
          .toList();
    } catch (e) {
      throw Exception('Failed to find guard codes by account: $e');
    }
  }

  // 分页查询
  Future<List<GuardCode>> findPaginated({
    required int page,
    required int pageSize,
    int? tagId,
    String? project,
    String? account,
  }) async {
    try {
      var query = _supabase.from(tableName).select().eq('state', 1);

      if (tagId != null) {
        query = query.eq('tag_id', tagId);
      }
      if (project != null) {
        query = query.eq('project', project);
      }
      if (account != null) {
        query = query.eq('account', account);
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(page * pageSize, (page + 1) * pageSize - 1);

      return (response as List)
          .map((row) => GuardCode.fromRow(row as Map<String, dynamic>, key))
          .toList();
    } catch (e) {
      throw Exception('Failed to find paginated guard codes: $e');
    }
  }

  // 统计记录数
  Future<int> count({int? tagId, String? project, String? account}) async {
    try {
      var query = _supabase.from(tableName).select();

      if (tagId != null) {
        query = query.eq('tag_id', tagId);
      }
      if (project != null) {
        query = query.eq('project', project);
      }
      if (account != null) {
        query = query.eq('account', account);
      }

      final response = await query;
      return (response as Map<String, dynamic>)['count'] as int;
    } catch (e) {
      throw Exception('Failed to count guard codes: $e');
    }
  }
}
