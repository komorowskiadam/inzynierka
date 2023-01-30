import 'dart:convert';

import 'package:mobile_app/helpers/constants.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:mobile_app/services/api-interceptor.dart';

class AuthService {
  Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

  Map<String, String> requestHeaders = {'Content-type': 'application/json'};

  Future<Response?> login(String username, String password) async {
    var url = Uri.parse('${Constants.BASE_URL}/auth/login');
    var body = jsonEncode({"username": username, "password": password});
    final res = client.post(url, body: body, headers: requestHeaders);
    return res;
  }

  Future<Response?> register(
      String username, String password, String name, String surname) async {
    var url = Uri.parse('${Constants.BASE_URL}/auth/signup');
    var body = jsonEncode({
      "username": username,
      "password": password,
      "role": ["user"],
      "name": name,
      "surname": surname
    });
    final res = client.post(url, body: body, headers: requestHeaders);
    return res;
  }
}
