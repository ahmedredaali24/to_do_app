class Task {
  static const String collectionName = "tasks";
  String? id;
  String? title;
  String? description;
  DateTime? datetime;
  bool? isDone;

  Task(
      {this.id = "",
      required this.title,
      required this.description,
      required this.datetime,
      this.isDone = false});

  // json => object
  Task.fromJson(Map<String, dynamic> data)
      : this(
          id: data["id"] as String?,
          title: data["title"] as String?,
          description: data["description"] as String?,
          datetime: DateTime.fromMillisecondsSinceEpoch(data["dateTime"]),
          isDone: data["isDone"] as bool?,
        );

  // object => json
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "dateTime": datetime?.millisecondsSinceEpoch,
      "isDone": isDone
    };
  }
}
