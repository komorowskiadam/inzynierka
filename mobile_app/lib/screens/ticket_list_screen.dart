import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/helpers/constants.dart';
import 'package:mobile_app/models/ticket.dart';
import 'package:mobile_app/widgets/ticket_miniature_widget.dart';

import '../services/my_event_service.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  static const screenColor = Constants.colorViolet;

  @override
  // ignore: no_logic_in_create_state
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  final MyEventService eventService = MyEventService();
  late Future<List<Ticket>> tickets;

  @override
  void initState() {
    super.initState();
    tickets = eventService.getUserTickets();
  }

  void refreshScreen() {
    setState(() {
      tickets = eventService.getUserTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your tickets"),
        backgroundColor: TicketListScreen.screenColor,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: FutureBuilder<List<Ticket>>(
          future: tickets,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> list = <Widget>[];
              for (var i = 0; i < snapshot.data!.length; i++) {
                list.add(TicketMiniatureWidget(
                  ticket: snapshot.data![i],
                  refreshScreen: refreshScreen,
                ));
              }
              return Column(children: list);
            } else {
              return Text('${snapshot.error}');
            }
          }),
        ),
      ),
    );
  }
}
