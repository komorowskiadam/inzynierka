import 'package:flutter/material.dart';
import 'package:mobile_app/models/ticket.dart';
import 'package:mobile_app/screens/ticket_list_screen.dart';
import 'package:mobile_app/widgets/transfer_ticket_widget.dart';

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
    if (ticket.seatNumber != null) {
      return Text("Seat number: ${ticket.seatNumber}");
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: TicketListScreen.screenColor,
          title: const Text("Your ticket")),
      body: Center(
        child: Column(
          children: [
            Text("Your ticket for ${ticket.eventName}"),
            Text("Ticket status: $ticketStatus"),
            seatNumber(),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    showTransferWidget = true;
                  });
                },
                child: const Text("Share")),
            transferWidget()
          ],
        ),
      ),
    );
  }
}
