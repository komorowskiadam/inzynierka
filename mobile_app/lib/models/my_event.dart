import 'dart:convert';

class MyEvent {
  final int id;
  final String name;
  final int interestedCount;
  final int participantsCount;
  final List<int> likes;
  final int? imageId;
  final DateTime dateTimeStart;
  final DateTime? dateTimeEnd;
  final String location;
  final String category;

  MyEvent(
      {required this.id,
      required this.name,
      required this.interestedCount,
      required this.participantsCount,
      required this.likes,
      required this.imageId,
      required this.dateTimeStart,
      required this.dateTimeEnd,
      required this.location,
      required this.category});

  factory MyEvent.fromJson(Map<String, dynamic> json) {
    final codeUnits = json['name'].toString().codeUnits;
    String name = const Utf8Decoder().convert(codeUnits);

    DateTime start =
        DateTime.parse(json['dateStart'] + " " + json['timeStart']);

    DateTime? end;

    String? dateEnd = json['dateEnd'];
    String? timeEnd = json['timeEnd'];

    if (dateEnd != null &&
        timeEnd != null &&
        dateEnd.length > 1 &&
        timeEnd.length > 1) {
      end = DateTime.parse("$dateEnd $timeEnd");
    }

    final codeUnits3 = json['location'].toString().codeUnits;
    String location = const Utf8Decoder().convert(codeUnits3);

    return MyEvent(
        id: json['id'],
        name: name,
        interestedCount: json['interestedCount'],
        participantsCount: json['participantsCount'],
        likes: json['likes'].cast<int>(),
        imageId: json['imageId'],
        location: location,
        dateTimeStart: start,
        dateTimeEnd: end,
        category: json['category']);
  }
}
