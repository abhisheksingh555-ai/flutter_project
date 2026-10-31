class ItemModel {
  final int userId;
  final int id;
  final String title;
  final String body;

  const ItemModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  // JSON ko Dart object mein convert karega
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  // Dart object ko JSON mein convert karega
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'id': id, 'title': title, 'body': body};
  }
}
