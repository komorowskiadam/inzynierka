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
    final amountStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.w400);
    final amountStyleBold =
        TextStyle(fontSize: 22, fontWeight: FontWeight.w600);

    if (transaction.seatNumber != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Seat number: ',
            style: amountStyle,
          ),
          Text(
            '${transaction.seatNumber}',
            style: amountStyleBold,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final summaryStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w400);
    final amountStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.w400);
    final amountStyleBold =
        TextStyle(fontSize: 22, fontWeight: FontWeight.w600);

    return Scaffold(
      appBar: AppBar(
        title: Text("Summary"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: Column(children: [
        const Padding(
          padding: EdgeInsets.all(15),
        ),
        Text(
          "Transaction summary",
          style: summaryStyle,
        ),
        const Padding(
          padding: EdgeInsets.all(10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Ticket amount: ',
              style: amountStyle,
            ),
            Text(
              '${transaction.quantity}',
              style: amountStyleBold,
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(10),
        ),
        seatNumber(),
        const Padding(
          padding: EdgeInsets.all(10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Total price: ',
              style: amountStyle,
            ),
            Text(
              '${transaction.totalPrice}',
              style: amountStyleBold,
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  var res =
                      await eventService.cancelTransaction(transaction.id);
                  if (res!.statusCode == 200) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Cancel transaction")),
            const Padding(
              padding: EdgeInsets.all(25),
            ),
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
          ],
        ),
      ])),
    );
  }
}
