import 'package:supabase_flutter/supabase_flutter.dart';
import 'guard_code_dao.dart';
import 'package:guard_code/models/guard_code.dart';

class GuardCodeService {
  final GuardCodeRepository _repository;
  String key;

  GuardCodeService(SupabaseClient supabase, this.key)
    : _repository = GuardCodeRepository(supabase, key);

  // 创建新的guard code
  Future<GuardCode> createGuardCode({
    required String project,
    required String account,
    required String guard,
    int? tagId,
    String? memo,
    String? logoUrl,
  }) async {
    final guardCode = GuardCode(
      project: project,
      account: account,
      guard: guard,
      tagId: tagId,
      memo: memo,
      logoUrl: logoUrl,
    );
    return await _repository.insert(guardCode);
  }

  // 更新guard code
  Future<GuardCode> updateGuardCode1(int id, GuardCode guardCode) async {
    return await _repository.update1(id, guardCode);
  }

  Future<GuardCode> updateGuardCode(
    int id, {
    required int? tagId,
    required String project,
    required String account,
    String? logoUrl,
  }) async {
    return await _repository.update(
      id,
      tagId: tagId,
      project: project,
      account: account,
      logoUrl: logoUrl,
    );
  }

  // 删除guard code
  Future<void> deleteGuardCode(int id) async {
    await _repository.delete(id);
  }

  // 软删除
  Future<void> softDeleteGuardCode(int id) async {
    await _repository.softDelete(id);
  }

  // 根据tag查询
  Future<List<GuardCode>> getGuardCodesByTag(int tagId) async {
    return await _repository.findByTagId(tagId);
  }

  // 获取所有的guard code
  Future<List<GuardCode>> gainAllActive() async {
    return await _repository.findAllActive();
  }

  // 分页查询
  Future<List<GuardCode>> getGuardCodesPage({
    required int page,
    required int pageSize,
    int? tagId,
    String? project,
    String? account,
  }) async {
    return await _repository.findPaginated(
      page: page,
      pageSize: pageSize,
      tagId: tagId,
      project: project,
      account: account,
    );
  }
}
