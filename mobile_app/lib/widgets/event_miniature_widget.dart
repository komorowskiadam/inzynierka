import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/models/my_event.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/eventdetailsscreen.dart';
import '../helpers/sliderightroute.dart';

class EventMiniatureWidget extends StatelessWidget {
  const EventMiniatureWidget({super.key, required this.event});

  final MyEvent event;

  final eventNameStyle = const TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700);
  final interestedStyle = const TextStyle(
      fontSize: 18.0, fontFamily: 'Roboto', color: Colors.black);
  final participantsStyle = const TextStyle(
      fontSize: 18.0, fontFamily: 'Roboto', color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        child: Column(
          children: [
            Text(event.name, style: eventNameStyle),
            Text('Interested: ${event.interestedCount}',
                style: interestedStyle),
            Text(
              'Participants: ${event.participantsCount}',
              style: participantsStyle,
            )
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
