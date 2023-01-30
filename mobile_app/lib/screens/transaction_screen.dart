import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/sliderightroute.dart';
import 'package:mobile_app/models/transaction.dart';
import 'package:mobile_app/screens/homescreen.dart';
import 'package:mobile_app/services/my_event_service.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key, required this.transaction});
  final MyTransaction transaction;

  @override
  // ignore: no_logic_in_create_state
  State<TransactionScreen> createState() =>
      _TransactionScreenState(transaction);
}

class _TransactionScreenState extends State<TransactionScreen> {
  final MyTransaction transaction;
  final MyEventService eventService = MyEventService();

  _TransactionScreenState(this.transaction);

  Widget seatNumber() {
    if (transaction.seatNumber != null) {
      return Text("Seat number: ${transaction.seatNumber}");
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(children: [
        Text(transaction.status),
        Text('${transaction.quantity}'),
        seatNumber(),
        Text('${transaction.totalPrice}'),
        ElevatedButton(
            onPressed: () async {
              var res = await eventService.cancelTransaction(transaction.id);
              if (res!.statusCode == 200) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text("Cancel transaction")),
        ElevatedButton(
            onPressed: () async {
              var res = await eventService.payForTickets(transaction.id);
              if (res!.statusCode == 200) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    SlideRightRoute(
                        page: const HomeScreen(
                      index: 1,
                    )));
              }
            },
            child: const Text("Pay"))
      ])),
    );
  }
}
