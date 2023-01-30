import 'package:flutter/material.dart';
import 'package:mobile_app/models/my_user.dart';
import 'package:mobile_app/models/ticket.dart';

import '../services/my_event_service.dart';

class TransferTicketWidget extends StatefulWidget {
  const TransferTicketWidget(
      {super.key, required this.ticket, required this.closeWidget});
  final Ticket ticket;
  final Function() closeWidget;

  @override
  State<TransferTicketWidget> createState() =>
      _TransferTicketWidgetState(ticket);
}

class _TransferTicketWidgetState extends State<TransferTicketWidget> {
  final Ticket ticket;
  late Future<List<MyUser>> userList;
  final MyEventService eventService = MyEventService();

  @override
  void initState() {
    super.initState();
    userList = eventService.getAllUsers();
  }

  _TransferTicketWidgetState(this.ticket);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userList,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    widget.closeWidget();
                  },
                ),
                SelectUserWidget(
                  users: snapshot.data!,
                  ticketId: ticket.id,
                )
              ],
            ),
          );
        } else {
          return Text('${snapshot.error}');
        }
      }),
    );
  }
}

class SelectUserWidget extends StatefulWidget {
  const SelectUserWidget(
      {super.key, required this.users, required this.ticketId});
  final List<MyUser> users;
  final int ticketId;

  @override
  State<SelectUserWidget> createState() => _SelectUserWidgetState();
}

class _SelectUserWidgetState extends State<SelectUserWidget> {
  dynamic selectedValue;
  final MyEventService eventService = MyEventService();

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<dynamic>> dropdownItems = [];
    for (var i = 0; i < widget.users.length; i++) {
      var user = widget.users[i];
      DropdownMenuItem item = DropdownMenuItem(
        value: user.id,
        child: Text('${user.name} ${user.surname}'),
      );
      dropdownItems.add(item);
    }

    Widget transferButton() {
      if (selectedValue != null) {
        return ElevatedButton(
            onPressed: () async {
              var res = await eventService.transferTicket(
                  selectedValue, widget.ticketId);
              if (res!.statusCode == 200) {
                Navigator.pop(context);
              }
            },
            child: const Text("Transfer"));
      } else {
        return const Text("Select user");
      }
    }

    return Column(
      children: [
        DropdownButton(
          items: dropdownItems,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
          value: selectedValue,
        ),
        transferButton()
      ],
    );
  }
}
