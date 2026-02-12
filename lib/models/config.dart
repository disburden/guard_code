class Config {
  String zhongyao;
  String supabaseUrl;
  String supabaseKey;

  Config({
    required this.zhongyao,
    required this.supabaseUrl,
    required this.supabaseKey,
  });

  // fromJson 方法：将 JSON 转换为 Config 对象
  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      zhongyao: json['zhongyao'] as String,
      supabaseUrl: json['supabaseUrl'] as String,
      supabaseKey: json['supabaseKey'] as String,
    );
  }

  // 安全版本的 fromJson，提供默认值
  factory Config.fromJsonSafe(Map<String, dynamic> json) {
    return Config(
      zhongyao: json['zhongyao']?.toString() ?? '',
      supabaseUrl: json['supabaseUrl']?.toString() ?? '',
      supabaseKey: json['supabaseKey']?.toString() ?? '',
    );
  }

  // 带验证的 fromJson
  factory Config.fromJsonWithValidation(Map<String, dynamic> json) {
    final zhongyao = json['zhongyao'];
    final supabaseUrl = json['supabaseUrl'];
    final supabaseKey = json['supabaseKey'];

    if (zhongyao is! String || zhongyao.isEmpty) {
      throw FormatException('zhongyao 字段不能为空');
    }
    if (supabaseUrl is! String || supabaseUrl.isEmpty) {
      throw FormatException('supabaseUrl 字段不能为空');
    }
    if (supabaseKey is! String || supabaseKey.isEmpty) {
      throw FormatException('supabaseKey 字段不能为空');
    }

    return Config(
      zhongyao: zhongyao,
      supabaseUrl: supabaseUrl,
      supabaseKey: supabaseKey,
    );
  }

  // toJson 方法：将 Config 对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'zhongyao': zhongyao,
      'supabaseUrl': supabaseUrl,
      'supabaseKey': supabaseKey,
    };
  }

  // 复制方法，便于创建修改后的副本
  Config copyWith({
    String? zhongyao,
    String? supabaseUrl,
    String? supabaseKey,
  }) {
    return Config(
      zhongyao: zhongyao ?? this.zhongyao,
      supabaseUrl: supabaseUrl ?? this.supabaseUrl,
      supabaseKey: supabaseKey ?? this.supabaseKey,
    );
  }

  // 默认配置工厂方法
  factory Config.defaultConfig() {
    return Config(zhongyao: '', supabaseUrl: '', supabaseKey: '');
  }

  // 检查配置是否有效
  bool isValid() {
    return zhongyao.isNotEmpty &&
        supabaseUrl.isNotEmpty &&
        supabaseKey.isNotEmpty;
  }

  // 重写 toString 方法，便于调试
  @override
  String toString() {
    return 'Config(zhongyao: $zhongyao, supabaseUrl: $supabaseUrl, supabaseKey: $supabaseKey)';
  }

  // 重写 equals 和 hashCode 方法，便于比较对象
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Config &&
        other.zhongyao == zhongyao &&
        other.supabaseUrl == supabaseUrl &&
        other.supabaseKey == supabaseKey;
  }

  @override
  int get hashCode =>
      zhongyao.hashCode ^ supabaseUrl.hashCode ^ supabaseKey.hashCode;
}
