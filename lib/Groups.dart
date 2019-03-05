Class Groups {
  final int count;


    Groups({this.count, this.id, this.title, this.body});

  factory Groups.fromJson(Map<String, dynamic> json) {
    return Groups(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
