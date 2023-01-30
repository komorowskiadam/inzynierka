import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/constants.dart';
import 'package:mobile_app/helpers/sliderightroute.dart';
import 'package:mobile_app/screens/homescreen.dart';
import 'package:mobile_app/screens/registerscreen.dart';
import 'package:mobile_app/services/auth-service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String _title = 'Login';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: StatefulLoginWidget(),
    );
  }
}

class StatefulLoginWidget extends StatefulWidget {
  const StatefulLoginWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StatefulLoginWidget();
}

class _StatefulLoginWidget extends State<StatefulLoginWidget> {
  _StatefulLoginWidget();
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();
  final _loginFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  static const _labelStyle = TextStyle(
      height: 1.171875,
      fontSize: 24.0,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w300,
      color: Constants.colorViolet);

  static const _hintStyle = TextStyle(
      height: 1.171875,
      fontSize: 24.0,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w300,
      color: Constants.colorViolet);

  static const _errorStyle = TextStyle(color: Constants.colorViolet);
  static const _fillColor = Colors.white;
  static const _formInputPadding =
      EdgeInsets.symmetric(horizontal: 30, vertical: 5);

  static const _enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    borderSide: BorderSide(color: Constants.colorViolet, width: 2),
  );
  static const _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    borderSide: BorderSide(color: Constants.colorViolet, width: 2),
  );
  static const _buttonLabel = Text('LOGIN',
      style: TextStyle(
        height: 1.171875,
        fontSize: 24.0,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ));

  void checkToken() async {
    var token = await storage.read(key: "token");
    if (token != null) {
      storage.delete(key: "token");
      storage.delete(key: "userId");
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.colorPink,
      body: SingleChildScrollView(
        child: Form(
          key: _loginFormKey,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 80, 15, 20),
                child: Text(
                  'Please login to enter the app!',
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: _formInputPadding,
                child: TextFormField(
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter your username';
                    }
                  },
                  onChanged: (value) {},
                  autocorrect: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    errorStyle: _errorStyle,
                    fillColor: _fillColor,
                    enabledBorder: _enabledBorder,
                    focusedBorder: _focusedBorder,
                    labelText: 'Username',
                    hintText: 'Username',
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      child: Icon(
                        Icons.email,
                        color: Constants.colorViolet,
                        size: 24,
                      ),
                    ),
                    labelStyle: _labelStyle,
                    hintStyle: _hintStyle,
                    filled: true,
                  ),
                  style: const TextStyle(
                      color: Constants.colorViolet, fontSize: 24.0),
                ),
              ),
              Padding(
                padding: _formInputPadding,
                child: TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {},
                  autocorrect: true,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    errorStyle: _errorStyle,
                    fillColor: _fillColor,
                    enabledBorder: _enabledBorder,
                    focusedBorder: _focusedBorder,
                    labelText: 'Password',
                    hintText: 'Password',
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      child: Icon(
                        Icons.password,
                        color: Constants.colorViolet,
                        size: 24,
                      ),
                    ),
                    labelStyle: _labelStyle,
                    hintStyle: _hintStyle,
                    filled: true,
                  ),
                  style: const TextStyle(
                      color: Constants.colorViolet, fontSize: 24.0),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: SizedBox(
                  height: 60.0,
                  width: MediaQuery.of(context).size.width * 1.0,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.login,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: const BorderSide(
                            color: Constants.colorViolet, width: 1.0),
                      )),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Constants.colorViolet),
                    ),
                    onPressed: () async {
                      if (_loginFormKey.currentState == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Wrong username and password!"),
                        ));
                      } else {
                        if (_loginFormKey.currentState!.validate()) {
                          _loginFormKey.currentState!.save();
                          EasyLoading.show();
                          var res = await authService.login(
                              _usernameController.text,
                              _passwordController.text);

                          switch (res!.statusCode) {
                            case 200:
                              EasyLoading.dismiss();
                              var data = jsonDecode(res.body);
                              storage.write(key: "token", value: data['token']);
                              storage.write(
                                  key: "userId", value: "${data['id']}");
                              Navigator.pushReplacement(
                                  context,
                                  SlideRightRoute(
                                      page: const HomeScreen(
                                    index: 0,
                                  )));
                              break;
                            case 401:
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Wrong username or password!"),
                              ));
                              break;
                            default:
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Wrong username or password!"),
                              ));
                              break;
                          }
                        }
                      }
                    },
                    label: _buttonLabel,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: RichText(
                  text: TextSpan(
                    text: 'Not registered? Register ',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'here ',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  SlideRightRoute(
                                      page: const RegisterScreen()));
                            },
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            color: Constants.colorViolet,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
