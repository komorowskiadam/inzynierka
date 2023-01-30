import 'package:flutter/material.dart';
import 'package:mobile_app/models/ticket_pool.dart';
import 'package:mobile_app/models/transaction.dart';
import 'package:mobile_app/screens/transaction_screen.dart';
import 'package:mobile_app/services/my_event_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:numberpicker/numberpicker.dart';

import '../helpers/sliderightroute.dart';

class BuyTicketWidgetScreen extends StatefulWidget {
  const BuyTicketWidgetScreen(
      {super.key, required this.ticketPool, required this.eventId});
  final TicketPool ticketPool;
  final int eventId;

  @override
  // ignore: no_logic_in_create_state
  State<BuyTicketWidgetScreen> createState() =>
      _BuyTicketWidgetScreenState(ticketPool);
}

class _BuyTicketWidgetScreenState extends State<BuyTicketWidgetScreen> {
  var userId;
  final TicketPool ticketPool;
  final MyEventService eventService = MyEventService();
  final storage = const FlutterSecureStorage();
  int _currentValue = 1;
  int? seatNumberValue = -1;

  _BuyTicketWidgetScreenState(this.ticketPool);

  void getUserId() async {
    var read = await storage.read(key: "userId");
    userId = int.parse(read!);
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    if (ticketPool.seatReservation) {
      seatNumberValue = ticketPool.availableSeats.first;
    }
  }

  Widget setSeatNumberWidget() {
    if (ticketPool.seatReservation == true) {
      var dropdownList = ticketPool.availableSeats
          .map<DropdownMenuItem<int>>(((e) => DropdownMenuItem<int>(
                value: e,
                child: Text("$e"),
              )))
          .toList();

      return Row(
        children: [
          const Text("Select seat number"),
          DropdownButton<int>(
              items: dropdownList,
              value: seatNumberValue,
              onChanged: (value) {
                setState(() {
                  seatNumberValue = value;
                });
              })
        ],
      );
    } else {
      return Container();
    }
  }

  Widget numberPicker() {
    if (ticketPool.seatReservation == true) {
      return Container();
    } else {
      return Column(
        children: [
          NumberPicker(
            value: _currentValue,
            minValue: 1,
            maxValue: ticketPool.availableTickets,
            onChanged: (value) => setState(() => _currentValue = value),
          ),
          Text("Selected amount: $_currentValue")
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buy new ticket")),
      body: Center(
        child: Column(
          children: [
            numberPicker(),
            setSeatNumberWidget(),
            ElevatedButton(
                onPressed: () async {
                  MyTransaction transaction;
                  if (ticketPool.seatReservation == true) {
                    transaction = await eventService.buyTickets(
                        userId, ticketPool.id, 1, widget.eventId,
                        seatNumber: seatNumberValue);
                  } else {
                    transaction = await eventService.buyTickets(
                        userId, ticketPool.id, _currentValue, widget.eventId);
                  }

                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      SlideRightRoute(
                          page: TransactionScreen(
                        transaction: transaction,
                      )));
                },
                child: const Text("Buy"))
          ],
        ),
      ),
    );
  }
}
