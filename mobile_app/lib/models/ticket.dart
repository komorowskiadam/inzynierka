import 'dart:convert';

class Ticket {
  final int id;
  final String eventName;
  final String status;
  final int? seatNumber;

  const Ticket(
      {required this.id,
      required this.eventName,
      required this.status,
      required this.seatNumber});

  factory Ticket.fromJson(Map<String, dynamic> data) {
    final codeUnits = data['eventName'].toString().codeUnits;
    String name = const Utf8Decoder().convert(codeUnits);

    return Ticket(
        id: data['id'],
        eventName: name,
        status: data['status'],
        seatNumber: data['seatNumber']);
  }
}
