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

  final eventNameStyle = const TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700);
  final locationStyle = const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400);
  final locationStyleBold = const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700);

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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text(snapshot.data!.name, style: eventNameStyle),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        ScrollableDescription(data: snapshot.data!.description),
                        const Padding(
                          padding: EdgeInsets.all(15),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Location: ",
                              style: locationStyle,
                            ),
                            Text(snapshot.data!.location,
                                style: locationStyleBold)
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "On ${snapshot.data!.dateStart} at ${snapshot.data!.timeStart}",
                              style: locationStyle,
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(15),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              Column(
                                children: [
                                  Text(
                                      "Interested: ${snapshot.data!.interested.length}"),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  snapshot.data!.interested
                                                          .contains(userId)
                                                      ? Constants.colorPink
                                                      : const Color.fromRGBO(
                                                          220, 220, 220, 1))),
                                      onPressed: () => {interested()},
                                      child: const Text("Interested")),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Text(
                                      "Will take part: ${snapshot.data!.participants.length}"),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  snapshot.data!.participants
                                                          .contains(userId)
                                                      ? Constants.colorViolet
                                                      : const Color.fromRGBO(
                                                          220, 220, 220, 1))),
                                      onPressed: () => {takePart()},
                                      child: const Text("Take part")),
                                ],
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(15),
                        ),
                        ticketPools(),
                        const Padding(
                          padding: EdgeInsets.all(12),
                        ),
                        EventPostList(
                          posts: snapshot.data!.posts,
                        )
                      ],
                    ),
                  ),
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
    final title = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);

    List<Widget> list = <Widget>[];

    list.add(Text(
      "Ticket pools available: ",
      style: title,
    ));

    for (var i = 0; i < ticketPools.length; i++) {
      list.add(const Padding(
        padding: EdgeInsets.all(10),
      ));
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
    const nameStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.w600);

    const ticketsStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w400);

    Widget button() {
      if (ticketPool.status == "ACTIVE") {
        return ElevatedButton(
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
        );
      } else {
        return Container(
            decoration: BoxDecoration(
                color: Colors.orange, borderRadius: BorderRadius.circular(15)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(
                "Sale is not active",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ));
      }
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          Text(
            ticketPool.name,
            style: nameStyle,
          ),
          const Padding(
            padding: EdgeInsets.all(7),
          ),
          Text(
            "Available tickets: ${ticketPool.availableTickets}",
            style: ticketsStyle,
          ),
          const Padding(
            padding: EdgeInsets.all(7),
          ),
          Text("Sold tickets: ${ticketPool.soldTickets}", style: ticketsStyle),
          const Padding(
            padding: EdgeInsets.all(8),
          ),
          button()
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
    const discussionTitle =
        TextStyle(fontSize: 22, fontWeight: FontWeight.w600);

    sorted.sort(
        (a, b) => int.parse(b.stringDate).compareTo(int.parse(a.stringDate)));

    list.add(const Text(
      "Discussion: ",
      style: discussionTitle,
    ));

    list.add(
      const Padding(
        padding: EdgeInsets.all(8),
      ),
    );

    for (var i = 0; i < sorted.length; i++) {
      list.add(EventPostWidget(eventPost: sorted[i]));
      list.add(
        const Padding(
          padding: EdgeInsets.all(6),
        ),
      );
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

  final authorStyle =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w400);
  final dateStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic);
  final contentStyle =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text(
            "Author: ${eventPost.author}",
            style: authorStyle,
          ),
          const Padding(
            padding: EdgeInsets.all(4),
          ),
          Text(
            "${eventPost.date}",
            style: dateStyle,
          ),
          const Padding(
            padding: EdgeInsets.all(8),
          ),
          Text(eventPost.content, style: contentStyle),
          const Padding(
            padding: EdgeInsets.all(6),
          ),
          Row(
            children: [
              const Spacer(flex: 3),
              Text("Likes: ${eventPost.likes.length}"),
              const Spacer(
                flex: 1,
              ),
              const Icon(Icons.favorite_border_outlined),
              const Spacer(flex: 3),
            ],
          ),
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
    final titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

    return Column(
      children: [
        Text(
          "Descritpion:",
          style: titleStyle,
        ),
        SizedBox(
            height: 150,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Html(
                    data: "<div class='description'>$data</div>",
                    style: {
                      ".description": Style(
                          backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20))
                    },
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
