import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/constants.dart';
import 'package:mobile_app/screens/event_list_screen.dart';
import 'package:mobile_app/screens/ticket_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int currentIndex = 0;

  final screens = [const EventListScreen(), const TicketListScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        onTap: (value) => setState(() => currentIndex = value),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Events',
              backgroundColor: EventListScreen.screenColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.airplane_ticket),
              label: 'Your tickets',
              backgroundColor: TicketListScreen.screenColor)
        ],
        currentIndex: currentIndex,
      ),
    );
  }
}
