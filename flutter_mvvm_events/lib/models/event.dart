class Event {
  String id;
  String name;
  String description;
  String imageUrl;

  Event({required this.id, required this.name, required this.description, required this.imageUrl});

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json['_id'],
    name: json['name'],
    description: json['description'],
    imageUrl: json['imageUrl'],
  );
}
