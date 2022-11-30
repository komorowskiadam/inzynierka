class MyEvent {
  final int id;
  final String name;
  final int interestedCount;
  final int participantsCount;

  const MyEvent({
    required this.id,
    required this.name,
    required this.interestedCount,
    required this.participantsCount,
  });

  factory MyEvent.fromJson(Map<String, dynamic> json) {
    return MyEvent(
        id: json['id'],
        name: json['name'],
        interestedCount: json['interestedCount'],
        participantsCount: json['participantsCount']);
  }
}
