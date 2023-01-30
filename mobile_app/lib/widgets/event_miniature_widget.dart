import 'package:intl/intl.dart';
import 'package:mobile_app/helpers/constants.dart';
import 'package:mobile_app/models/my_event.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/event_details_screen.dart';
import '../helpers/sliderightroute.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/services/my_event_service.dart';
import 'package:like_button/like_button.dart';

class EventMiniatureWidget extends StatefulWidget {
  const EventMiniatureWidget({super.key, required this.event});
  final MyEvent event;

  @override
  State<EventMiniatureWidget> createState() =>
      // ignore: no_logic_in_create_state
      _EventMiniatureWidgetState(event);

  static Widget getDates(DateTime start, DateTime? end, TextStyle style) {
    int calculateDifference(DateTime date) {
      DateTime now = DateTime.now();
      return DateTime(date.year, date.month, date.day)
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
    }

    List<Widget> list = <Widget>[];
    List<Widget> startRow = <Widget>[];
    startRow.add(const Icon(
      Icons.calendar_month_outlined,
      color: Colors.black,
    ));

    var diff = calculateDifference(start);

    if (diff == 0) {
      var formatedDateStart = DateFormat("HH:mm").format(start);
      startRow.add(Text(
        "Today at $formatedDateStart",
        style: style,
      ));
    }
    if (diff == 1) {
      var formatedDateStart = DateFormat("HH:mm").format(start);
      startRow.add(Text(
        "Tomorrow at $formatedDateStart",
        style: style,
      ));
    } else {
      var formatedDateStart = DateFormat("E, d MMM yyyy").format(start);
      formatedDateStart += " at ";
      formatedDateStart += DateFormat("HH:mm").format(start);

      startRow.add(Text(
        formatedDateStart,
        style: style,
      ));
    }

    list.add(Row(
      children: startRow,
    ));

    if (end != null) {
      var diffInHours = end!.difference(start).inHours;

      list.add(Row(children: [
        const Icon(
          Icons.timer_sharp,
          color: Colors.black,
        ),
        Text(
          "$diffInHours hours",
          style: style,
        )
      ]));
    }

    return Column(
      children: list,
    );
  }
}

class _EventMiniatureWidgetState extends State<EventMiniatureWidget> {
  MyEvent event;
  final MyEventService eventService = MyEventService();
  final storage = const FlutterSecureStorage();
  int userId = 0;

  _EventMiniatureWidgetState(this.event);

  final eventNameStyle = const TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700);
  final interestedStyle = const TextStyle(
      fontSize: 22.0,
      fontFamily: 'Roboto',
      color: Colors.black,
      fontWeight: FontWeight.normal);
  final participantsStyle = const TextStyle(
      fontSize: 22.0, fontFamily: 'Roboto', color: Colors.black);

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  void getUserId() async {
    var read = await storage.read(key: "userId");
    userId = int.parse(read!);
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    MyEvent event2 = await eventService.likeEvent(event.id, userId);
    setState(() {
      event = event2;
    });

    if (event.likes.contains(userId)) {
      return isLiked;
    } else {
      return !isLiked;
    }
  }

  Widget eventImage() {
    if (event.imageId != null) {
      return Image.network(
        "${Constants.BASE_URL}/images/${event.imageId}",
        fit: BoxFit.fill,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: Size.zero,
            padding: EdgeInsets.zero),
        child: Column(
          children: [
            eventImage(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(event.name, style: eventNameStyle),
                  ),
                  EventMiniatureWidget.getDates(
                      event.dateTimeStart, event.dateTimeEnd, interestedStyle),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_box,
                        color: Colors.black,
                      ),
                      Text(
                        'Participants: ${event.participantsCount}',
                        style: participantsStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_alt,
                        color: Colors.black,
                      ),
                      Text('Interested: ${event.interestedCount}',
                          style: interestedStyle),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        color: Colors.black,
                      ),
                      Text(
                        event.location,
                        style: interestedStyle,
                      )
                    ],
                  )
                ],
              ),
            ),
            const Spacer(),
            const Divider(),
            LikeButton(
              onTap: onLikeButtonTapped,
              likeCount: event.likes.length,
              size: 48,
              isLiked: event.likes.contains(userId),
            ),
          ],
        ),
        onPressed: () => {
          Navigator.push(
              context,
              SlideRightRoute(
                  page: EventDetailsScreen(
                eventId: event.id,
              )))
        },
      ),
    );
  }
}
