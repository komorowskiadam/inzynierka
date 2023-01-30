import 'package:flutter/material.dart';
import 'package:mobile_app/screens/event_list_screen.dart';
import 'package:mobile_app/screens/loginscreen.dart';
import 'package:mobile_app/screens/ticket_list_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/helpers/sliderightroute.dart';
import 'package:mobile_app/screens/user_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.index});
  final int index;

  @override
  // ignore: no_logic_in_create_state
  State<HomeScreen> createState() => _HomeScreen(index);
}

class _HomeScreen extends State<HomeScreen> {
  final int startIndex;
  int currentIndex = 0;
  final storage = const FlutterSecureStorage();

  final screens = [
    const EventListScreen(),
    const TicketListScreen(),
    const UserDetailsScreen()
  ];

  _HomeScreen(this.startIndex);

  void checkToken() async {
    var token = await storage.read(key: "token");
    if (token == null) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, SlideRightRoute(page: const LoginScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
    currentIndex = startIndex;
  }

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
              backgroundColor: TicketListScreen.screenColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Your details',
              backgroundColor: UserDetailsScreen.screenColor)
        ],
        currentIndex: currentIndex,
      ),
    );
  }
}
