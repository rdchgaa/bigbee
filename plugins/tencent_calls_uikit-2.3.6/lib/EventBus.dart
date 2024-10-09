

import 'package:event_bus/event_bus.dart';

const String ACCEPT_CALL_EVENT_BUS_NAME = "acceptCallEventBus";
const String HANG_UP_CALL_EVENT_BUS_NAME = "hangUpCallEventBus";


EventBus eventBus = EventBus();

class CallEvent {
  late String name;
  late Map msg;
  CallEvent(this.name, this.msg);
}

class ImCallEvent {
  final String id;
  final String name;
  final dynamic data;

  const ImCallEvent({this.id = "", this.name = "", this.data});
}

// class FavoriteEvent {
//  late Map<String, dynamic> messages;
//   FavoriteEvent(Map<String, dynamic> messages) {
//     this.messages = messages;
//   }
// }
// class OpenFavoriteEvent {
//   late String msg;
//   OpenFavoriteEvent(String msg) {
//     this.msg = msg;
//   }
// }

