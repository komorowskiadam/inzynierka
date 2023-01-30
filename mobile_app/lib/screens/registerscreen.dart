import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/constants.dart';
import 'package:mobile_app/helpers/sliderightroute.dart';
import 'package:mobile_app/screens/loginscreen.dart';
import 'package:mobile_app/services/auth-service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String _title = 'Register';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: RegisterScreenWidget(),
    );
  }
}

class RegisterScreenWidget extends StatefulWidget {
  const RegisterScreenWidget({super.key});

  @override
  State<RegisterScreenWidget> createState() => _RegisterScreenWidgetState();
}

class _RegisterScreenWidgetState extends State<RegisterScreenWidget> {
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();
  final _registerFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
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
  static const _buttonLabel = Text('SIGN UP',
      style: TextStyle(
        height: 1.171875,
        fontSize: 24.0,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.colorPink,
      body: SingleChildScrollView(
        child: Form(
          key: _registerFormKey,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 80, 15, 20),
                child: Text(
                  'Register to explore events!',
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
                    } else if (value.length < 5) {
                      return 'Username should have at least 5 characters';
                    }
                  },
                  onChanged: (value) {},
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
                        Icons.account_circle,
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
                padding: _formInputPadding,
                child: TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter your name';
                    } else if (value.length < 3) {
                      return 'Name should have at least 3 characters';
                    }
                  },
                  onChanged: (value) {},
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    errorStyle: _errorStyle,
                    fillColor: _fillColor,
                    enabledBorder: _enabledBorder,
                    focusedBorder: _focusedBorder,
                    labelText: 'Name',
                    hintText: 'Name',
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
                  controller: _surnameController,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter your surname';
                    } else if (value.length < 3) {
                      return 'Surname should have at least 3 characters';
                    }
                  },
                  onChanged: (value) {},
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    errorStyle: _errorStyle,
                    fillColor: _fillColor,
                    enabledBorder: _enabledBorder,
                    focusedBorder: _focusedBorder,
                    labelText: 'Surname',
                    hintText: 'Surname',
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
                      if (_registerFormKey.currentState == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Invalid data provided!"),
                        ));
                      } else {
                        if (_registerFormKey.currentState!.validate()) {
                          _registerFormKey.currentState!.save();
                          EasyLoading.show();
                          var res = await authService.register(
                              _usernameController.text,
                              _passwordController.text,
                              _nameController.text,
                              _surnameController.text);

                          switch (res!.statusCode) {
                            case 200:
                              EasyLoading.dismiss();
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(context,
                                  SlideRightRoute(page: const LoginScreen()));
                              break;
                            default:
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Invalid data provided!"),
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
                    text: 'Already registered? Login ',
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
                              Navigator.push(context,
                                  SlideRightRoute(page: const LoginScreen()));
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
