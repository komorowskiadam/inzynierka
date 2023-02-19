import 'dart:developer';

class TicketPool {
  final int id;
  final String name;
  final int availableTickets;
  final int soldTickets;
  final String status;
  final List<int> availableSeats;
  final bool seatReservation;
  final int? imageId;

  const TicketPool(
      {required this.id,
      required this.name,
      required this.availableTickets,
      required this.status,
      required this.soldTickets,
      required this.availableSeats,
      required this.seatReservation,
      required this.imageId});

  factory TicketPool.fromJson(Map<String, dynamic> json) {
    return TicketPool(
        id: json['id'],
        name: json['name'],
        availableTickets: json['availableTickets'],
        soldTickets: json['soldTickets'],
        status: json['status'],
        availableSeats: json['availableSeats'].cast<int>(),
        seatReservation: json['seatReservation'],
        imageId: json['imageId']);
  }
}

enum TicketPoolStatus { ACTIVE, INACTIVE, SOLD_OUT }
