import 'package:mobile_app/models/my_event.dart';

class Promotion {
  final int id;
  final MyEvent event;

  const Promotion(this.id, this.event);

  factory Promotion.fromJson(Map<String, dynamic> data) {
    MyEvent event = MyEvent.fromJson(data['event']);
    return Promotion(data['id'], event);
  }
}
