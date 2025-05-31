class Category {
  final String? id;
  final String? name;
  final String? color;

  Category({this.id, this.name, this.color});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color,
    };
  }
}
