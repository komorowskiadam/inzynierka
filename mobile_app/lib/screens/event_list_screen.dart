import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/constants.dart';
import 'package:mobile_app/models/my_event.dart';
import 'package:mobile_app/services/my_event_service.dart';
import 'package:mobile_app/widgets/event_miniature_widget.dart';
import 'package:mobile_app/widgets/promotion_list_widget.dart';

import '../models/promotion.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});
  static final controller = PageController();

  static const screenColor = Constants.colorPink;

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late Future<List<MyEvent>> events;
  late Future<List<Promotion>> promotions;
  final MyEventService eventService = MyEventService();

  final searchController = TextEditingController();

  var searchText = "";
  @override
  void initState() {
    super.initState();
    events = eventService.getAllEvents();
    promotions = eventService.getPromotions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventListScreen.screenColor,
      appBar: AppBar(
        title: Container(
            height: 40,
            child: Row(
              children: [
                const Expanded(flex: 1, child: Text("Events")),
                Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: const InputDecoration(
                          hintText: 'Search for event',
                          hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          )),
                      style: const TextStyle(color: Colors.white),
                    )),
              ],
            )),
        backgroundColor: EventListScreen.screenColor,
        automaticallyImplyLeading: false,
      ),
      body: EventListWidget(
          events: events, promotions: promotions, searchFilter: searchText),
    );
  }
}

class EventListWidget extends StatefulWidget {
  const EventListWidget(
      {super.key,
      required this.events,
      required this.promotions,
      required this.searchFilter});
  final Future<List<MyEvent>> events;
  final Future<List<Promotion>> promotions;
  final String searchFilter;

  @override
  State<EventListWidget> createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([widget.promotions, widget.events]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> list = <Widget>[];
          for (var i = 0; i < snapshot.data![0].length; i++) {
            list.add(PromotionMiniatureWidget(promotion: snapshot.data![0][i]));
            if (widget.searchFilter.isNotEmpty && i == 0) {
              break;
            }
          }
          for (var i = 0; i < snapshot.data![1].length; i++) {
            if (widget.searchFilter.isNotEmpty) {
              bool nameCondition = snapshot.data![1][i].name
                  .toLowerCase()
                  .contains(widget.searchFilter.toLowerCase());

              bool locationCondition = snapshot.data![1][i].location
                  .toLowerCase()
                  .contains(widget.searchFilter.toLowerCase());
              if (nameCondition || locationCondition) {
                list.add(EventMiniatureWidget(event: snapshot.data![1][i]));
              }
            } else {
              list.add(EventMiniatureWidget(event: snapshot.data![1][i]));
            }
          }
          return PageView(
            controller: EventListScreen.controller,
            scrollDirection: Axis.vertical,
            children: list,
          );
        } else {
          return Text('${snapshot.error}');
        }
      },
    );
  }
}
