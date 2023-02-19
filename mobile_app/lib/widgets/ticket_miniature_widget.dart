import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/constants.dart';
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
    final titleStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w400);
    final titleStyleBold = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        backgroundColor: Constants.colorPink);

    return Padding(
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        style: buttonStyle,
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
            Row(
              children: [
                Text(
                  "Ticket for ",
                  style: titleStyle,
                ),
                Text(
                  "${ticket.eventName.substring(0, 12)}...",
                  style: titleStyleBold,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              children: [seatNumber()],
            )
          ],
        ),
      ),
    );
  }
}
