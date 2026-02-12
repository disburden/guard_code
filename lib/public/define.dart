import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guard_code/models/config.dart';
import 'package:guard_code/tools/local_save.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: constant_identifier_names
const SERVER_HOST = "";
// ignore: constant_identifier_names
const DEFAULT_LOGO_URL =
    "https://images.najie.eu.org/img/guardcode/guardcode256_bw.png";

final configProvider = AsyncNotifierProvider<ConfigNotifier, Config>(
  ConfigNotifier.new,
);

class ConfigNotifier extends AsyncNotifier<Config> {
  @override
  Future<Config> build() async {
    return await LocalSave.gainConfig();
  }

  void updateConfig(Config config) {
    state = AsyncData(config);
  }
}

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  final config = ref.watch(configProvider).requireValue;

  return SupabaseClient(config.supabaseUrl, config.supabaseKey);
});
