import 'dart:convert';
import 'dart:ffi';

import 'package:mobile_app/models/ticket_pool.dart';

class MyTransaction {
  final int id;
  final double totalPrice;
  final int quantity;
  final TicketPool ticketPool;
  final String status;
  final int? seatNumber;

  MyTransaction(
      {required this.id,
      required this.totalPrice,
      required this.quantity,
      required this.ticketPool,
      required this.status,
      required this.seatNumber});

  factory MyTransaction.fromJson(Map<String, dynamic> data) {
    return MyTransaction(
        id: data['id'],
        totalPrice: data['totalPrice'],
        quantity: data['quantity'],
        status: data['status'],
        ticketPool: TicketPool.fromJson(data['ticketPoolDto']),
        seatNumber: data['seatNumber']);
  }
}
