import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_app/models/my_event_details.dart';
import 'package:mobile_app/models/ticket_pool.dart';
import 'package:mobile_app/services/my_event_service.dart';

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen({super.key, required this.eventId});
  final int eventId;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState(eventId);
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final int eventId;
  late Future<MyEventDetails> details;
  final MyEventService eventService = MyEventService();

  @override
  void initState() {
    super.initState();
    details = eventService.getEventById(eventId);
  }

  _EventDetailsScreenState(this.eventId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Details of event"),
        ),
        body: Center(
          child: FutureBuilder<MyEventDetails>(
            future: details,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text("Event name: ${snapshot.data!.name}"),
                    Text("Event details: ${snapshot.data!.description}"),
                    const Text("Ticket pools: "),
                    TicketPoolsListWidget(
                        ticketPools: snapshot.data!.ticketPools)
                  ],
                );
              } else {
                return Text('${snapshot.error}');
              }
            },
          ),
        ));
  }
}

class TicketPoolsListWidget extends StatelessWidget {
  const TicketPoolsListWidget({super.key, required this.ticketPools});
  final List<TicketPool> ticketPools;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < ticketPools.length; i++) {
      list.add(TicketPoolWidget(ticketPool: ticketPools[i]));
    }
    return Column(
      children: list,
    );
  }
}

class TicketPoolWidget extends StatelessWidget {
  const TicketPoolWidget({super.key, required this.ticketPool});
  final TicketPool ticketPool;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(ticketPool.name),
          Text("Available tickets: ${ticketPool.availableTickets}"),
          Text("Status: ${ticketPool.status}")
        ],
      ),
    );
  }
}
