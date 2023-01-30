import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/constants.dart';
import 'package:mobile_app/models/my_event.dart';
import 'package:mobile_app/models/promotion.dart';
import 'package:mobile_app/screens/event_details_screen.dart';
import 'package:mobile_app/screens/event_list_screen.dart';
import 'package:mobile_app/services/my_event_service.dart';
import 'package:mobile_app/widgets/event_miniature_widget.dart';
import '../helpers/sliderightroute.dart';

class PromotionListWidget extends StatefulWidget {
  const PromotionListWidget({super.key, required this.promotions});

  final Future<List<Promotion>> promotions;

  @override
  State<PromotionListWidget> createState() => _PromotionListWidgetState();
}

class _PromotionListWidgetState extends State<PromotionListWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Promotion>>(
      future: widget.promotions,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> list = <Widget>[];
          for (var i = 0; i < snapshot.data!.length; i++) {
            list.add(PromotionMiniatureWidget(promotion: snapshot.data![i]));
          }
          return PageView(
            controller: EventListScreen.controller,
            scrollDirection: Axis.vertical,
            children: list,
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class PromotionMiniatureWidget extends StatefulWidget {
  const PromotionMiniatureWidget({super.key, required this.promotion});
  final Promotion promotion;

  @override
  State<PromotionMiniatureWidget> createState() =>
      // ignore: no_logic_in_create_state
      _PromotionMiniatureWidgetState(promotion.event, promotion.id);
}

class _PromotionMiniatureWidgetState extends State<PromotionMiniatureWidget> {
  final MyEvent event;
  final MyEventService eventService = MyEventService();
  final int promotionId;

  _PromotionMiniatureWidgetState(this.event, this.promotionId);

  final eventNameStyle = const TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700);
  final interestedStyle = const TextStyle(
      fontSize: 18.0, fontFamily: 'Roboto', color: Colors.black);
  final participantsStyle = const TextStyle(
      fontSize: 18.0, fontFamily: 'Roboto', color: Colors.black);
  final sponsoredStyle = const TextStyle(
      fontSize: 18.0, fontFamily: 'Roboto', color: Colors.white);

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
            Container(
              width: double.infinity,
              color: Colors.green,
              child: Text(
                "Sponsored",
                style: sponsoredStyle,
                textAlign: TextAlign.center,
              ),
            ),
            eventImage(),
            Text(event.name, style: eventNameStyle),
            EventMiniatureWidget.getDates(
                event.dateTimeStart, event.dateTimeEnd, interestedStyle),
            Text('Interested: ${event.interestedCount}',
                style: interestedStyle),
            Text(
              'Participants: ${event.participantsCount}',
              style: participantsStyle,
            ),
          ],
        ),
        onPressed: () async {
          eventService.visitPromotion(promotionId);

          Navigator.push(
              context,
              SlideRightRoute(
                  page: EventDetailsScreen(
                eventId: event.id,
              )));
        },
      ),
    );
  }
}
