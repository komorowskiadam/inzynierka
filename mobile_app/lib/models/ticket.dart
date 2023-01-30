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
    return Ticket(
        id: data['id'],
        eventName: data['eventName'],
        status: data['status'],
        seatNumber: data['seatNumber']);
  }
}
