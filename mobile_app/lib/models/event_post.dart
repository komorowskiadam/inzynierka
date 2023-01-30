class EventPost {
  final int id;
  final String content;
  final String author;
  final String stringDate;
  final List<int> likes;
  var date;

  EventPost(
      {required this.id,
      required this.content,
      required this.author,
      required this.stringDate,
      required this.likes}) {
    var num = int.parse(stringDate);
    date = DateTime.fromMillisecondsSinceEpoch(num);
  }

  factory EventPost.fromJson(Map<String, dynamic> json) {
    return EventPost(
      id: json['id'],
      author: json['author'],
      content: json['content'],
      stringDate: json['date'],
      likes: json['likes'].cast<int>(),
    );
  }
}
