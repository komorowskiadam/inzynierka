import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_app/screens/homescreen.dart';
import 'package:mobile_app/screens/loginscreen.dart';
import 'package:mobile_app/screens/registerscreen.dart';

void main() {
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = const Color.fromARGB(255, 255, 200, 0)
    ..backgroundColor = const Color.fromARGB(255, 0, 0, 0)
    ..indicatorColor = const Color.fromARGB(255, 255, 200, 0)
    ..textColor = const Color.fromARGB(255, 255, 200, 0)
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Role',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/Login',
      routes: {
        '/Login': (context) => const LoginScreen(),
        '/Register': (context) => const RegisterScreen(),
        '/Home': (context) => const HomeScreen(index: 0),
      },
      builder: EasyLoading.init(),
    );
  }
}
