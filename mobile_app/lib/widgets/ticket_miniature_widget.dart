import 'package:flutter/material.dart';
import 'package:mobile_app/models/ticket.dart';
import 'package:mobile_app/screens/ticket_details_screen.dart';

import '../helpers/sliderightroute.dart';

class TicketMiniatureWidget extends StatelessWidget {
  const TicketMiniatureWidget(
      {super.key, required this.ticket, required this.refreshScreen});
  final Ticket ticket;
  final Function() refreshScreen;

  Widget seatNumber() {
    if (ticket.seatNumber != null) {
      return Text("Seat number: ${ticket.seatNumber}");
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              SlideRightRoute(
                  page: TicketDetailsScreen(
                ticket: ticket,
              ))).then((_) {
            refreshScreen();
          });
        },
        child: Column(
          children: [
            Text("Ticket for ${ticket.eventName} "),
            Row(
              children: [seatNumber()],
            )
          ],
        ),
      ),
    );
  }
}
