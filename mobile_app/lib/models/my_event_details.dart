import 'dart:convert';

import 'package:mobile_app/models/ticket_pool.dart';

import 'event_post.dart';

class MyEventDetails {
  final int id;
  final String name;
  final String description;
  final List<TicketPool> ticketPools;
  final List<int> interested;
  final List<int> participants;
  final List<EventPost> posts;
  final String dateStart;
  final String timeStart;
  final String? dateEnd;
  final String? timeEnd;
  final int? imageId;
  final String location;

  const MyEventDetails(
      {required this.id,
      required this.name,
      required this.description,
      required this.ticketPools,
      required this.interested,
      required this.participants,
      required this.posts,
      required this.dateStart,
      required this.timeStart,
      required this.dateEnd,
      required this.timeEnd,
      required this.imageId,
      required this.location});

  factory MyEventDetails.fromJson(Map<String, dynamic> data) {
    final codeUnits = data['description'].toString().codeUnits;
    String description = const Utf8Decoder().convert(codeUnits);
    final codeUnits2 = data['name'].toString().codeUnits;
    String name = const Utf8Decoder().convert(codeUnits2);
    final codeUnits3 = data['location'].toString().codeUnits;
    String location = const Utf8Decoder().convert(codeUnits3);
    return MyEventDetails(
        id: data['id'],
        name: name,
        ticketPools: List<TicketPool>.from(
            data['ticketPools'].map((t) => TicketPool.fromJson(t))),
        description: description,
        interested: data['interested'].cast<int>(),
        participants: data['participants'].cast<int>(),
        posts: List<EventPost>.from(
            data['posts'].map((p) => EventPost.fromJson(p))),
        dateStart: data['dateStart'],
        timeStart: data['timeStart'],
        dateEnd: data['dateEnd'],
        timeEnd: data['timeEnd'],
        imageId: data['imageId'],
        location: location);
  }
}
