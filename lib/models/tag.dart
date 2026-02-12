class Tag {
  final int id;
  final String name;
  final String color;
  final int sortOrder;
  final DateTime? createdAt;

  Tag({
    required this.id,
    required this.name,
    this.color = '#95a5a6',
    this.sortOrder = 0,
    this.createdAt,
  });

  factory Tag.fromRow(Map<String, dynamic> row) {
    return Tag(
      id: row['id'] as int,
      name: row['name'] as String,
      color: row['color'] as String? ?? '#95a5a6',
      sortOrder: row['sort_order'] as int? ?? 0,
      createdAt: row['created_at'] != null
          ? DateTime.parse(row['created_at'].toString())
          : null,
    );
  }
}
