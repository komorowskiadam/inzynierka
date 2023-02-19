import 'package:flutter/material.dart';
import 'package:mobile_app/models/ticket.dart';
import 'package:mobile_app/screens/ticket_list_screen.dart';
import 'package:mobile_app/widgets/transfer_ticket_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({super.key, required this.ticket});
  final Ticket ticket;

  @override
  // ignore: no_logic_in_create_state
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState(ticket);
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final Ticket ticket;

  _TicketDetailsScreenState(this.ticket);

  String ticketStatus = '';
  bool showTransferWidget = false;

  @override
  void initState() {
    super.initState();
    ticketStatus = ticket.status == 'SOLD' ? 'Not checked' : 'Checked';
  }

  void closeWidget() {
    setState(() {
      showTransferWidget = false;
    });
  }

  Widget transferWidget() {
    if (showTransferWidget) {
      return TransferTicketWidget(
        ticket: ticket,
        closeWidget: closeWidget,
      );
    } else {
      return Container();
    }
  }

  Widget seatNumber() {
    final amountStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.w400);
    final amountStyleBold =
        TextStyle(fontSize: 22, fontWeight: FontWeight.w600);
    if (ticket.seatNumber != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Seat number: ',
            style: amountStyle,
          ),
          Text(
            "${ticket.seatNumber}",
            style: amountStyleBold,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget status() {
    final amountStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.w400);
    final amountStyleBold =
        TextStyle(fontSize: 22, fontWeight: FontWeight.w600);
    if (ticket.seatNumber != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Status: ',
            style: amountStyle,
          ),
          Text(
            ticket.status,
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
    final titleStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w400);
    final titleStyleBold = TextStyle(fontSize: 32, fontWeight: FontWeight.w600);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: TicketListScreen.screenColor,
          title: const Text("Your ticket")),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "Your ticket for ${ticket.eventName}",
                    style: titleStyleBold,
                    overflow: TextOverflow.clip,
                    maxLines: 10,
                    softWrap: true,
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            status(),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            seatNumber(),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: QrImage(data: "${ticket.id}", size: 250),
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    showTransferWidget = true;
                  });
                },
                child: const Text("Share")),
            transferWidget(),
            Spacer(),
            Spacer(),
          ],
        ),
      )),
    );
  }
}
