import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../helpers/constants.dart';
import '../helpers/sliderightroute.dart';
import 'loginscreen.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  static const screenColor = Constants.colorLightBlue;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UserDetailsScreen.screenColor,
        title: const Text("Your details"),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                await storage.delete(key: "userId");
                await storage.delete(key: "token");
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(
                    context, SlideRightRoute(page: const LoginScreen()));
              },
              child: const Text("Log out"))
        ],
      ),
    );
  }
}
