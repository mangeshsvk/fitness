import 'dart:convert';
import 'package:flutter/foundation.dart';

class TimeSlot with ChangeNotifier {
  String slotId;
  String slotName;
  String slotTime;


  TimeSlot({
    @required this.slotId,
    @required this.slotName,
    @required this.slotTime,
  });

  TimeSlot.fromJson(Map<String, dynamic> json)
      : slotId = json['slotId'],
        slotName = json['slotName'],
        slotTime = json['slotTime'];

  Map<String, dynamic> toJson() {
    return {
      'slotId': slotId,
      'slotName':slotName,
      'slotTime':slotTime,
    };
  }
}
