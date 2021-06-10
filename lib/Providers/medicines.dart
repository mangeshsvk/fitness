import 'dart:convert';

import '../Providers/medicine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Medicines with ChangeNotifier {
  List<Medicine> _items = [];
  List<Medicine> _newItems = [];

  Medicines(this._items,this._newItems);

  List<Medicine> get items {
    return [..._items];
  }
  List<Medicine> get newItems {
    return [..._newItems];
  }

  Medicine findById(String id) {
    var medicine = _items.firstWhere((med) => med.medicineId == id,
       orElse: () => _newItems.firstWhere(
                  (med) => med.medicineId == id,
            ));
    return medicine;
  }

  Future<void> fetchAndSetMedicines() async {
    List<Medicine> loadedMedicines = [];
    SharedPreferences prefs;
    var extractedUserData ;
    prefs = await SharedPreferences.getInstance();
    extractedUserData = prefs.getString('userMedicineData');
    Iterable l = json.decode(extractedUserData);
    loadedMedicines = List<Medicine>.from(l.map((model)=> Medicine.fromJson(model)));
    _items = loadedMedicines;
    notifyListeners();
  }

  Future<void> addMedicine(Medicine medicine) async {
      _items.add(medicine);
      SharedPreferences medicineData = await SharedPreferences.getInstance();
      String userMedicineData = jsonEncode(_items);
      medicineData.setString('userMedicineData', userMedicineData);
      notifyListeners();
  }

  Future<void> updateMedicine(String id, Medicine newMedicine) async {
    final prodIndex = _items.indexWhere((med) => med.medicineId == id);
    _items[prodIndex] = newMedicine;
    SharedPreferences medicineData = await SharedPreferences.getInstance();
    String userMedicineData = jsonEncode(_items);
    medicineData.setString('userMedicineData', userMedicineData);
    notifyListeners();
  }

  Future<void> deleteProduct(Medicine id) async {
    _items.remove(id);
    SharedPreferences medicineData = await SharedPreferences.getInstance();
    String userMedicineData = jsonEncode(_items);
    medicineData.setString('userMedicineData', userMedicineData);
    notifyListeners();
  }
}
