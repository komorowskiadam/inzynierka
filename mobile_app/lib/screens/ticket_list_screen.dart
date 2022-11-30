import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/constants.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  static const screenColor = Constants.colorViolet;

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your tickets"),
        backgroundColor: TicketListScreen.screenColor,
      ),
      body: const Text("Tickets"),
    );
  }
}
