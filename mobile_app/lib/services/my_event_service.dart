import 'dart:convert';
import 'package:mobile_app/helpers/constants.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:mobile_app/models/my_event.dart';
import 'package:mobile_app/models/my_event_details.dart';
import 'package:mobile_app/services/api-interceptor.dart';

class MyEventService {
  Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

  Map<String, String> requestHeaders = {'Content-type': 'application/json'};

  Future<List<MyEvent>> getAllEvents() async {
    var url = Uri.parse('${Constants.BASE_URL}/client/events');
    final res = await client.get(url, headers: requestHeaders);
    if (res.statusCode == 200) {
      List<MyEvent> events = List<MyEvent>.from(
          json.decode(res.body).map((data) => MyEvent.fromJson(data)));

      return events;
    } else {
      throw Exception("Failed to load events");
    }
  }

  Future<MyEventDetails> getEventById(int id) async {
    var url = Uri.parse('${Constants.BASE_URL}/client/events/$id');
    final res = await client.get(url, headers: requestHeaders);

    if (res.statusCode == 200) {
      MyEventDetails details = MyEventDetails.fromJson(json.decode(res.body));

      return details;
    } else {
      throw Exception("Failed to load event with id $id");
    }
  }
}
