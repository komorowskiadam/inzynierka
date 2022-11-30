import 'dart:convert';

import 'package:mobile_app/models/ticket_pool.dart';

class MyEventDetails {
  final int id;
  final String name;
  final String description;
  final List<TicketPool> ticketPools;

  const MyEventDetails(
      {required this.id,
      required this.name,
      required this.description,
      required this.ticketPools});

  factory MyEventDetails.fromJson(Map<String, dynamic> data) {
    return MyEventDetails(
        id: data['id'],
        name: data['name'],
        ticketPools: List<TicketPool>.from(
            data['ticketPools'].map((t) => TicketPool.fromJson(t))),
        description: "");
  }
}
