import 'dart:convert';
import 'package:flutter/foundation.dart';

class Medicine with ChangeNotifier {
  String medicineId;
  String medicineName;
  List<dynamic> medicineSchedule;
  List<dynamic> medicineDays;


  Medicine({
    @required this.medicineId,
    @required this.medicineName,
    @required this.medicineSchedule,
    @required this.medicineDays,
  });

  Medicine.fromJson(Map<String, dynamic> json)
      : medicineId = json['medicineId'],
        medicineName = json['medicineName'],
        medicineSchedule = json['medicineSchedule'],
        medicineDays = json['medicineDays']
  ;


  Map<String, dynamic> toJson() {
    return {
      'medicineId': medicineId,
      'medicineName':medicineName,
      'medicineSchedule':medicineSchedule,
      'medicineDays':medicineDays,
    };
  }
}
