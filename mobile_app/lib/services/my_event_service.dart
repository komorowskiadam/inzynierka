import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/helpers/constants.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:mobile_app/models/my_event.dart';
import 'package:mobile_app/models/my_event_details.dart';
import 'package:mobile_app/models/my_user.dart';
import 'package:mobile_app/models/ticket.dart';
import 'package:mobile_app/models/transaction.dart';
import 'package:mobile_app/services/api-interceptor.dart';

import '../models/promotion.dart';

class MyEventService {
  Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);
  final storage = const FlutterSecureStorage();

  Map<String, String> requestHeaders = {'Content-type': 'application/json'};

  Future<List<MyEvent>> getAllEvents() async {
    var url = Uri.parse('${Constants.BASE_URL}/client/events');
    final res = await client.get(url, headers: requestHeaders);
    if (res.statusCode == 200) {
      List<MyEvent> events = List<MyEvent>.from(
          json.decode(res.body).map((data) => MyEvent.fromJson(data)));

      return events;
    } else {
      throw Exception("Failed to load events");
    }
  }

  Future<MyEventDetails> getEventById(int id) async {
    var url = Uri.parse('${Constants.BASE_URL}/client/events/$id');
    final res = await client.get(url, headers: requestHeaders);

    if (res.statusCode == 200) {
      MyEventDetails details = MyEventDetails.fromJson(json.decode(res.body));

      return details;
    } else {
      throw Exception("Failed to load event with id $id");
    }
  }

  Future<MyEventDetails> takePartInEvent(int eventId, int userId) async {
    var url =
        Uri.parse('${Constants.BASE_URL}/client/takePart/$eventId,$userId');
    final res = await client.post(url, headers: requestHeaders);
    if (res.statusCode == 200) {
      MyEventDetails event = MyEventDetails.fromJson(json.decode(res.body));

      return event;
    } else {
      throw Exception("Failed to load event with id $eventId");
    }
  }

  Future<MyEventDetails> interestedInEvent(int eventId, int userId) async {
    var url =
        Uri.parse('${Constants.BASE_URL}/client/interested/$eventId,$userId');
    final res = await client.post(url, headers: requestHeaders);
    if (res.statusCode == 200) {
      MyEventDetails event = MyEventDetails.fromJson(json.decode(res.body));

      return event;
    } else {
      throw Exception("Failed to load event with id $eventId");
    }
  }

  Future<MyEvent> likeEvent(int eventId, int userId) async {
    var url =
        Uri.parse('${Constants.BASE_URL}/client/likeEvent/$eventId,$userId');
    final res = await client.post(url, headers: requestHeaders);
    if (res.statusCode == 200) {
      MyEvent event = MyEvent.fromJson(json.decode(res.body));

      return event;
    } else {
      throw Exception("Failed to load event with id $eventId");
    }
  }

  Future<MyTransaction> buyTickets(
      int userId, int ticketPoolId, int quantity, int eventId,
      {int? seatNumber}) async {
    var url = Uri.parse('${Constants.BASE_URL}/client/$eventId/buyTickets');
    var body = jsonEncode({
      "userId": userId,
      "ticketPoolId": ticketPoolId,
      "quantity": quantity,
      "seatNumber": seatNumber
    });

    final res = await client.post(url, body: body, headers: requestHeaders);

    if (res.statusCode == 200) {
      MyTransaction transaction = MyTransaction.fromJson(json.decode(res.body));
      return transaction;
    } else {
      throw Exception("Could not buy ticket");
    }
  }

  Future<Response?> payForTickets(int transactionId) async {
    var url = Uri.parse('${Constants.BASE_URL}/client/pay/$transactionId');
    final res = await client.post(url, headers: requestHeaders);
    return res;
  }

  Future<Response?> cancelTransaction(int transactionId) async {
    var url = Uri.parse(
        '${Constants.BASE_URL}/client/cancelTransaction/$transactionId');
    final res = await client.post(url, headers: requestHeaders);
    return res;
  }

  Future<List<Ticket>> getUserTickets() async {
    var read = await storage.read(key: "userId");
    int userId = int.parse(read!);
    sleep(const Duration(milliseconds: 20));

    var url = Uri.parse('${Constants.BASE_URL}/client/$userId/tickets');
    final res = await client.get(url);

    if (res.statusCode == 200) {
      List<Ticket> tickets = List<Ticket>.from(
          json.decode(res.body).map((data) => Ticket.fromJson(data)));

      return tickets;
    } else {
      throw Exception("Could not get user tickets");
    }
  }

  Future<Response?> transferTicket(int toId, int ticketId) async {
    var read = await storage.read(key: "userId");
    int userId = int.parse(read!);
    sleep(const Duration(milliseconds: 20));

    var url = Uri.parse('${Constants.BASE_URL}/client/transferTicket');
    var body =
        jsonEncode({"fromId": userId, "toId": toId, "ticketId": ticketId});

    final res = await client.post(url, body: body, headers: requestHeaders);
    return res;
  }

  Future<List<MyUser>> getAllUsers() async {
    var read = await storage.read(key: "userId");
    int userId = int.parse(read!);
    sleep(const Duration(milliseconds: 20));

    var url = Uri.parse('${Constants.BASE_URL}/auth/users');
    final res = await client.get(url, headers: requestHeaders);

    if (res.statusCode == 200) {
      List<MyUser> users = List<MyUser>.from(
          json.decode(res.body).map((data) => MyUser.fromJson(data)));

      users.removeWhere((element) => element.id == userId);
      return users;
    } else {
      throw Exception("Could not get list of users");
    }
  }

  Future<List<Promotion>> getPromotions() async {
    var url = Uri.parse('${Constants.BASE_URL}/promotions');
    final res = await client.get(url, headers: requestHeaders);

    if (res.statusCode == 200) {
      List<Promotion> promotions = List<Promotion>.from(
          jsonDecode(res.body).map((data) => Promotion.fromJson(data)));
      return promotions;
    } else {
      throw Exception("Could not obtain promotions");
    }
  }

  void visitPromotion(int id) async {
    var url = Uri.parse('${Constants.BASE_URL}/promotions/$id/visit');
    final res = await client.get(url, headers: requestHeaders);
  }
}
