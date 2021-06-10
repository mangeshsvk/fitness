import 'dart:convert';

import '../Providers/medicine.dart';
import '../Providers/timeslot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeSlots with ChangeNotifier {
  List<TimeSlot> _items = [];
  List<TimeSlot> _newItems = [];

  TimeSlots(this._items,this._newItems);

  List<TimeSlot> get items {
    return [..._items];
  }
  List<TimeSlot> get newItems {
    return [..._newItems];
  }
  TimeSlot findById(String id) {
    var timeslot = _items.firstWhere((ts) => ts.slotId == id,
        orElse: () => _newItems.firstWhere(
              (ts) => ts.slotId == id,
        ));
    return timeslot;
  }

  Future<void> fetchAndSetTimeSlots() async {
    List<TimeSlot> loadedTimeSlots = [];
    SharedPreferences prefs;
    var extractedUserData ;
    prefs = await SharedPreferences.getInstance();
    extractedUserData = prefs.getString('userTimeSlotData');
    Iterable l = json.decode(extractedUserData);
    loadedTimeSlots = List<TimeSlot>.from(l.map((model)=> TimeSlot.fromJson(model)));
    _items = loadedTimeSlots;
    notifyListeners();
  }

  Future<void> addTimeSlotsFirstTime() async {
    TimeSlot _newSlot = new TimeSlot();
    for(var i =0;i<4;i++){
      _items.add(_newSlot);
     _items[i].slotId = DateTime.now().toIso8601String()+'$i';
      switch (i) {
        case 0:
          _items[i].slotName = 'Morning';
          _items[i].slotTime = '8:00 AM';
          break;
        case 1:
          _items[i].slotName = 'Afternoon';
          _items[i].slotTime = '01:00 PM';
          break;
        case 2:
          _items[i].slotName = 'Evening';
          _items[i].slotTime = '06:00 PM';
          break;
        case 3:
          _items[i].slotName = 'Night';
          _items[i].slotTime = '06:00 PM';
          break;
      }
    }

    SharedPreferences timeSlotData = await SharedPreferences.getInstance();
    String userTimeSlotData = jsonEncode(_items);
    timeSlotData.setString('userTimeSlotData', userTimeSlotData);
    print(userTimeSlotData);
    notifyListeners();
  }

  Future<void> addTimeSlot(TimeSlot timeSlot) async {
    _items.add(timeSlot);
    for(var i =0;i<_items.length;i++){
      print(_items[i].slotName);
    }
    SharedPreferences timeSlotData = await SharedPreferences.getInstance();
    String userTimeSlotData = jsonEncode(_items);
    timeSlotData.setString('userTimeSlotData', userTimeSlotData);
    print(userTimeSlotData);
    notifyListeners();
  }

  Future<void> updateTimeSlot(String id, TimeSlot newTimeSlot) async {
    final prodIndex = _items.indexWhere((med) => med.slotId == id);
    _items[prodIndex] = newTimeSlot;
    SharedPreferences timeSlotData = await SharedPreferences.getInstance();
    String userTimeSlotData = jsonEncode(_items);
    timeSlotData.setString('userTimeSlotData', userTimeSlotData);
    print(userTimeSlotData);
    notifyListeners();
  }

  Future<void> deleteTimeSlot(TimeSlot id) async {

    _items.remove(id);
    SharedPreferences timeSlotData = await SharedPreferences.getInstance();
    String userTimeSlotData = jsonEncode(_items);
    timeSlotData.setString('userTimeSlotData', userTimeSlotData);
    print(userTimeSlotData);
    notifyListeners();
  }
}
