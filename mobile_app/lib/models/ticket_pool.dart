class TicketPool {
  final int id;
  final String name;
  final int availableTickets;
  final String status;

  const TicketPool(
      {required this.id,
      required this.name,
      required this.availableTickets,
      required this.status});

  factory TicketPool.fromJson(Map<String, dynamic> json) {
    return TicketPool(
        id: json['id'],
        name: json['name'],
        availableTickets: json['availableTickets'],
        status: json['status']);
  }
}

enum TicketPoolStatus { ACTIVE, INACTIVE, SOLD_OUT }
