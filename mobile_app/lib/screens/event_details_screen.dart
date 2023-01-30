import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/constants.dart';
import 'package:mobile_app/models/my_event_details.dart';
import 'package:mobile_app/models/ticket_pool.dart';
import 'package:mobile_app/screens/buy_ticket_screen.dart';
import 'package:mobile_app/screens/event_list_screen.dart';
import 'package:mobile_app/services/my_event_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import '../helpers/sliderightroute.dart';
import '../models/event_post.dart';

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen({super.key, required this.eventId});
  final int eventId;

  @override
  // ignore: no_logic_in_create_state
  State<EventDetailsScreen> createState() => _EventDetailsScreenState(eventId);
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final int eventId;
  late Future<MyEventDetails> details;
  final MyEventService eventService = MyEventService();
  final storage = const FlutterSecureStorage();
  var userId;

  @override
  void initState() {
    super.initState();
    getUserId();
    details = eventService.getEventById(eventId);
  }

  void getUserId() async {
    var read = await storage.read(key: "userId");
    userId = int.parse(read!);
  }

  _EventDetailsScreenState(this.eventId);

  takePart() async {
    setState(() {
      details = eventService.takePartInEvent(eventId, userId);
    });
  }

  interested() async {
    setState(() {
      details = eventService.interestedInEvent(eventId, userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details of event"),
        backgroundColor: EventListScreen.screenColor,
      ),
      body: FutureBuilder<MyEventDetails>(
        future: details,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Widget eventImage() {
              if (snapshot.data!.imageId != null) {
                return FittedBox(
                  fit: BoxFit.fill,
                  child: Image.network(
                      "${Constants.BASE_URL}/images/${snapshot.data!.imageId}"),
                );
              } else {
                return Container();
              }
            }

            Widget ticketPools() {
              if (snapshot.data!.ticketPools.isNotEmpty) {
                return Column(
                  children: [
                    const Text("Ticket pools: "),
                    TicketPoolsListWidget(
                      ticketPools: snapshot.data!.ticketPools,
                      eventId: eventId,
                    ),
                  ],
                );
              } else {
                return const Text("No tickets are available for this event.");
              }
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  eventImage(),
                  Text("Event name: ${snapshot.data!.name}"),
                  ScrollableDescription(data: snapshot.data!.description),
                  Text("Location: ${snapshot.data!.location}"),
                  Text("Interested: ${snapshot.data!.interested.length}"),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              snapshot.data!.interested.contains(userId)
                                  ? Constants.colorPink
                                  : const Color.fromRGBO(220, 220, 220, 1))),
                      onPressed: () => {interested()},
                      child: const Text("Interested")),
                  Text("Will take part: ${snapshot.data!.participants.length}"),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              snapshot.data!.participants.contains(userId)
                                  ? Constants.colorViolet
                                  : const Color.fromRGBO(220, 220, 220, 1))),
                      onPressed: () => {takePart()},
                      child: const Text("Take part")),
                  ticketPools(),
                  EventPostList(
                    posts: snapshot.data!.posts,
                  )
                ],
              ),
            );
          } else {
            return Text('${snapshot.error}');
          }
        },
      ),
    );
  }
}

class TicketPoolsListWidget extends StatelessWidget {
  const TicketPoolsListWidget(
      {super.key, required this.ticketPools, required this.eventId});
  final List<TicketPool> ticketPools;
  final int eventId;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < ticketPools.length; i++) {
      list.add(TicketPoolWidget(
        ticketPool: ticketPools[i],
        eventId: eventId,
      ));
    }
    return Column(
      children: list,
    );
  }
}

class TicketPoolWidget extends StatelessWidget {
  const TicketPoolWidget(
      {super.key, required this.ticketPool, required this.eventId});
  final TicketPool ticketPool;
  final int eventId;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(ticketPool.name),
          Text("Available tickets: ${ticketPool.availableTickets}"),
          Text("Sold tickets: ${ticketPool.soldTickets}"),
          Text("Status: ${ticketPool.status}"),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  SlideRightRoute(
                      page: BuyTicketWidgetScreen(
                    ticketPool: ticketPool,
                    eventId: eventId,
                  )));
            },
            child: const Text("Buy ticket"),
          ),
        ],
      ),
    );
  }
}

class EventPostList extends StatelessWidget {
  const EventPostList({super.key, required this.posts});
  final List<EventPost> posts;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = <Widget>[];
    List<EventPost> sorted = posts;

    sorted.sort(
        (a, b) => int.parse(b.stringDate).compareTo(int.parse(a.stringDate)));

    for (var i = 0; i < sorted.length; i++) {
      list.add(EventPostWidget(eventPost: sorted[i]));
    }

    return Column(
      children: list,
    );
  }
}

class EventPostWidget extends StatefulWidget {
  const EventPostWidget({super.key, required this.eventPost});
  final EventPost eventPost;

  @override
  // ignore: no_logic_in_create_state
  State<EventPostWidget> createState() => _EventPostWidgetState(eventPost);
}

class _EventPostWidgetState extends State<EventPostWidget> {
  final EventPost eventPost;

  _EventPostWidgetState(this.eventPost);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Author: ${eventPost.author}"),
          Text("Date: ${eventPost.date}"),
          Text("Content: ${eventPost.content}"),
          Text("Likes: ${eventPost.likes.length}")
        ],
      ),
    );
  }
}

class ScrollableDescription extends StatelessWidget {
  const ScrollableDescription({super.key, required this.data});
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Descritpion:"),
        SizedBox(
            height: 150,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Html(
                    data: "<div class='description'>$data</div>",
                    style: {
                      ".description": Style(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20))
                    },
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
