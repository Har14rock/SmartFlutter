class Transaction {
  final String? id;
  final String? title;
  final String? description;
  final double? amount;
  final String? type;
  final String? category;
  final String? imageUrl;
  final DateTime? date;

  Transaction({
    this.id,
    this.title,
    this.description,
    this.amount,
    this.type,
    this.category,
    this.imageUrl,
    this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? json['id'],
      title: json['title'],
      description: json['description'],
      amount: (json['amount'] as num?)?.toDouble(),
      type: json['type'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      date: DateTime.tryParse(json['date'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'type': type,
      'category': category,
      'imageUrl': imageUrl,
      'date': date?.toIso8601String(),
    };
  }
}
