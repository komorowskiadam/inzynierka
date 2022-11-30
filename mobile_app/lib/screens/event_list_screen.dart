import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/constants.dart';
import 'package:mobile_app/models/my_event.dart';
import 'package:mobile_app/services/my_event_service.dart';
import 'package:mobile_app/widgets/event_miniature_widget.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  static const screenColor = Constants.colorPink;

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late Future<List<MyEvent>> events;
  final MyEventService eventService = MyEventService();
  final _controller = PageController();

  @override
  void initState() {
    super.initState();
    events = eventService.getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventListScreen.screenColor,
      appBar: AppBar(
        title: const Text("Events"),
        backgroundColor: EventListScreen.screenColor,
      ),
      body: Center(
          child: FutureBuilder<List<MyEvent>>(
        future: events,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> list = <Widget>[];
            for (var i = 0; i < snapshot.data!.length; i++) {
              list.add(EventMiniatureWidget(event: snapshot.data![i]));
            }
            return PageView(
              controller: _controller,
              scrollDirection: Axis.vertical,
              children: list,
            );
          } else {
            return Text('${snapshot.error}');
          }
        },
      )),
    );
  }
}
